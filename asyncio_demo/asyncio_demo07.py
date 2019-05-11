#!/usr/bin/env python3
#

import asyncio
import time

'''
uture对象有几个状态：

- Pending
- Running
- Done
- Cacelled

创建future的时候，task为pending，
事件循环调用执行的时候当然就是running，
调用完毕自然就是done，
如果需要停止事件循环，就需要先把task取消。
可以使用asyncio.Task获取事件循环的task
'''

now = lambda: time.time()


async def do_some_work(x):
    print("Waiting:", x)
    await asyncio.sleep(x)
    return "Done after {}s".format(x)


async def main():
    coroutine10 = do_some_work(10)
    coroutine5 = do_some_work(5)
    coroutine3 = do_some_work(3)
    coroutine1 = do_some_work(1)

    tasks = [
        asyncio.ensure_future(coroutine10),
        asyncio.ensure_future(coroutine5),
        asyncio.ensure_future(coroutine3),
        asyncio.ensure_future(coroutine1)
    ]
    return await asyncio.gather(*tasks)


if __name__ == '__main__':

    start = now()

    loop = asyncio.get_event_loop()

    try:
        loop.run_until_complete(main())
    except KeyboardInterrupt as e:
        # print(asyncio.Task.all_tasks())
        [print(task) for task in asyncio.Task.all_tasks()]
        # True表示cannel成功，loop stop之后还需要再次开启事件循环，最后在close，不然还会抛出异常
        [print(task.cancel()) for task in asyncio.Task.all_tasks()]
        loop.stop()
        loop.run_forever()
    finally:
        loop.close()

    print('time: ', now() - start)
