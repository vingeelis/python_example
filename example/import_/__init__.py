#!/usr/bin/env python3
#

import sys
from os.path import dirname, realpath


def init_sys_path():
    __BASEDIR = [dirname(realpath(__file__)), dirname(dirname(realpath(__file__)))]
    [sys.path.append(basedir) for basedir in __BASEDIR if basedir not in sys.path]


init_sys_path()
