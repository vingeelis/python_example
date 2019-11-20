import functools


def count_calls(func):
    @functools.wraps(func)
    def wrap_count_calls(*args, **kwargs):
        wrap_count_calls.num_calls += 1
        print(f"call {wrap_count_calls.num_calls} {func.__name__!r}")
        return func(*args, **kwargs)

    wrap_count_calls.num_calls = 0
    return wrap_count_calls


@count_calls
def say_whee():
    print('Wheel!')
    




if __name__ == '__main__':
    say_whee()
    say_whee()
    say_whee()
