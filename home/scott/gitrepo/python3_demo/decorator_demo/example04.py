#!/usr/bin/env python3
# -*- coding: utf-8 -*-


from functools import wraps
from flask import g, request, redirect, url_for, Flask


def login_required(f):
    # @wraps(f): This simply preserves the metadata of the wrapped function.
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if g.user is None:
            return redirect(url_for('login', next=request.url))
        return f(*args, **kwargs)

    return decorated_function


app = Flask(__name__)


@app.route('/secret')
@login_required
def secret():
    pass
