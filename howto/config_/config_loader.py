import yaml
import os


class ConfigLoader(object):
    pass


class ConfigLoaderDatabases(ConfigLoader):

    config_path = os.path.join(os.getcwd(), 'config_databases.yaml')
    configParser = None

    @classmethod
    def initialize(cls):
        # start config by reading config file
        with open(cls.config_path) as f:
            cls.configParser = yaml.safe_load(f)

        return ConfigLoaderDatabases

    @classmethod
    def prod(cls):
        # get prod values from config file
        return cls.configParser.get('prod')

    @classmethod
    def dev(cls, key):
        # get dev values from config file
        return cls.configParser.get('dev')


if __name__ == '__main__':
    _databases = ConfigLoaderDatabases().initialize().prod().get('databases')
    print(_databases)
