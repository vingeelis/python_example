#!/usr/bin/env python3
# -*- coding: utf-8 -*-


from functools import wraps
from flask import request, Flask, abort

app = Flask(__name__)


# Here we ensure that the key student_id is part of the request.
# Although this validation works it really does not belong in the function itself.
# Plus, perhaps there are other routes that use the exact same validation.
# So, let’s keep it DRY and abstract out any unnecessary logic with a decorator.
# @app.route('/grade', methods=['POST'])
# def update_grade():
#     json_data = request.get_json()
#     if 'student_id' not in json_data:
#         abort(400)
#     # update database
#     return "success!"

def validate_json(*expected_args):
    def decorator(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            json_object = request.get_json()
            for expected_arg in expected_args:
                if expected_arg not in json_object:
                    abort(400)
            return func(*args, **kwargs)
        return wrapper
    return decorator


@app.route('/grade', methods=['POST'])
@validate_json('student_id')
def update_grade():
    json_data = request.get_json()
    print(json_data)
    # update database
    return "success"