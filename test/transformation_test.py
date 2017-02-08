#!/usr/bin/python

from configuration import transformation

def test_to_yaml():
    content = """
        asd: 1
        bsd: 2"""
    response = transformation.to_yaml(content)

    expected = """bsd: 2
asd: 1
"""
    assert response == expected


def test_to_yaml_array():
    content = """
        asd.1: 1
        asd.2: 2"""
    response = transformation.to_yaml(content)

    expected = """asd:
    - 2
    - 1
"""
    assert response == expected
