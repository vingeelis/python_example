import os


def is_root(exit_if_failed=True):
    if os.geteuid() == 0:
        return True
    elif os.geteuid() != 0:
        print("not run as root!")
        if exit_if_failed:
            exit(-1)
        else:
            return False
    else:
        print('error run os.geteuid()')
