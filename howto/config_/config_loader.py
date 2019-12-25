import dataclasses
from datetime import datetime
from pathlib import Path

import dataclasses_json
import marshmallow
from dataclasses_json import DataClassJsonMixin
from yamldataclassconfig import create_file_path_field
from yamldataclassconfig.config import YamlDataClassConfig


@dataclasses.dataclass
class PartConfig(DataClassJsonMixin):
    # property_c: datetime = field(metadata={'dataclasses_json': {
    #     'encoder': datetime.isoformat,
    #     'decoder': datetime.fromisoformat,
    #     'mm_field': fields.DateTime(format='iso')
    # }})
    property_c: datetime = dataclasses.field(metadata=dataclasses_json.config(
        encoder=datetime.isoformat,
        decoder=datetime.fromisoformat,
        mm_field=marshmallow.fields.DateTime(format='iso'),
    ))


@dataclasses.dataclass
class Config(YamlDataClassConfig):
    property_a: int = None
    property_b: str = None
    part_config: PartConfig = dataclasses.field(
        default=None,
        # metadata={'dataclasses_json': {'mm_field': PartConfig}}
        metadata=dataclasses_json.config(mm_field=PartConfig, )
    )

    FILE_PATH: Path = create_file_path_field(Path(__file__).parent / '.config.yml')


if __name__ == '__main__':
    config = Config()
    config.load()
    print(config.property_a)
    print(config.part_config.property_c)
