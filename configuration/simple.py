#!/usr/bin/python
import os
import re
from shutil import copyfile

import argparse

import sys
from configuration import transformation


class Simple:
    def __init__(self, args):
        parser = argparse.ArgumentParser()
        parser.add_argument("--destination", help="Destination directory", required=True)
        parser.add_argument("--defaults", help="Defaults directory", required=True)
        self.args = parser.parse_args(args=args)
        # copy the default files to file.raw in desitnation directory

        self.known_formats = ['xml', 'properties', 'yaml', 'yml', 'env', "sh", "cfg", 'conf']
        self.output_dir = self.args.destination

        self.defaults_dir = self.args.defaults

        self.configurables = {}

    def destination_file_path(self, name, extension):
        return os.path.join(self.output_dir, "{}.{}".format(name, extension))

    def copy_defaults(self):
        for filename in os.listdir(self.defaults_dir):
            parts = os.path.splitext(filename)
            name = parts[0]
            extension = parts[1][1:]
            self.configurables[name] = extension
            print("Configurable file with defaults: {}.{}".format(name, extension))
            destionation_file = os.path.join(self.output_dir, filename + ".raw")
            copyfile(os.path.join(self.defaults_dir, filename), destionation_file)
            with open(destionation_file, "a") as file:
                file.write("\n")

    def write_env_var(self, name, extension, key, value):
        with open(self.destination_file_path(name, extension) + ".raw", "a") as myfile:
            myfile.write("{}: {}\n".format(key, value))

    def process_envs(self):
        for key in os.environ.keys():
            p = re.compile("[_\\.]")
            parts = p.split(key)
            if len(parts) > 1 and parts[1].lower() in self.known_formats:
                name = parts[0].lower()
                extension = parts[1].lower()
                if name not in self.configurables.keys():
                    with open(self.destination_file_path(name, extension) + ".raw", "w") as myfile:
                        myfile.write("")
                self.configurables[name] = extension

                self.write_env_var(name, extension, key[len(name) + len(extension) + 2:], os.environ[key])
            else:
                for configurable_name in self.configurables.keys():
                    if key.lower().startswith(configurable_name.lower()):
                        self.write_env_var(configurable_name, self.configurables[configurable_name], key[len(configurable_name) + 1:], os.environ[key])

    def transform(self):
        for configurable_name in self.configurables.keys():
            name = configurable_name
            extension = self.configurables[name]

            destination_path = self.destination_file_path(name, extension)

            with open(destination_path + ".raw", "r") as myfile:
                content = myfile.read()
                transformer_func = getattr(transformation, "to_" + extension)
                content = transformer_func(content)
                with open(destination_path, "w") as myfile:
                    myfile.write(content)

    def main(self):
        self.copy_defaults()

        # add the
        self.process_envs()

        # copy file.ext.raw to file.ext in the destination directory, and transform to the right format (eg. key: value ===> XML)
        self.transform()


def main():
    Simple(sys.argv[1:]).main()


if __name__ == '__main__':
    Simple(sys.argv[1:]).main()
