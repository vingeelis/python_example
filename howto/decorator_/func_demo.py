#!/usr/bin/env python3
# -*- coding: utf-8 -*-

def foo(bar):
    return bar + 1


print(foo(2) == 3)

# first class object
print(foo)
print(foo(2))
print(type(foo))


# nested Functions
def parent(num):
    print("Printing from the parent() function.")

    def first_child():
        return "Printing from the first_child() function."

    def second_child():
        return "Printing from the second_child() function."

    try:
        assert num == 10
        return first_child
    except AssertionError:
        return second_child


foo = parent(10)
bar = parent(11)
print(foo)
print(bar)
print(foo())
print(bar())