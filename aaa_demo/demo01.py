class Foo(object):

    def __init__(self, name) -> None:
        super().__init__()
        self.name = name

    def __str__(self):
        return self.name


class Bar(Foo):

    # def __init__(self, name) -> None:
    #     super().__init__(name)

    def get_super(self):
        print(super(Bar, self))


if __name__ == '__main__':
    alice = Bar('alice')
    print(alice)
