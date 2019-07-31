class Person(object):
    name = ""
    age = 0


class PersonV1(Person):

    def __init__(self, personName, personAge):
        self.name = personName
        self.age = personAge

    def __str__(self):
        return 'Person(name=' + self.name + ', age=' + str(self.age) + ')'

    def __repr__(self):
        return {'name': self.name, 'age': self.age}


class PersonV2(Person):
    name = ""
    age = 0

    def __init__(self, personName, personAge):
        self.name = personName
        self.age = personAge

    def __str__(self):
        return 'Person(name=' + self.name + ', age=' + str(self.age) + ')'

    def __repr__(self):
        return '{name:' + self.name + ', age:' + str(self.age) + '}'


def printStr(p: PersonV1):
    print("<in printStr>")
    print(p)
    print(p.__str__())
    print(type(p.__str__()))
    print(str(p))
    print()


def printReprV1(p: PersonV1):
    print("<in printReprV1>")
    print(p.__repr__())
    print(type(p.__repr__()))
    try:
        print(repr(p))
    except:
        print("non-printable")
    print()


def printReprV2(p: PersonV2):
    print("<in printReprV2>")
    print(p.__repr__())
    print(type(p.__repr__()))
    print(repr(p))
    print()


if __name__ == '__main__':
    p1 = PersonV1('Pankaj', 34)
    printStr(p1)
    printReprV1(p1)
    p2 = PersonV2('Pankaj', 34)
    printReprV2(p2)
