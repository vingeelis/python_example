import functools
import sys
import datetime


def epoch_to_human_readable(epoch_in_nanos):
    """how to get current timestamps in nanosencond

        # %s seconds since 1970-01-01 00:00:00 UTC
        # %N nanoseconds (000000000..999999999)
        date +%s%N
    """
    nanos_per_second = 10 ** 9
    seconds = int(epoch_in_nanos) / nanos_per_second
    nanos = int(epoch_in_nanos) % nanos_per_second
    dt = datetime.datetime.fromtimestamp(seconds)
    # > stand for right justify

    # print([f"{str(dt):>0{size}}" for dt, size in
    #        {dt.year: 4, dt.month: 2, dt.day: 2, dt.hour: 2, dt.minute: 2, dt.second: 2, nanos: 9}.items()])
    print('-'.join([f"{str(dt):>0{size}}" for dt, size in {
        dt.year: 4, dt.month: 2, dt.day: 2, }.items()])
          + ' ' +
          ':'.join([f"{str(tm):>0{size}}" for tm, size in {
              dt.hour: 2, dt.minute: 2, dt.second: 2, }.items()])
          + '.' +
          f"{str(nanos):>09}")


def sig_reg():
    import signal

    def _sigterm(signum, frame):
        if signum in (signal.SIGTERM, signal.SIGINT):
            print("SIGTERM/SIGINT received, exiting...")
            exit(0)

    signal.signal(signal.SIGTERM, _sigterm)
    signal.signal(signal.SIGINT, _sigterm)


def version_required():
    if sys.version_info < (3, 7):
        raise Exception("Python version should be at least 3.7")


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


def analyse_mem():
    from pympler import asizeof
    print(asizeof.asizeof(version_required))


def analyse_time():
    from timeit import timeit
    print(timeit(stmt='ver', setup='ver=version_required("3.7")', globals=globals()))
    print(timeit(stmt='ver', setup='ver=version_required("3.8")', globals=globals()))


if __name__ == '__main__':
    # analyse_mem()
    # analyse_time()
    epoch_to_human_readable(1575254030086532336)
