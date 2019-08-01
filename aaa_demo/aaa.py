import argparse
import sys
import textwrap
from os.path import basename, abspath


def base_demo():
    dash_79 = '-' * 79

    """\
    prog: program name
    formatter_class: Passing RawDescriptionHelpFormatter as formatter_class= indicates that description and epilog are already correctly formatted and should not be line-wrapped:
    description: display in the --help text after usage section
    epilog: display in the --help text at the bottom
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
    parser.print_help()

    args = parser.parse_args(['--foo', 'foo01', 'bar01'])
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


def action_demo():
    # 'store'
    # This just stores the argument’s value. This is the default action.
    # For example:
    parser = argparse.ArgumentParser()
    parser.add_argument('--foo')
    args = parser.parse_args('--foo foo01'.split())
    print(args)

    # 'store_const'
    # This stores the value specified by the const keyword argument.
    # The 'store_const' action is most commonly used with optional arguments that specify some sort of flag.
    # For example:
    parser = argparse.ArgumentParser()
    parser.add_argument('--foo', action='store_const', const='foo02')
    args = parser.parse_args(['--foo'])
    print(args)

    # 'store_true' and 'store_false'
    # These are special cases of 'store_const' used for storing the values True and False respectively.
    # In addition, they create default values of False and True respectively.
    # For example:
    parser = argparse.ArgumentParser()
    parser.add_argument('--foo', action='store_true')
    parser.add_argument('--bar', action='store_false')
    parser.add_argument('--mon', action='store_false')
    args = parser.parse_args('--foo --bar'.split())
    print(args)

    # 'append'
    # This stores a list, and appends each argument value to the list.
    # This is useful to allow an option to be specified multiple times.
    # Example usage:
    parser = argparse.ArgumentParser()
    parser.add_argument('--foo', action='append')
    args = parser.parse_args('--foo 1 --foo 2'.split())
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

    # 'count'
    # This counts the number of times a keyword argument occurs.
    # For example, this is useful for increasing verbosity levels:
    parser = argparse.ArgumentParser()
    parser.add_argument('--verbose', '-v', action='count')
    args = parser.parse_args(['-vvv'])
    print(args)

    # 'version'
    # This expects a version= keyword argument in the add_argument() call,
    # and prints version information and exits when invoked:
    parser = argparse.ArgumentParser(prog=basename(__file__))
    parser.add_argument('--version', action='version', version='%(prog)s 2.0')
    args = parser.parse_args(['--version'])
    print(args)


def nargs_demo():
    # N (an integer). N arguments from the command line will be gathered together into a list. For example:
    parser = argparse.ArgumentParser()
    parser.add_argument('--foo', nargs=2)
    parser.add_argument('bar', nargs=1)
    args = parser.parse_args('c --foo a b'.split())
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

    # '*'.
    # All command-line arguments present are gathered into a list.
    # Note that it generally doesn’t make much sense to have more than one positional argument with nargs='*',
    # but multiple optional arguments with nargs='*' is possible.
    # For example:
    parser = argparse.ArgumentParser()
    parser.add_argument('--foo', nargs='*')
    parser.add_argument('--bar', nargs='*')
    parser.add_argument('mon', nargs='*')
    args = parser.parse_args('a b --foo x y --bar 1 2'.split())
    print(args)

    # '+'.
    # Just like '*', all command-line args present are gathered into a list.
    # Additionally, an error message will be generated if there wasn’t at least one command-line argument present.
    # For example:
    parser = argparse.ArgumentParser()
    parser.add_argument('foo', nargs='+')
    args = parser.parse_args(['a', 'b'])
    print(args)

    # argparse.REMAINDER.
    # All the remaining command-line arguments are gathered into a list.
    # This is commonly useful for command line utilities that dispatch to other command line utilities:
    parser = argparse.ArgumentParser(prog='PROG')
    parser.add_argument('--foo')
    parser.add_argument('command')
    parser.add_argument('args', nargs=argparse.REMAINDER)
    args = parser.parse_args('--foo foo01 cmd01 --arg1 xx yy'.split())
    print(args)



if __name__ == '__main__':
    # base_demo()
    # parents_demo()
    # prefix_char_demo()
    # fromfile_prefix_chars()
    # action_demo()
    nargs_demo()
