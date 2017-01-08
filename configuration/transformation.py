#!/usr/bin/python


def to_properties(content):
    result = ""
    props = process_properties(content)
    for key in props.keys():
        result += "{}: {}\n".format(key, props[key])
    return result


def to_env(content):
    result = ""
    props = process_properties(content)
    for key in props.keys():
        result += "{}={}\n".format(key, props[key])
    return result


def to_sh(content):
    result = ""
    props = process_properties(content)
    for key in props.keys():
        result += "export {}=\"{}\"\n".format(key, props[key])
    return result


def to_cfg(content):
    result = ""
    props = process_properties(content)
    for key in props.keys():
        result += "{}=\{}\n".format(key, props[key])
    return result


def to_conf(content):
    result = ""
    props = process_properties(content)
    for key in props.keys():
        result += "export {} {}\n".format(key, props[key])
    return result


def to_xml(content):
    result = "<configuration>\n"
    props = process_properties(content)
    for key in props.keys():
        result += "<property><name>{0}</name><value>{1}</value></property>\n".format(key, props[key])
    result += "</configuration>"
    return result


def process_properties(content, sep=': ', comment_char='#'):
    """
    Read the file passed as parameter as a properties file.
    """
    props = {}
    for line in content.split("\n"):
        l = line.strip()
        if l and not l.startswith(comment_char):
            key_value = l.split(sep)
            key = key_value[0].strip()
            value = sep.join(key_value[1:]).strip().strip('"')
            props[key] = value

    return props
