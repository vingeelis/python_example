import argparse
import math
import textwrap


def base_demo():
    dash_79 = '-' * 79

    """\
    @prog: program name
    @formatter_class: Passing RawDescriptionHelpFormatter as formatter_class= indicates that description and epilog are already correctly formatted and should not be line-wrapped:
    @description: display in the --help text after usage section
    @epilog: display in the --help text at the bottom
    """

    __description = f"""\
    {dash_79}
    The argparse module makes it easy to write user-friendly command-line interfaces. 
    The program defines what arguments it requires, and argparse will figure out how to parse those out of sys.argv. 
    The argparse module also automatically generates help and usage messages and issues errors when users give the program invalid arguments.
    ref: https://docs.python.org/3/library/argparse.html
    """

    __epilog = f"""\
    © Copyright 2001-2019, Python Software Foundation.
    {dash_79}
    """
    parser = argparse.ArgumentParser(
        prog=__file__,
        formatter_class=argparse.RawDescriptionHelpFormatter,
        description=textwrap.dedent(__description),
        epilog=textwrap.dedent(__epilog),
    )
    parser.add_argument('-f', '--foo', nargs='?', default='foo01', type=str, help='foo help')
    parser.add_argument('bar', nargs='*', default='bar01', type=str, help='bar help')
    # parser.print_help()

    # args = parser.parse_args(['--foo', 'foo01', 'bar01'])
    args = parser.parse_args()
    print(args)


def parents_demo():
    parent_parser = argparse.ArgumentParser(add_help=False)
    parent_parser.add_argument('--parent', type=int)

    foo_parser = argparse.ArgumentParser(parents=[parent_parser])
    foo_parser.add_argument('foo')
    args = foo_parser.parse_args(['--parent', '2', 'foo01'])
    print(args)

    bar_parent = argparse.ArgumentParser(parents=[parent_parser])
    bar_parent.add_argument('--bar')
    args = bar_parent.parse_args(['--bar', 'bar01'])
    print(args)


def prefix_char_demo():
    parser = argparse.ArgumentParser(prog='PROG', prefix_chars='-+/')
    parser.add_argument('-f')
    parser.add_argument('++bar')
    parser.add_argument('//mar')
    args = parser.parse_args('-f f01 ++bar bar01 //mar mar01'.split())
    print(args)


def fromfile_prefix_chars():
    '''
    Sometimes, for example when dealing with a particularly long argument lists,
    it may make sense to keep the list of arguments in a file rather than typing it out at the command line.
    If the fromfile_prefix_chars= argument is given to the ArgumentParser constructor,
    then arguments that start with any of the specified characters will be treated as files,
    and will be replaced by the arguments they contain.
    For example:
    :return:
    '''
    with open('args.txt', 'w') as fp:
        fp.write("-f\nbar")
    parser = argparse.ArgumentParser(fromfile_prefix_chars='@')
    parser.add_argument('-f')
    args = parser.parse_args(['-f', 'foo', '@args.txt'])
    print(args)


def const_demo():
    # 'store_const'
    # This stores the value specified by the const keyword argument.
    # The 'store_const' action is most commonly used with optional arguments that specify some sort of flag.
    # For example:
    parser = argparse.ArgumentParser()
    parser.add_argument('--foo', action='store_const', const='foo02')
    args = parser.parse_args(['--foo'])
    print(args)

    # 'append_const'
    # This stores a list, and appends the value specified by the const keyword argument to the list.
    # (Note that the const keyword argument defaults to None.)
    # The 'append_const' action is typically useful when multiple arguments need to store constants to the same list.
    # For example:
    parser = argparse.ArgumentParser()
    parser.add_argument('--str', dest='types', action='append_const', const=str)
    parser.add_argument('--int', dest='types', action='append_const', const=int)
    args = parser.parse_args('--str --str --int'.split())
    print(args)

    # '?'.
    # One argument will be consumed from the command line if possible,
    # and produced as a single item. If no command-line argument is present,
    # the value from default will be produced. Note that for optional arguments,
    # there is an additional case - the option string is present but not followed by a command-line argument.
    # In this case the value from const will be produced. Some examples to illustrate this:
    parser = argparse.ArgumentParser()
    parser.add_argument('--foo', nargs='?', const='c', default='d')
    parser.add_argument('bar', nargs='?', default='d')
    args = parser.parse_args(['xx', '--foo', 'yy'])
    print(args)
    args = parser.parse_args(['xx', '--foo'])
    print(args)
    args = parser.parse_args([])
    print(args)


