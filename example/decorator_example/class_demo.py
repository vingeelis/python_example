#!/usr/bin/env python3
#


def decorator(cls):
    class NewClass(object):
        def __init__(self, age):
            self.total_display = 0
            # 被修饰的类
            self.wrapped = cls(age)

        def display(self):
            self.total_display += 1
            print("total display", self.total_display)
            self.wrapped.display()

    return NewClass


@decorator
class Bird(object):
    def __init__(self, age):
        self.age = age

    def display(self):
        print("My age is: ", self.age)


if __name__ == '__main__':
    eagleLord = Bird(5)
    for i in range(3):
        eagleLord.display()
