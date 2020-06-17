#!/usr/bin/env python3
#


# !/usr/bin/env python
# -*- coding:utf-8 -*-

import socket

# 创建客户端socket对象
clientsocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
# 服务端IP地址和端口号元组
server_address = ('192.168.250.203', 8888)
# 客户端连接指定的IP地址和端口号
clientsocket.connect(server_address)

while True:
    # 输入数据
    data = input('please input:')
    # 客户端发送数据
    clientsocket.sendall(data.encode())
    # 客户端接收数据
    server_data = clientsocket.recv(1024)
    print('客户端收到的数据：', server_data)
    # 关闭客户端socket
    clientsocket.close()
