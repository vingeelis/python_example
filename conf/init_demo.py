#!/usr/bin/env python3
#

"""
相对路径导包需要在运行的时候使用对应的命令，此处使用 . 表示包： www
运行该脚本，则需要cd 到程序的根目录， 然后输入：
    python3 -m www.init_demo
"""

import sys

syspath_before = set(sys.path)

try:
    from . import set_sys_path
except ImportError:
    from www import set_sys_path

set_sys_path()
syspath_after = set(sys.path)

print(syspath_before)
print(syspath_after)
print(syspath_after - syspath_before)
