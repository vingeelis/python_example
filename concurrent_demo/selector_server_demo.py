#!/usr/bin/env python3
#

'''
fileobj: 注册的文件对象
fd: 底层的文件描述符
events: 文件对象必须等待的事件
data: 与文件对象相关联的数据, 例如可用来存储每个客户端的会话ID.
'''

import selectors
import socket


def NEW_SOCKET():
    sock = socket.socket()
    SERVER_ADDR = '192.168.250.16'
    SERVER_PORT = 9000
    BACKLOG = 10000

    sock.bind((SERVER_ADDR, SERVER_PORT))
    sock.listen(BACKLOG)
    sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    sock.setblocking(False)
    return sock


def accept(sock: socket.socket, mask):
    conn, addr = sock.accept()
    print(f"accept: {conn}, from: {addr}, mask:{mask}\n")
    conn.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    conn.setblocking(False)
    sel.register(conn, selectors.EVENT_READ, read)


def read(conn: socket.socket, mask):
    data = conn.recv(1024)
    if data:
        print(f"read: {repr(data)}, conn: {conn}\n, mask: {mask}")
        conn.send(data)
    else:
        print('closing: ', conn)
        print()
        sel.unregister(conn)
        conn.close()


def main():
    sock = NEW_SOCKET()
    sel.register(sock, selectors.EVENT_READ, accept)

    while True:
        events = sel.select()  # 默认阻塞，有活动连接就返回会动的连接列表
        for key, mask in events:  # key是个selectorkey对象, 有属性fileobj, data, 等
            callback = key.data  # accept
            callback(key.fileobj, mask)  # key.fileobj，文件句柄
        print(f"events: {events}")


if __name__ == '__main__':
    sel = selectors.DefaultSelector()
    main()
