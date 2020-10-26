from django.core.files import File
from django.shortcuts import render, HttpResponse, redirect
from django.core.handlers.wsgi import WSGIRequest
from app01 import models

import json


# Create your views here.

def business(request):
    v1 = models.Business.objects.all()
    v2 = models.Business.objects.all().values('id', 'caption')
    v3 = models.Business.objects.all().values_list('id', 'caption')

    return render(request, 'business.html', {'v1': v1, 'v2': v2, 'v3': v3})


def host(request):
    if request.method == 'GET':
        v1 = models.Host.objects.filter(id__gt=0)
        v2 = models.Host.objects.filter(id__gt=0).values('id', 'hostname', 'business_id', 'business__caption')
        for v in v2:
            print(v['id'], v['hostname'], v['business_id'], v['business__caption'])
        v3 = models.Host.objects.values_list('id', 'hostname', 'business_id', 'business__caption')

        business_list = models.Business.objects.all()

        return render(request, 'host.html', {'v1': v1, 'v2': v2, 'v3': v3, 'business_list': business_list})

    elif request.method == 'POST':
        h = request.POST.get('hostname')
        i = request.POST.get('ip')
        p = request.POST.get('port')
        b = request.POST.get('business_id')
        models.Host.objects.create(hostname=h,
                                   ip=i,
                                   port=p,
                                   business_id=b)
        return redirect('/host')
