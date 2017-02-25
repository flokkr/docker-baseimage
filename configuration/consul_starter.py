#!/usr/bin/env python
import StringIO
import argparse
import ConfigParser as configparser
import re
import signal
import subprocess
import os
import sys

import errno
import threading

import atexit
import time

import thread
import traceback

from configuration import client_transformation
from configuration import post_write_hook

sys.path = sys.path[1:]
import consul as consul_client


class Resource():
    def __init__(self, key, content):
        self.key = key
        self.content = content


def mkdir_p(path):
    try:
        os.makedirs(path)
    except OSError as exc:  # Python >2.5
        if exc.errno == errno.EEXIST and os.path.isdir(path):
            pass
        else:
            raise


class Starter():
    def __init__(self):
        self.loop = True
        self.restart = False
        self.process = None

    def run_command(self, command):
        while self.loop:
            args = []
            if len(command) > 1:
                args.extend(command[1:])
            self.process = subprocess.Popen(" ".join(command), shell=True, env=os.environ, stdout=sys.stdout)
            self.restart = False
            self.process.wait()
            if self.process.returncode:
                if self.restart:
                    print("Restarting application")
                    time.sleep(2)
                else:
                    print("Error code " + str(self.process.returncode) + " restarting after 10 s")
                    time.sleep(10)
            else:
                self.loop = False
        print("Interrupt main thread")
        os.kill(os.getpid(), signal.SIGINT)



    def stop_process(self):
        if self.process and self.process.returncode == None:
            print("Killing process")
            self.process.kill()

    def sigterm(self):
        self.loop = False
        self.stop_process()

    def main(self, args):
        parser = argparse.ArgumentParser()
        parser.add_argument("command", help="Command to start", nargs="*")
        parser.add_argument("--prefix", help="Consul tree prefix", required=True)
        parser.add_argument("--path", help="Consul tree path", required=True)
        parser.add_argument("--destination", help="Destination directory", required=True)
        args = parser.parse_args(args=args)

        if args.command:
            vt = threading.Thread(target=self.run_command, args=(args.command,))
            vt.daemon = True
            vt.start()

        signal.signal(signal.SIGTERM, self.sigterm)
        atexit.register(self.stop_process)

        self.poll_consul(args.prefix, args.path, args.destination, args.command)

    def poll_consul(self, prefix, path, destination, loop=True):

        self.consul = consul_client.Consul()
        index = None
        resources = {}
        first = True

        try:
            configuration = None
            configuration_entry = self.consul.kv.get(prefix + "/config.ini")
            if configuration_entry:
                configuration = configparser.ConfigParser()
                configuration.readfp(StringIO.StringIO(configuration_entry[1]['Value']), "config.ini")
            while first or loop:
                consul_subtree_path = (prefix + "/" + path).strip("/")
                index, data = self.consul.kv.get(consul_subtree_path, recurse=True, index=index)
                changed = []
                for d in data:
                    key = d['Key']
                    value = d['Value']
                    if key not in resources.keys():
                        resources[key] = Resource(key, "")
                    resource = resources[key]
                    if resource.content != value:
                        if value:
                            changed.append(key)
                            resource.content = value
                for key in changed:
                    value = resources[key].content
                    transformed_value = resources[key].content
                    try:
                        if configuration:
                            transformed_value = self.transform_value(configuration, self.consul, key, value)
                        relative_key = key.replace(consul_subtree_path, "").strip('/')
                        self.write_to_file(destination, relative_key, transformed_value)
                    except:
                        print("Unexpected error during a write to {}: {}".format(key, sys.exc_info()[0]))
                        traceback.print_exc()

                if "post_write_hook" in configuration.sections():
                    for hook in configuration.options('post_write_hook'):
                        pattern = configuration.get('post_write_hook', hook)
                        for key in changed:
                            if re.match(pattern, key):
                                relative_key = key.replace(consul_subtree_path, "").strip('/')
                                value = getattr(post_write_hook, hook)(key, resources[key].content, self.dest_file_path(destination, relative_key))




                if not first and self.process and self.process.returncode is None and changed:
                    self.restart = True
                    os.kill(self.process.pid, signal.SIGTERM)

                first = False
        except KeyboardInterrupt:
            pass

    def dest_file_path(self, destination, key):
        return os.path.join(destination, key)

    def write_to_file(self, destination, key, value):
        dest_file = self.dest_file_path(destination, key)
        parent_dir = os.path.dirname(dest_file)
        mkdir_p(parent_dir)
        print("Saving file from consul to {}".format(dest_file))
        with open(dest_file, "wb") as file:
            file.write(value)

    def transform_value(self, config, consul, key, value):
        if not config:
            return value
        if "transformation" in config.sections():
            for transformation in config.options('transformation'):
                pattern = config.get('transformation', transformation)
                if re.match(pattern, key):
                    value = getattr(client_transformation, transformation)(key, value, consul)
        return value


def main(args=sys.argv[1:]):
    Starter().main(args)


if __name__ == "__main__":
    main()
