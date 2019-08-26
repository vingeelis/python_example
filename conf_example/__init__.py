#!/usr/bin/env python3
#

import os


def load_conf():
    mode = os.environ.get('MODE', 'TEST')
    try:
        if mode == 'PROD':
            from conf_example.conf_prod import ConfigProd
            return ConfigProd
        elif mode == 'TEST':
            from conf_example.conf_test import ConfigTest
            return ConfigTest
        else:
            pass
    except ImportError:
        from conf_example.conf import Config
        return Config


CONFIG = load_conf()
