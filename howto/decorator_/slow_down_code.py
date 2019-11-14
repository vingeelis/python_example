import functools
import time


def slow_down(secs):
    """sleep secs seconds before calling the function"""
    def decorator(func):
        @functools.wraps(func)
        def wrapper(*args, **kwargs):
            time.sleep(secs)
            return func(*args, **kwargs)

        return wrapper

    return decorator


@slow_down(0.5)
def countdown(from_number):
    if from_number < 1:
        print("lift off")
    else:
        print(from_number)
        countdown(from_number - 1)


countdown(5)
