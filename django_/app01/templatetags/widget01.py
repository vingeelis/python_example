from django import template

register = template.Library()


@register.simple_tag
def add(a, b):
    return a + b


@register.filter
def deco(name: str, suffix: str, ):
    return f"{name}.{suffix}"
