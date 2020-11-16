from django import template
from django.utils.safestring import mark_safe

register = template.Library()


@register.simple_tag
def houyafan(a, b, c, ):
    return a + b + c


@register.filter
def jiajingze(a, b, ):
    print(a, type(b))
    return a + str(b)
