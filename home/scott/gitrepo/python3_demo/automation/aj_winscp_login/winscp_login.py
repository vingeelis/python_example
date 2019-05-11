# -*- coding: gbk -*-

import pyautogui
import selenium
import win32api
import win32con
import win32gui
import os
from selenium import webdriver
from win32com.client import Dispatch, DispatchEx
from time import sleep

pos_ec = (1050, 942)
pos_url_pldsec = (337, 256)
pos_32_1 = (338, 311)
pos_winscp = (1124, 436)
pos_username = (656, 480)
pos_passwd = (656, 508)
pos_confirm = (608, 548)
pos_winscp_left_1 = (61, 117)
pos_winscp_left_2 = (52, 213)
pos_winscp_right = (720, 228)
username_32_1 = 'sixieops'
password_32_1 = 'Sixie971'


def smart_click(pos, stime=0, message=None):
    pyautogui.moveTo(pos)
    pyautogui.click()
    if message:
        pyautogui.typewrite(message)
    sleep(stime)


def kill_winproc(procname):
    if os.system('tasklist | findstr {}'.format(procname)):
        return None
    os.system('taskkill /F /IM {}'.format(procname))


def open_ec():
    pyautogui.moveTo(pos_ec)
    pyautogui.doubleClick()
    sleep(5)


def get_ie():
    shell = Dispatch("Shell.Application")
    for win in shell.Windows():
        if win.Name == 'Internet Explorer':
            return win
    return None


def print_ie(ie):
    print(ie.LocationURL)
    print(ie)
    print(type(ie))
    # doc = ie.Document.body
    # [print(d) for d in doc.getElementsByTagName('a')]


def open_pldsec():
    # pyautogui.moveTo(pos_url_pldsec)
    # pyautogui.click()
    # sleep(1)
    smart_click(pos_url_pldsec, 1)


def open_31_1():
    smart_click(pos_32_1, 1)
    smart_click(pos_winscp, 2)
    smart_click(pos_username, 1, message=username_32_1)
    smart_click(pos_passwd, 1, message=password_32_1)
    smart_click(pos_confirm, 20)
    smart_click(pos_winscp_left_1, 1)
    smart_click(pos_winscp_left_2, 2)
    smart_click(pos_winscp_right)


def main():
    kill_winproc('iexplore.exe')
    kill_winproc('WinSCP.exe')
    open_ec()
    open_pldsec()
    open_31_1()


if __name__ == "__main__":
    main()
