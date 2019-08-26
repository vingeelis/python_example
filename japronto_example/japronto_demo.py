#!/usr/bin/env python3
#

from japronto import Application


def index(request):
    return request.Response(text='hello')


def create_user(request):
    return request.Response(text='user')


def get_user(request):
    return request.Response(text=str(request.match_dict['id']))


def start():
    app = Application()
    app.router.add_route('/', index, 'GET')
    # app.router.add_route('/user', create_user, 'POST')
    # app.router.add_route('/user/{id}', get_user, 'GET')
    app.run(debug=True, port=8002)


if __name__ == '__main__':
    start()
