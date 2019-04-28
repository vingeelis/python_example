#!/usr/bin/env python3
#

import os


def load_conf():
    mode = os.environ.get('MODE', 'TEST')
    try:
        if mode == 'PROD':
            from conf.conf_prod import ConfigProd
            return ConfigProd
        elif mode == 'TEST':
            from conf.conf_test import ConfigTest
            return ConfigTest
        else:
            pass
    except ImportError:
        from conf.conf import Config
        return Config


CONFIG = load_conf()
