#!/usr/bin/env python3
#

import yaml
from os.path import dirname, realpath, join


class Config(type):

    def __new__(cls, name, bases, attrs):
        attrs['TIMEZONE'] = 'Asia/Shanghai'
        attrs['BASEDIR'] = dirname(dirname(realpath(__file__)))
        attrs['load_conf'] = lambda cls, conf: open(join(cls.BASEDIR, 'conf', conf)).read()
        attrs['conf_db'] = lambda cls, confload: yaml.load(confload).get('database')
        attrs['conf_www'] = lambda cls, confload: yaml.load(confload).get('www')

        # return super(Config, cls).__new__(cls, name, bases, attrs)
        # return super().__new__(cls, name, bases, attrs)
        # return type.__new__(cls, name, bases, attrs)
        return type(name, bases, attrs)
