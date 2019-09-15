#!/usr/bin/env python


import sys
from os import listdir
from os.path import dirname, basename, isdir, isfile, abspath, join as pathjoin

'''
This script is intended to implement the Step 4 of : https://wiki.vip.corp.ebay.com/pages/editpage.action?pageId=665548545
'''


def replace_lib(filepath, dst):
    src = "sys.path.append('/ebay/cassinfra/lib')"
    dst = "sys.path.append('%s')" % dst
    if filepath.endswith(".py"):
        f = open(filepath)
        r = f.read()
        s = r.replace(src, dst)
        f.close()
        f = open(filepath, 'w')
        f.write(s)
        f.close()


def recusive_lib(root_path, depth):
    files = listdir(root_path)
    for f in files:
        filepath = pathjoin(root_path, f)

        if isdir(filepath):
            depth += 1
            recusive_lib(filepath, depth)
            depth -= 1

        elif isfile(filepath):
            replace_lib(filepath, depth * '../' + 'lib/')


if __name__ == '__main__':
    root_path = './bin/'
    depth = 1
    recusive_lib(root_path, depth)
