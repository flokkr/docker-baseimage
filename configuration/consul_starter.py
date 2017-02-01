#!/usr/bin/env python
import argparse
import base64
import signal
import subprocess
import os
import sys

import errno
import threading

import atexit
import time

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
        parser.add_argument("--destination", help="Destination directory")
        args = parser.parse_args(args=args)

        if args.command:
            vt = threading.Thread(target=self.run_command, args=(args.command,), daemon=True)
            vt.start()

        atexit.register(self.stop_process)

        self.poll_consul(args.prefix, args.destination, args.command)

    def poll_consul(self, prefix, destination, loop=True):

        c = consul_client.Consul()
        index = None
        resources = {}
        first = True
        try:
            while first or loop:
                index, data = c.kv.get('conf', recurse=True, index=index)
                for d in data:
                    key = d['Key']
                    value = d['Value']
                    if key not in resources.keys():
                        resources[key] = Resource(key, "")
                    resource = resources[key]
                    changed = False
                    if resource.content != value:
                        if value:
                            changed = True
                            self.write_to_file(destination, key, value)
                            resource.content = value
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


def main():
    Starter().main(sys.argv[1:])


if __name__ == "__main__":
    main()
