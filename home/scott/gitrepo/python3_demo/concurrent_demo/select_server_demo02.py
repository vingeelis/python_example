#!/usr/bin/env python3
#


import select
import socket
import queue

server = socket.socket()
server.bind(('192.168.250.203'))
server.listen(2048)
server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)  # time wait reuse
server.setblocking(False)  # 不阻塞

msg_dict = {}
inputs = [server, ]
outputs = []

while True:
    readable, writeable, exceptional = select.select(inputs, outputs, inputs)
    print(readable, writeable, exceptional)

    # tcp读请求
    for r in readable:
        # 如果这连接是第一次握手，那就是要建立新连接
        if r is server:
            conn, addr = server.accept()
            print('来了个新连接: ', addr)

            # 这个新建立的连接还没发数据过来，现在就接收的话程序就报错了，
            # 所以要想实现这个客户端发数据来时server端能知道，
            # 就需要让select再监测这个conn
            inputs.append(conn)

            # 初始化一个队列，后面存要返回给这个客户端的数据
            msg_dict[conn] = queue.Queue()
        # 如果这个连接不是第一次握手，那就是收数据
        else:
            data = r.recv(1024)
            print("收到数据: ", data)
            msg_dict[r].put(data)

            # 放入返回的连接队列里
            outputs.append(r)

    # tcp写请求
    for w in writeable:
        data_to_send = msg_dict[w].get()
        w.send(data_to_send)

        # 写请求处理完毕，从select监控队列中移除
        outputs.remove(w)

    for e in exceptional:
        if e in outputs:
            outputs.remove(e)
        inputs.remove(e)
        del msg_dict[e]
