from django.shortcuts import render

# Create your views here.
from django.shortcuts import HttpResponse
from django.shortcuts import render
from django.shortcuts import redirect


def login(request):
    error_msg = ""
    if request.method == "POST":
        user = request.POST.get('user', None)
        password = request.POST.get('password', None)
        if user == 'root' and password == '123':
            return redirect('http://www.163.com')
        else:
            error_msg = "username or password mismatch"

    return render(request, 'login.html', {'error_msg': error_msg})
