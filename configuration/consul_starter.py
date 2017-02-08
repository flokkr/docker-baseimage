#!/usr/bin/env python
import argparse
import configparser
import re
import signal
import subprocess
import os
import sys

import errno
import threading

import atexit
import time

from configuration import client_transformation

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
        self.restart = False
        self.process = None

    def run_command(self, command):
        while True:
            args = []
            if len(command) > 1:
                args.extend(command[1:])
            self.process = subprocess.Popen(" ".join(command), shell=True, env={"TERM": "linux"}, stdout=sys.stdout)
            self.restart = False
            self.process.wait()
            if self.process.returncode:
                if self.restart:
                    print("Restarting application")
                    time.sleep(2)
                else:
                    print("Error code " + str(self.process.returncode) + " restarting after 10 s")
                    time.sleep(10)

    def stop_process(self):
        if self.process and self.process.returncode != None:
            print("Killing process")
            self.process.kill()

    def main(self, args):
        parser = argparse.ArgumentParser()
        parser.add_argument("command", help="Command to start", nargs="*")
        parser.add_argument("--prefix", help="Consul tree prefix")
        parser.add_argument("--path", help="Consul tree path")
        parser.add_argument("--destination", help="Destination directory")
        args = parser.parse_args(args=args)

        if args.command:
            vt = threading.Thread(target=self.run_command, args=(args.command,), daemon=True)
            vt.start()

        atexit.register(self.stop_process)

        self.poll_consul(args.prefix, args.path, args.destination, args.command)

    def poll_consul(self, prefix, path, destination, loop=True):

        consul = consul_client.Consul()
        index = None
        resources = {}
        first = True

        try:
            configuration = ""
            configuration_entry = consul.kv.get(prefix + "/config.ini")
            if configuration_entry:
                configuration = configuration_entry[1]['Value'].decode('utf-8')
            while first or loop:
                consul_subtree_path = (prefix + "/" + path).strip("/")
                index, data = consul.kv.get(consul_subtree_path, recurse=True, index=index)
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
                            transformed_value = self.transform_value(configuration, consul, key, value)
                        relative_key = key.replace(consul_subtree_path, "").strip('/')
                        self.write_to_file(destination, relative_key, transformed_value)
                    except:
                        print("Unexpected error during a write to {}: {}".format(key, sys.exc_info()[0]))
                if not first and self.process and self.process.returncode is None and changed:
                    self.restart = True
                    os.kill(self.process.pid, signal.SIGTERM)

                first = False
        except KeyboardInterrupt:
            pass

    def write_to_file(self, destination, key, value):
        dest_file = os.path.join(destination, key)
        parent_dir = os.path.dirname(dest_file)
        mkdir_p(parent_dir)

        with open(dest_file, "wb") as file:
            file.write(value)

    def transform_value(self, configuration, consul, key, value):
        if not configuration:
            return value
        config = configparser.ConfigParser()
        config.read_string(configuration, "config.ini")
        if config['transformation']:
            for transformation in config['transformation'].keys():
                pattern = config['transformation'][transformation]
                if re.match(pattern, key):
                    return getattr(client_transformation, transformation)(value, consul)
        return value


def main():
    Starter().main(sys.argv[1:])


if __name__ == "__main__":
    main()
