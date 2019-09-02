#!/usr/bin/env python3
#



import hashlib


hash = hashlib.sha256()

hash.update('qq123456'.encode('utf-8'))
print(hash.hexdigest())