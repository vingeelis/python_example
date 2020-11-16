from django.shortcuts import render


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
