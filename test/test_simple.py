import pytest
from pytest import fail
from configuration.simple import Simple
import os


class TestSimple():
    def test_destination_file_path(self, tmpdir):
        print(tmpdir)
        defaults_dir = os.path.join(str(tmpdir), "defaults")
        out_dir = os.path.join(str(tmpdir), "out")
        os.makedirs(out_dir)
        os.makedirs(defaults_dir)

        simple = Simple(["--destination", out_dir, "--defaults", defaults_dir])
        environ = os.environ
        os.environ['CORE-SITE.XML_test'] = "xxx"
        simple.main()
        os.environ = environ

        core_site = os.path.join(out_dir, "core-site.xml")
        assert os.path.exists(core_site)
        with open(core_site, 'r') as myfile:
            assert myfile.read().strip() == """<configuration>
<property><name>test</name><value>xxx</value></property>
</configuration>"""
