#!/usr/bin/env python
import os

import sys

import errno
from jinja2 import Environment, FileSystemLoader, StrictUndefined
import subprocess


def execute(key, value, script):
    print("Executing {}".format(script))
    os.chmod(script, 0755)
    process = subprocess.Popen("bash -c {}".format(script), shell=True, env=os.environ, stdout=sys.stdout)
    process.wait()
    if process.returncode:
        print("Failed with errorcode {}".format(process.returncode))
    return value
