#!/usr/bin/env python3
#

import threading
import asyncio


@asyncio.coroutine
def hello():
    print('hello world! (%s)' % threading.current_thread())
    yield from asyncio.sleep(1)
    print('hello again (%s)' % threading.current_thread())


def hello_event():
    loop = asyncio.get_event_loop()
    tasks = [hello(), hello()]
    loop.run_until_complete(asyncio.wait(tasks))
    # loop.run_until_complete(asyncio.wait(tasks))
    loop.close()

@asyncio.coroutine
def wget(host):
    print('wget %s...' % host)
    connect = asyncio.open_connection(host, 80)
    header = 'GET / HTTP/1.0\r\nHost: %s\r\n\r\n' % host
    reader, writer = yield from connect
    writer.write(header.encode('utf-8'))
    yield from writer.drain()
    while True:
        line = yield from reader.readline()
        if line == b'\r\n':
            break
        print('%s header > %s' % (host, line.decode('utf-8').rstrip()))
    writer.close()

def wget_event():
    loop = asyncio.get_event_loop()
    tasks = [wget(host) for host in ['www.sina.com.cn', 'www.sohu.com', 'www.163.com']]
    loop.run_until_complete(asyncio.wait(tasks))
    loop.close()


if __name__ == '__main__':
    wget_event()


