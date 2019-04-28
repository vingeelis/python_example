#!/usr/bin/env python3
#

"""
当前目录是二级目录，使用相对路径导包

1 需要在包所在的__init__.py中输入：
import sys
from os.path import dirname, realpath
__BASEDIR = dirname(dirname(realpath(__file__)))
def set_sys_path():
    sys.path.append(__BASEDIR)

2 运行该脚本，则需要cd 到程序的根目录， 然后输入：
    python3 -m conf.init_demo
"""

import sys
from . import init_sys_path

syspath_before = set(sys.path)
print("sys.path before: ", syspath_before)

init_sys_path()

syspath_after = set(sys.path)
print("sys.path.after: ", syspath_after)

print("sys.path diff: ", syspath_after - syspath_before)
