#!/usr/bin/env python3
#

from urllib import request
from bs4 import BeautifulSoup


def main():
    download_url = 'http://www.biqukan.com/1_1094/5403177.html'
    head = {}
    head['User-Agent'] = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.84 Safari/537.36'
    download_req = request.Request(url=download_url, headers=head)
    download_response = request.urlopen(download_req)
    download_html = download_response.read().decode('gbk', 'ignore')
    print(download_html)
    soup_texts = BeautifulSoup(download_html, 'lxml')
    texts = soup_texts.find_all(id='content', class_='showtxt')
    soup_text = BeautifulSoup(str(texts), 'lxml')
    print(soup_text.div.text.replace('\xa0', ''))


if __name__ == '__main__':
    main()
