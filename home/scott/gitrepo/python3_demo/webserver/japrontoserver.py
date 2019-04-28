#!/usr/bin/env python3
#
from json import JSONDecodeError

from japronto import Application
import ast


def data_handle(data_in):
    '''

    :param data_in:
    :return:
    '''
    data_out = {}

    return data_out


def basic(request):
    def return_headers(request):
        text = """Basic request properties:
          Method: {0.method}
          Path: {0.path}
          HTTP version: {0.version}
          Query string: {0.query_string}
          Query: {0.query}""".format(request)
        if request.headers:
            text += "\nHeaders:\n"
            for name, value in request.headers.items():
                text += "      {0}: {1}\n".format(name, value)
        return text

    def return_body(request):
        text = """Body related properties:
          Mime type: {0.mime_type}
          Encoding: {0.encoding}
          Body: {0.body}
          Text: {0.text}
          Form parameters: {0.form}
          Files: {0.files}
        """.format(request)
        try:
            json = request.json
        except JSONDecodeError:
            pass
        else:
            text += "\nJSON:\n"
            text += str(json)
        return text

    def return_cookies(request):
        text = """Miscellaneous:
          Matched route: {0.route}
          Hostname: {0.hostname}
          Port: {0.port}
          Remote address: {0.remote_addr},
          HTTP Keep alive: {0.keep_alive}
          Match parameters: {0.match_dict}
        """.strip().format(request)

        if request.cookies:
            text += "\nCookies:\n"
            for name, value in request.cookies.items():
                text += "      {0}: {1}\n".format(name, value)

        return text

    data_in = {}
    data_out = {}

    if request.method == 'GET':
        data_in = request.query
    if request.method == 'POST':
        data_in = ast.literal_eval(request.text)

    if data_in:
        data_out = {
            '一次预拧紧加速度': '123',
            '一次预拧紧目标值': '123',
            '二次预拧紧减速度': '123',
            '一次拧紧保持点数': '123',
            '反向消应力减速度': '123',
            '反向拧紧目标值': '123',
            '消应力到位保持点数': '123',
            '二次拧紧加速度': '123',
            '二次拧紧保持点数': '123',
            '退出减速度': '123',
            '总时间': '123'
        }

    if data_out:
        return request.Response(json=data_out)
    else:
        return False


def main():
    app = Application(debug=True)
    app.router.add_route('/', basic, methods=['GET', 'POST'])
    app.run()


if __name__ == '__main__':
    main()
