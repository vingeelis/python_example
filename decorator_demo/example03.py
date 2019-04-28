#!/usr/bin/env python3
# -*- coding: utf-8 -*-


from time import sleep


def sleep_decorator(function):
    def wrapper(*args, **kwargs):
        sleep(2)
        return function(*args, **kwargs)

    return wrapper


@sleep_decorator
def print_number(num):
    return num


print(print_number(222))

for num1 in range(1, 6):
    print(print_number(num1))
