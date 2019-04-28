#!/usr/bin/env python3
#
from types import MethodType


class Student(object):
    pass


def set_age(self, age):
    self.age = age


def set_score(self, score):
    self.score = score


if __name__ == '__main__':
    s = Student()

    # 实例属性
    s.name = 'alice'
    print(s.name)

    # 实例方法
    s.set_age = MethodType(set_age, s)
    s.set_age(13)
    print(s.age)

    # 类方法
    Student.set_score = set_score
