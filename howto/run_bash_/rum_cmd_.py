import os


def run_cmd(desc, cmd):
    if desc and 'n' in input(desc + ' (yes/no): ').lower():
        return
    os.system(cmd)
    return True


if __name__ == '__main__':
    run_cmd('', 'id')
    run_cmd("get user id", "id")
