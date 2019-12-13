from typing import Mapping, MutableMapping, Sequence, Iterable, List, Set


# Use Iterable for generic iterables (anything usable in "for"),
# and Sequence where a sequence (supporting "len" and "__getitem__") is
# required
def f(ints: Iterable[int]) -> List[str]:
    return [str(x) for x in ints]


f(range(1, 3))


# Mapping describes a dict-like object (with "__getitem__") that we won't mutate
def m(my_dict: Mapping[int, str]) -> List[int]:
    # error hint here
    my_dict[5] = 'maybe'
    return list(my_dict.keys())


print(m({3: 'yes', 4: 'no'}))


# and MutableMapping one (with "__setitem__") that we might
def m(my_mapping: MutableMapping[int, str]) -> Set[str]:
    my_mapping[5] = 'maybe'
    return set(my_mapping.values())


print(m({3: 'yes', 4: 'no'}))
