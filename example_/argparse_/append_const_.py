import argparse


def action_append_const():
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


if __name__ == '__main__':
    action_append_const()
