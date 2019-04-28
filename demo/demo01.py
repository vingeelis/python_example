#!/usr/bin/env python3
#

import threading
import time

lock = threading.Lock()

num = 0

t_objs = []


def run(n):
    lock.acquire()
    global num
    num += 1
    print(f"current thread_demo {n}, num is {num}")
    time.sleep(1)
    lock.release()


for i in range(50):
    t = threading.Thread(target=run, args=(f"t-{i}",))
    t.start()
    t_objs.append(t)

for t in t_objs:
    t.join()

print("----------all threads has finished----------")
print(f"{threading.current_thread(), threading.active_count()}")
print(f"num: {num}")
