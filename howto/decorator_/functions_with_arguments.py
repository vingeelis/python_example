def decorator(func):
    def wrapper(*args, **kwargs):
        print("Something is happening before the function is called.")
        func(*args, **kwargs)
        print("Something is happening after the function is called.")

    return wrapper


@decorator
def say_hi(name):
    print(f"hello {name}")


say_hi('world')
