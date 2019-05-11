#!/usr/bin/env python3
#


import asyncio
from threading import Thread
import time

now = lambda: time.time()


def start_loop(loop):
    asyncio.set_event_loop(loop)
    loop.run_forever()


def more_work(x):
    print('More work {}'.format(x))
    time.sleep(x)
    print('Finished more work {}'.format(x))


start = now()
new_loop = asyncio.new_event_loop()
t = Thread(target=start_loop, args=(new_loop,))
t.start()
print('TIME: {}'.format(time.time() - start))

new_loop.call_soon_threadsafe(more_work, 6)
new_loop.call_soon_threadsafe(more_work, 3)

# 启动上述代码之后，当前线程不会被block，新线程中会按照顺序执行call_soon_threadsafe方法注册的more_work方法，
# 后者因为time.sleep操作是同步阻塞的，因此运行完毕more_work需要大致6 + 3