import os
import argparse
import textwrap
from dataclasses import dataclass
from os.path import realpath
import yaml

PROJECT_NAME = "Cassinfra3"


def get_args():
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
    parser.add_argument('-c', '--conf_file', nargs='?', type=str, help='config file')

    return parser.parse_args()


# class Loader(object):
#
#     def __init__(self) -> None:
#         _config = f'{PROJECT_NAME}_CONFIG'
#
#         config_path = None
#
#         print(_config)
#         print(_config in os.environ)
#
#         # getting var from Environment Variables
#         if _config in os.environ:
#             config_path = os.environ[_config]
#
#         # getting var from CLI arguments
#         if get_args().conf_file:
#             config_path = get_args().conf_file
#
#         print(config_path)


class ConfigLoader(object, ):
    """
    ConfigLoader class should be singleton, and same as to it's inheritors
    """
    config_parser = dict()

    @classmethod
    def load(cls, __profile_user=None):
        """ example
        prod:       ../config/config.yml
        victor:     ../config/config_victor.yml
        """
        __CONFIG_DIR = './'
        __CONFIG_BASENAME = 'config'
        __CONFIG_SUFFIX = '.yml'

        if __profile_user:
            config_path = realpath(
                os.path.join(__CONFIG_DIR, __CONFIG_BASENAME + "_{}".format(__profile_user) + __CONFIG_SUFFIX))
        else:
            config_path = realpath(os.path.join(__CONFIG_DIR, __CONFIG_BASENAME + __CONFIG_SUFFIX))

        with open(config_path) as f:
            cls.config_parser = yaml.safe_load(f)

        return cls.config_parser


@dataclass
class Cassinfra:
    CASSINFRA_ROOT: str
    CASSINFRA_BACKUP: str


@dataclass
class Database:
    host: str
    port: int
    user: str
    password: str
    name: str
    auto_commit: bool


class Config(object):
    def __init__(self, __profile_user=None, ):
        self.__profile_user = __profile_user
        self.__parser = ConfigLoader.load(__profile_user)

    @property
    # def database(self): return self.__parser.get('database')
    def database(self):
        return Database(**self.__parser.get('database'))

    @property
    def cms(self):
        return self.__parser.get('cms')

    @property
    def cassinfra_rc(self):
        return self.__parser.get('cassinfra_rc')


if __name__ == '__main__':
    print(Config().database.host)
