from django.shortcuts import render
import json
from users.models import User
from forum.models import Blog


# Create your views here.

def index(request):
    a = Blog.objects.all().order_by('-id')[5:]
    return render(request, 'main_base.html', {'blogs': a})


def accounts_profile(request):
    if request.method == 'POST':
        a = json.loads(request.body)
        print(a)
        b = User.objects.get(email=request.user.email)
        b.name = a['name']
        b.save()
    return render(request, 'accounts_profile.html')
