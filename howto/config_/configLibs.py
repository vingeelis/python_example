from howto.config_.configLoader import ConfigLoaderDatabases


class Config(object):
    _LOADER_DATABASES = ConfigLoaderDatabases().initialize().prod().get('databases')

    def __init__(self, loader, *args, **kwargs) -> None:
        super().__init__()
        self._LOADER_DATABASES = loader

    def get_property(self, property_name):
        if property_name not in self._LOADER_DATABASES.keys():
            return None
        return self._LOADER_DATABASES[property_name]


class ConfigDatabases(Config):
    _DB_MYSQL = 'mysql'
    _DB_POSTGRESQL = 'postgresql'

    def __init__(self, key) -> None:
        super().__init__(Config._LOADER_DATABASES)
        self._LOADER_DATABASES = self._LOADER_DATABASES.get(key)

    @property
    def host(self):
        return self.get_property("host")

    @property
    def port(self):
        return self.get_property("port")

    @property
    def username(self):
        return self.get_property("username")

    @property
    def database(self):
        return self.get_property("database")

    @property
    def password(self):
        return self.get_property("password")


class ConfigDatabaseMysql(ConfigDatabases):

    def __init__(self) -> None:
        super().__init__(ConfigDatabases._DB_MYSQL)


class ConfigDatabasePostgresql(ConfigDatabases):

    def __init__(self) -> None:
        super().__init__(ConfigDatabases._DB_POSTGRESQL)


if __name__ == '__main__':
    conf_mysql = ConfigDatabaseMysql()
    print(conf_mysql.host)
    print(conf_mysql.port)
    print(conf_mysql.username)
    print(conf_mysql.database)
    print(conf_mysql.password)
    print()

    conf_postgresql = ConfigDatabasePostgresql()
    print(conf_postgresql.host)
    print(conf_postgresql.port)
    print(conf_postgresql.username)
    print(conf_postgresql.database)
    print(conf_postgresql.password)
