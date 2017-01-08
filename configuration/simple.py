#!/usr/bin/python
import os
import re
from shutil import copyfile

import transformation

known_formats = ['xml', 'properties', 'yaml', 'env', "sh"]
output_dir = os.environ["CONF_DIR"]

defaults_dir = "defaults"
if "DEFAULTS_DIR" in os.environ.keys():
    defaults_dir = os.environ["DEFAULTS_DIR"]

configurables = {}


def destination_file_path(name, extension):
    return os.path.join(output_dir, "{}.{}".format(name, extension))


def copy_defaults():
    for filename in os.listdir(defaults_dir):
        parts = os.path.splitext(filename)
        name = parts[0]
        extension = parts[1][1:]
        configurables[name] = extension
        print("Configurable file with defaults: {}.{}".format(name, extension))
        destionation_file = os.path.join(output_dir, filename + ".raw")
        copyfile(os.path.join(defaults_dir, filename), destionation_file)
        with open(destionation_file, "a") as file:
            file.write("\n")


def write_env_var(name, extension, key, value):
    with open(destination_file_path(name, extension) + ".raw", "a") as myfile:
        myfile.write("{}: {}\n".format(key, value))


def process_envs():
    for key in os.environ.keys():
        p = re.compile("[_\\.]")
        parts = p.split(key)
        if len(parts) > 1 and parts[1].lower() in known_formats:
            name = parts[0].lower()
            extension = parts[1].lower()
            if name not in configurables.keys():
                with open(destination_file_path(name, extension) + ".raw", "w") as myfile:
                    myfile.write("")
            configurables[name] = extension

            write_env_var(name, extension, key[len(name) + len(extension) + 2:], os.environ[key])
        else:
            for configurable_name in configurables.keys():
                if key.lower().startswith(configurable_name.lower()):
                    write_env_var(configurable_name, configurables[configurable_name], key[len(configurable_name) + 1:], os.environ[key])


def transform():
    for configurable_name in configurables.keys():
        name = configurable_name
        extension = configurables[name]

        destination_path = destination_file_path(name, extension)

        with open(destination_path + ".raw", "r") as myfile:
            content = myfile.read()
            transformer_func = getattr(transformation, "to_" + extension)
            content = transformer_func(content)
            with open(destination_path, "w") as myfile:
                myfile.write(content)


# copy the default files to file.raw in desitnation directory
copy_defaults()

# add the
process_envs()

# copy file.ext.raw to file.ext in the destination directory, and transform to the right format (eg. key: value ===> XML)
transform()
