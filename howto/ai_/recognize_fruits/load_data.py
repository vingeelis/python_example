import os
from os.path import join as pathjoin
import skimage
import numpy as np
import matplotlib.pyplot as plt
from skimage import color, data, transform
from sklearn.utils import shuffle
import keras
from keras.utils import np_utils
from example.isinstance_ import iscastable


def format_path(img):
    yes_int = []
    for s in range(len(img)):
        img[s] = img[s].split('_')
        if iscastable.IsCastableNumber(img[s][0])():
            img[s][0] = int(img[s][0])
            yes_int.append(img[s])
    yes_int.sort()
    for yi in range(len(yes_int)):
        yes_int[yi][0] = str(yes_int[yi][0])
        yes_int[yi] = yes_int[yi][0] + '_' + yes_int[yi][1]
    no5_img = yes_int[4]
    return no5_img


def load_data(dir_path):
    images = []
    labels = []
    no5_imgs = []
    labels_no5 = []
    lab = os.listdir(dir_path)
    n = 0
    for l in lab:
        img = os.listdir(dir_path + l)
        for i in img:
            img_path = pathjoin(dir_path, l, i)
            labels.append(int(n))
            images.append(skimage.data.imread(img_path))
        n += 1
        no5_img = format_path(img)
        img5_path = pathjoin(dir_path, l, no5_img)
        labels_no5.append(l)
        no5_imgs.append(skimage.data.imread(img5_path))
    return images, labels, no5_imgs, labels_no5


if __name__ == '__main__':
    # os.chdir('C://var//images//Fruit-Images-Dataset-master')
    base_path = 'C://var//images//Fruit-Images-Dataset-master'
    pathTraining = pathjoin(base_path, 'Training')

    images, labels, no5_imgs, labels_no5 = load_data(pathTraining)
    print(len(images), len(labels), len(no5_imgs), )
