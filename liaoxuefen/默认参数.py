#!/usr/bin/env python3
#


# configs


# variables


# functions


# instances
"""
定义默认参数要牢记一点：默认参数必须指向不变对象！
"""


def add_end01(L=[]):
    L.append('END')
    return L


def add_end02(L=None):
    if L is None:
        L = []
    L.append('end')
    return L


def main():
    print(add_end01())
    print(add_end01())
    print(add_end02())
    print(add_end02())


if __name__ == '__main__':
    main()
