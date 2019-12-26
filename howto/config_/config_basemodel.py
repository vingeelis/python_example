from pathlib import Path
from os.path import realpath
from typing import Set

import yaml
from pydantic import BaseModel


def auto_locate(_path=None):
    if not _path:
        for _path in (
                # locate config.yml in current directory
                Path(__file__).parent / 'config_basemodel.yml',
                # locate config.ylm in ../config/ directory
                Path(__file__).parent.parent / 'config' / 'config_basemodel.yml',
        ):
            if _path.exists():
                path = _path
                break
        else:
            raise Exception('config file not found')
    else:
        path = _path

    return path


class Cassinfra(BaseModel):
    cassinfra_root: str = None
    cassinfra_backup: str = None


class Database(BaseModel):
    host: str = None
    port: str = None
    user: str = None
    password: str = None
    database: str = None


class Cms(BaseModel):
    url: str = None
    userid: str = None
    token_file: str = None
    users: Set[int] = set()


class Config(BaseModel):
    cassinfra: Cassinfra = None
    database: Database = None
    cms: Cms = None

    @staticmethod
    def loader(_config_path):
        with open(_config_path) as f:
            return yaml.safe_load(f)

    @staticmethod
    def auto_locate(_path=None, _file_name=None):

        if _file_name:
            file_name = _file_name
        else:
            file_name = 'config_basemodel.yml'

        if not _path:
            for _path in (
                    # locate config.yml in current directory
                    Path(__file__).parent / file_name,
                    # locate config.ylm in ../config/ directory
                    Path(__file__).parent.parent / 'config' / file_name,
            ):
                if _path.exists():
                    path = _path
                    break
            else:
                raise Exception('config file not found')
        else:
            path = _path

        return path


config = Config(**(Config.loader(Config.auto_locate())))

print(config)
