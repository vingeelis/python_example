import yaml


with open('config.yml') as cfg:
    conf = yaml.safe_load(cfg)

[print(kv) for kv in conf.items()]