from typing import Optional


# Optional[...] is a shorthand notation for Union[..., None]
# Whenever you have a keyword argument with default value None, you should use Optional.

def test_a(a: Optional[dict] = None) -> None:
    print(a)


def test_b(b: Optional[list] = None) -> None:
    print(b)


test_a()
test_a({'a1': 123, 'a2': 456})

test_b()
test_b([1, 2, 3])
