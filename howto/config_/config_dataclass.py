import dataclasses
from pathlib import Path
from typing import List, Set

import dataclasses_json
from dataclasses_json import DataClassJsonMixin
from yamldataclassconfig.config import YamlDataClassConfig


class ConfigUtil:

    @staticmethod
    def make_field(_mm_field):
        return dataclasses.field(
            default=None,
            metadata=dataclasses_json.config(mm_field=_mm_field),
        )

    @classmethod
    def auto_locate(cls, _path=None, _file_name=None):

        if _file_name:
            file_name = _file_name
        else:
            file_name = 'config_dataclass.yml'

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


@dataclasses.dataclass
class Cassinfra(DataClassJsonMixin):
    cassinfra_root: str = None
    cassinfra_backup: str = None


@dataclasses.dataclass
class Database(DataClassJsonMixin):
    host: str = None
    port: int = None
    user: str = None
    password: str = None
    database: str = None


@dataclasses.dataclass
class Cms(DataClassJsonMixin):
    url: str = None
    userid: str = None
    token_file: str = None
    users: Set = None


@dataclasses.dataclass
class Config(YamlDataClassConfig):
    cassinfra: Cassinfra = ConfigUtil.make_field(Cassinfra)
    database: Database = ConfigUtil.make_field(Database)
    cms: Cms = ConfigUtil.make_field(Cms)


if __name__ == '__main__':
    config = Config()
    config.load(ConfigUtil.auto_locate())
    print(config)
