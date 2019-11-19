def decorator(_func=None, *, repeat_times=2):
    def decorator_(func):
        def wrapper(*args, **kwargs):
            for i in range(repeat_times):
                print(f"Something is happening before the function is called, round: {i + 1}/{repeat_times}.")
                func(*args, **kwargs)

        return wrapper

    if _func is None:
        return decorator_
    else:
        return decorator_(_func)


@decorator(repeat_times=3)
def say_hi(name):
    print(f"hello {name}")


say_hi('world')
