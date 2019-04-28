#!/usr/bin/env python3
#

# import from sys
from PIL import Image
from matplotlib import pyplot


def demo01():
    img = Image.open('home_page_photo_20181217154015.jpg')

    pyplot.imshow(img)
    pyplot.show()
    (ha, ca) = img.size
    size_threshold = 100

    if ha > size_threshold:
        ratio = ha / size_threshold
    else:
        ratio = 1

    print(ratio)

    new_ha = int(ha / ratio)
    new_ca = int(ca / ratio)

    new_img = img.resize((new_ha, new_ca))

    pyplot.imshow(new_img)
    pyplot.show()


def demo02():
    img = Image.open('avatar_03.jpg')
    img.save("avatar_03_new.jpg", format="JPEG", quality=5)


def demo03():
    img = Image.open('zuma.jpg')
    img.save("zuma_new.jpg", format="JPEG", quality=1)


if __name__ == '__main__':
    demo03()
