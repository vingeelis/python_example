from typing import Union, Any, List, Optional, cast
from builtins import int

# Use Union when something could be one of a few types
l: List[Union[int, str]] = [3, 5, 'three', 'five']


# Use Any if you don't know the type of something
# dynamic to write a type for
def mystery_function():
    pass


aa: Any = mystery_function()

# If you initialize a variable with an empty container or "None"
ll: List[str] = []
oo: Optional[str] = None


# This makes each positional arg and each keyword arg a "str"
def call(self, *args: str, **kwargs: str) -> str:
    request = self.make_request(*args, **kwargs)
    return self.do_api_query(request)


# If you want dynamic attributes on your class, have it override "__setattr__"
# or "__getattr__" in a stub or in your source code.
#
# "__setattr__" allows for dynamic assignment to names
# "__getattr__" allows for dynamic access to names
class A:

    def __setattr__(self, name: str, value: int) -> None: ...

    def __getattr__(self, name: str) -> int: ...


class AA(A):

    def __setattr__(self, name: str, value: int) -> None:
        self.__class__.name = name
        self.__class__.value = value

    def __getattr__(self, name: str) -> int:
        return self.__class__.name


a = A
a.foo = 42
a.bar = 'Ex-parrot'
print(a.foo)
print(a.bar)
