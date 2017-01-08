#!/usr/bin/python

import os

os.environ["CONF_DIR"] = "test/output"
os.environ["DEFAULTS_DIR"] = "test/output"
os.environ["CORE_SITE_asd.asd"] = "test"
import simple

simple.copy_defaults()