#!/usr/bin/env python3
#

import feedparser


def test(url='http://blog.csdn.net/together_cz/article'):
    one_page_dict = feedparser.parse(url)
    print(one_page_dict.keys())
    print('-----' * 20)
    print('href: {}'.format(one_page_dict['href']))
    print('headers: {}'.format(one_page_dict['headers']))
    print('version: {}'.format(one_page_dict['version']))
    print('status: {}'.format(one_page_dict['status']))
    print('lang: {}'.format(one_page_dict['feed']['html']['lang']))
    print('content: {}'.format(one_page_dict['feed']['meta']['content']))
    print('name: {}'.format(one_page_dict['feed']['meta']['name']))


if __name__ == '__main__':
    url_list = ['http://www.baidu.com', 'http://www.vmall.com', 'http://www.taobao.com']
    for one_url in url_list:
        print('cur url --->: {}'.format(one_url))
        try:
            test(one_url)
        except:
            print('Oops, something wrong happened!')
        print('-----' * 20)
