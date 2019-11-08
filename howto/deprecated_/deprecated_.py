import warnings
import functools


def deprecated(func):
    """This is a decorator which can be used to mark functions as deprecated.
    It will result in a warning being emitted when the function is used."""

    @functools.wraps(func)
    def new_func(*args, **kwargs):
        warnings.simplefilter('always', DeprecationWarning)
        warnings.warn("Call to deprecated function {}.".format(func.__name__),
                      category=DeprecationWarning,
                      stacklevel=2)
        warnings.simplefilter('default', DeprecationWarning)
        return func(*args, **kwargs)

    return new_func


@deprecated
def some_old_function(x, y):
    return x + y


class demo_02(object):
    @deprecated
    def some_old_method(self, x, y):
        return x + y


if __name__ == '__main__':
    some_old_function(1, 2)
    demo_02().some_old_method(1, 2)