def default_demo():
    # All optional arguments and some positional arguments may be omitted at the command line.
    # The default keyword argument of add_argument(), whose value defaults to None,
    # specifies what value should be used if the command-line argument is not present.
    # For optional arguments, the default value is used when the option string was not present at the command line:
    parser = argparse.ArgumentParser()
    parser.add_argument('--foo', default=11)
    args = parser.parse_args(['--foo', '12'])
    print(args)
    args = parser.parse_args([])
    print(args)

    # If the default value is a string, the parser parses the value as if it were a command-line argument.
    # In particular, the parser applies any type conversion argument,
    # if provided, before setting the attribute on the Namespace return value.
    # Otherwise, the parser uses the value as is:
    parser = argparse.ArgumentParser()
    parser.add_argument('--length', default='10', type=int)
    parser.add_argument('--width', default=10.5, type=int)
    args = parser.parse_args()
    print(args)

    # For positional arguments with nargs equal to ? or *,
    # the default value is used when no command-line argument was present:
    parser = argparse.ArgumentParser()
    parser.add_argument('foo', nargs='?', default=11)
    args = parser.parse_args(['a'])
    print(args)
    args = parser.parse_args([])
    print(args)

    # Providing default=argparse.SUPPRESS causes no attribute to be added if the command-line argument was not present:
    parser = argparse.ArgumentParser()
    parser.add_argument('--foo', default=argparse.SUPPRESS)
    args = parser.parse_args()
    print(args)
    args = parser.parse_args(['--foo', '11'])
    print(args)


def type_demo():
    parser = argparse.ArgumentParser()
    parser.add_argument('foo', type=int)
    parser.add_argument('bar', type=open)
    open('tmp.txt', 'a').close()
    args = parser.parse_args('2 tmp.txt'.split())
    print(args)

    parser = argparse.ArgumentParser()
    parser.add_argument('bar', type=argparse.FileType('w'))
    args = parser.parse_args(['out.txt'])
    print(args)

    # type= can take any callable that takes a single string argument and returns the converted value:
    def perfect_square(string):
        value = int(string)
        sqrt = math.sqrt(value)
        if sqrt != int(sqrt):
            msg = "%r is not a perfect square" % string
            raise argparse.ArgumentTypeError(msg)
        return value

    parser = argparse.ArgumentParser()
    parser.add_argument('foo', type=perfect_square)
    args = parser.parse_args(['9'])
    print(args)
    args = parser.parse_args(['8'])
    print(args)

    # The choices keyword argument may be more convenient for type checkers that simply check against a range of values:
    parser = argparse.ArgumentParser()
    parser.add_argument('foo', type=int, choices=range(5, 10))
    args = parser.parse_args(['7'])
    print(args)
    args = parser.parse_args(['11'])
    print(args)


def required_demo():
    # In general, the argparse module assumes that flags like -f and --bar indicate optional arguments,
    # which can always be omitted at the command line.
    # To make an option required, True can be specified for the required= keyword argument to add_argument():
    parser = argparse.ArgumentParser()
    parser.add_argument('--foo', required=True)
    args = parser.parse_args(['--foo', 'BAR'])
    print(args)
    args = parser.parse_args([])
    print(args)


if __name__ == '__main__':
    base_demo()
    # parents_demo()
    # prefix_char_demo()
    # fromfile_prefix_chars()
    # const_demo()
    # default_demo()
    # type_demo()
    # required_demo()

