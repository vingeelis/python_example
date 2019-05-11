#!/usr/bin/env python3
#


def main():
    while True:
        data = int(input('请输入一个整数: '))

        assert data > 0

        if data == 0:
            break
        elif 90 <= data <= 100:
            print('Outstanding')
        elif 80 <= data < 90:
            print('Good')
        elif 60 <= data < 80:
            print('Pass ')
        else:
            print('Fail')


if __name__ == '__main__':
    main()
