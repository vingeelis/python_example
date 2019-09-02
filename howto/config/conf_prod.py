#!/usr/bin/env python3
#

from howto.config import Config


class ConfigProd(object, metaclass=Config):
    def __init__(self, **kw):
        __conf = self.load_conf('conf_prod.yml')
        self.DEBUG = False
        self.CONF_DB = self.conf_db(__conf)
        self.CONF_WWW = self.conf_www(__conf)
        super(ConfigProd, self).__init__(**kw)


def main():
    conf = ConfigProd()
    print(conf.TIMEZONE)
    print(conf.BASEDIR)
    print(conf.DEBUG)
    print(conf.CONF_DB)
    print(conf.CONF_WWW)


if __name__ == '__main__':
    main()
