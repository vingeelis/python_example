#!/usr/bin/env python3
# -*- coding: utf-8 -*-


def my_decorator(some_function):
    def wrapper():
        num = 10
        if num == 10:
            print('yes!')
        else:
            print('no')
        some_function()
        print("Something is happening after some_function() is called.")

    return wrapper


def some_function_01():
    print("Wheee!")


some_function_01 = my_decorator(some_function_01)
some_function_01()


@my_decorator
def some_function_02():
    print("Wheee!")

some_function_02()