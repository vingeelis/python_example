def decorator(_func=None, *, repeat_times=2):
    """when a decorator uses arguments, you need to add an extra outer function"""
    """Since the function to decorate is only passed in directly if the decorator is called without arguments, 
    the function must be an optional argument. This means that the decorator arguments must all be specified by keyword. 
    You can enforce this with the special * syntax, which means that all following parameters are keyword-only:"""

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


@decorator
def say_bye(name):
    print(f"bye {name}")


say_hi('world')
say_bye('world')
