import functools
import sys


def version_required(vs: str):
    vs = [int(v) for v in vs.split('.')]
    major = vs[0]
    minor = vs[1]

    if sys.version_info.major < major:
        raise Exception("Must be using Python 3")
    elif sys.version_info.minor < minor:
        raise Exception("Version must be >= 3.7")


def debug(func):
    """print the function signature and return value"""

    @functools.wraps(func)
    def wrapper(*args, **kwargs):
        args_repr = [repr(a) for a in args]
        kwargs_repr = [f"{k}={v!r}" for k, v in kwargs.items()]
        signature = ", ".join(args_repr + kwargs_repr)
        print(f"calling {func.__name__}({signature}): ")
        value = func(*args, **kwargs)
        print(f"{func.__name__!r} returned: {value!r}")
        print()
        return value

    return wrapper


def mem_analyse():
    from pympler import asizeof
    print(asizeof.asizeof(version_required))


def time_analyse():
    from timeit import timeit
    print(timeit(stmt='ver', setup='ver=version_required("3.7")', globals=globals()))
    print(timeit(stmt='ver', setup='ver=version_required("3.8")', globals=globals()))


if __name__ == '__main__':
    mem_analyse()
    time_analyse()
