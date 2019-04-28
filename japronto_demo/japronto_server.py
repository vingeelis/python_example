#!/usr/bin/env python3
#

from japronto import Application
import ast


def data_handle(data_in):
    '''

    :param data_in:
    :return:
    '''

    if not data_in:
        print('no input_demo found')
        return
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

    return data_out


def basic(request):
    data_in = ast.literal_eval(request.text)

    # for no, entry in data_in.items():
    #     print('no: ', no)
    #     print('entry: ', entry)

    data_out = data_handle(data_in)

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
