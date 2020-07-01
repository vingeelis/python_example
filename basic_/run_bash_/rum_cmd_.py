import os
from subprocess import Popen, PIPE


def run_cmd(desc, cmd):
    if desc and 'n' in input(desc + ' (yes/no): ').lower():
        return
    os.system(cmd)
    return True


def bash_run(comm, exit_if_failed=True, do=True, tee_console=True):
    def _run():
        process = Popen(comm, stdin=PIPE, stdout=PIPE, shell=True)
        stdout, stderr = process.communicate()
        code_return = process.returncode
        if tee_console:
            print(stdout.decode())
        if stderr:
            print(stderr.decode())
            if exit_if_failed:
                exit(-1)
        return code_return, stdout, stderr

    if do:
        return _run()
    else:
        sure = input("are you sure to proceed[Yy]: ")
        if sure.upper() == 'Y':
            return _run()
        else:
            _msg = "press [Yy] or set 'yes_or_no=True', then try again!"
            print(_msg)
            return -1, '', _msg


if __name__ == '__main__':
    run_cmd('', 'id')
    run_cmd("get user id", "id")
