#!/usr/bin/env python3
#




class APIException(Exception):
    def __init__(self, value):
        self.value = value



    def __str__(self):
        return repr(self.value)




if __name__ == '__main__':
    raise APIException("Connection to ... error")