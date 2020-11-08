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


def test_ajax(request):
    ret = {'status': True, 'error': None, 'data': None}

    print(request.POST)
    h = request.POST.get('hostname')
    i = request.POST.get('ip')
    p = request.POST.get('port')
    b = request.POST.get('business_id')
    print(h)
    print(i)
    print(p)
    print(b)
    try:
        if h and len(h) > 5:
            models.Host.objects.create(
                hostname=h,
                ip=i,
                port=p,
                business_id=b,
            )
            ret['status'] = False
            ret['error'] = "too short"
        else:
            return HttpResponse('too short')
    except Exception as e:
        ret['status'] = False
        ret['error'] = 'too short'

    return HttpResponse(json.dumps(ret))


def app(request):
    if request.method == "GET":
        app_list = models.Application.objects.all()
        host_list = models.Host.objects.all()

        return render(request, 'app.html', {'app_list': app_list, 'host_list': host_list})
    elif request.method == "POST":
        app_name = request.POST.get('app_name')
        host_list = request.POST.getlist('host_list')
        a = models.Application.objects.create(name=app_name)
        a.host.add(*host_list)

        return redirect('/app')


def ajax_add_app(request):
    ret = {'status': True, 'error': None, 'data': None}
    app_name = request.POST.get('app_name')
    host_list = request.POST.getlist('host_list')
    print(app_name)
    print(host_list)
    a = models.Application.objects.create(name=app_name)
    a.host.add(*host_list)
    return HttpResponse(json.dumps(ret))


def teacher(request):
    if request.method == 'GET':
        teacher_list = models.Teacher.objects.all()
        student_list = models.Student.objects.all()
        return render(request, 'teacher.html', {'teacher_list': teacher_list, 'student_list': student_list, })
    elif request.method == 'POST':
        teacher_name = request.POST.get('teacher_name')
        student_list = request.POST.getlist('student_list')
        obj = models.Teacher.objects.create(name=teacher_name)
        obj.student.add(*student_list)
        return redirect('/teacher')


def student(request):
    if request.method == 'GET':
        student_list = models.Student.objects.all()
        teacher_list = models.Teacher.objects.all()
        return render(request, 'student.html', {'student_list': student_list, 'teacher_list': teacher_list, })
    elif request.method == 'POST':
        students_name = request.POST.getlist('students_name')
        teacher_list = request.POST.get('teacher_list')
        obj = models.Student.objects.create(name=students_name)
        obj.teacher.add(*teacher_list)
        return redirect('/student', )


def teacher_add_by_ajax(request):
    ret = {'status': True, 'error': None, 'data': None}
    teacher_name = request.POST.get('teacher_name')
    student_list = request.POST.getlist('student_list')
    obj = models.Teacher.objects.create(name=teacher_name)
    obj.student.add(*student_list)
    return HttpResponse(json.dumps(ret))
