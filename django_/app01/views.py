from django.shortcuts import render

from utils.pagination import Page

PAGE_SIZE = 10
LIST = list()
for i in range(40):
    LIST.append(i)


# Create your views here.

def master(request):
    return render(request, 'master.html')


def tpl1(request):
    user_list = [1, 2, 3, 4]

    return render(request, 'tpl1.html', {'u': user_list})


def tpl2(request):
    name = 'root'
    return render(request, 'tpl2.html', {'name': name})


def tpl3(request):
    status = 'deleted'
    return render(request, 'tpl3.html', {'status': status})


def tpl4(request):
    name = 'alice'
    return render(request, 'tpl4.html', {'name': name})


def user_list(request):
    current_page = request.GET.get('p', 1)

    current_page = int(current_page)

    page_obj = Page(current_page, len(LIST))

    data = LIST[page_obj.start:page_obj.end]

    page_str = page_obj.page_str('/user_list/')

    return render(request, 'user_list.html', {'li': data, 'page_str': page_str})
