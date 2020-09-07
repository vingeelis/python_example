from django.core.files import File
from django.shortcuts import render, HttpResponse, redirect
from django.core.handlers.wsgi import WSGIRequest

# Create your views here.
from django.views import View

# USER_DICT = {
#     '1': 'root1',
#     '2': 'root2',
#     '3': 'root3',
#     '4': 'root4',
# }

USER_DICT = {
    '1': {'name': 'root1', 'email': 'root@live.com'},
    '2': {'name': 'root2', 'email': 'root@live.com'},
    '3': {'name': 'root3', 'email': 'root@live.com'},
    '4': {'name': 'root4', 'email': 'root@live.com'},
    '5': {'name': 'root5', 'email': 'root@live.com'},
}


def index(request):
    return render(request, 'index.html', {'user_dict': USER_DICT}, )


# def detail(request):
#     nid = request.GET.get('nid')
#     return render(request, 'detail.html', {'detail_info': USER_DICT[nid]})

def detail(request, nid):
    return HttpResponse(nid)


def login(request: WSGIRequest):
    if request.method == 'GET':
        return render(request, 'login.html')
    elif request.method == 'POST':
        file: File = request.FILES.get('file01')
        fd = open(file.name, mode='wb+')
        for c in file.chunks():
            fd.write(c)
        fd.close()
        return render(request, 'login.html')
    else:
        return redirect('/index/')


def home(request):
    return HttpResponse('Home')


class Home(View):

    def get(self, request):
        print(request.method)
        return render(request, 'home.html')

    def post(self, request):
        print(request.method, 'POST')
        return render(request, 'home.html')
