#!/usr/bin/env python3
#

from bs4 import BeautifulSoup, element
import re

html = """
<html>
<head>
<title>vingilist</title>
</head>
<body>
<p class="title" name="blog"><b>My Blog</b></p>
<li><!--注释--></li>
<a href="http://blog.csdn.net/c406495762/article/details/58716886" class="sister" id="link1">Python3网络爬虫(一)：利用urllib进行简单的网页抓取</a><br/>
<a href="http://blog.csdn.net/c406495762/article/details/59095864" class="sister" id="link2">Python3网络爬虫(二)：利用urllib.urlopen发送数据</a><br/>
<a href="http://blog.csdn.net/c406495762/article/details/59488464" class="sister" id="link3">Python3网络爬虫(三)：urllib.error异常</a><br/>
</body>
</html>
"""

soup = BeautifulSoup(html, 'lxml')

# # prettify
# print(soup.prettify())


# # tag
# print(type(soup.title))
# print(type(soup.head))
# print(type(soup.body))
# print(type(soup.li))
# print(type(soup.a))
# print(type(soup.p))


# # name
# print(soup.name)
# print(soup.title.name)
# print(soup.a.name)


# # attrs
# print(soup.attrs)
# print(soup.title.attrs)
# print(soup.a.attrs)

# # attr
# print(soup.a['class'])
# print(soup.a.get('class'))


# # string
# print(soup.title.string)


# # type, name, attrs
# print(type(soup.name))
# print(soup.name)
# print(soup.attrs)


# # comment
# print(soup.li)
# print(soup.li.string)
# print(type(soup.li.string))
# if type(soup.li.string) == element.Comment:
#     print('<!--%s-->' % soup.li.string)


# # contents
# print(soup.body.contents)
# print(soup.body.contents[1])


# # children
# for child in soup.body.children:
#     print(child)


# # find_all
# print(soup.find_all('a'))


# # find_all: regex
# for tag in soup.find_all(re.compile("^b")):
#     print(tag.name)


# # find_all: list
# print(soup.find_all(['title', 'b']))


# # find_all: True
# for tag in soup.find_all(True):
#     print(tag.name)


# # find_all: attrs
# print(soup.find_all(attrs={"class": "title"}))


# # find_all: text
# print(soup.find_all(text=re.compile("Python3.*urllib.error异常")))


# # find_all: limit
# print(soup.find_all('a', limit=2))


# # find_all: kwargs
# print(soup.find_all(class_="title"))


