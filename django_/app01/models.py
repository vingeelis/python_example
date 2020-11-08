from django.db import models


# Create your models here.

class Business(models.Model):
    caption = models.CharField(max_length=32)
    code = models.CharField(max_length=32, null=True, default='SA')


class Host(models.Model):
    id = models.AutoField(primary_key=True)
    hostname = models.CharField(max_length=32, db_index=True)
    ip = models.GenericIPAddressField(protocol='ipv4', db_index=True)
    port = models.IntegerField()
    business = models.ForeignKey(to='Business', to_field='id', on_delete=models.CASCADE)


class Application(models.Model):
    name = models.CharField(max_length=32, null=True)
    host = models.ManyToManyField('Host')
    # r = models.ManyToManyField(to="Host")


class HostToApp(models.Model):
    hobj = models.ForeignKey(to="Host", to_field="id", on_delete=models.CASCADE)
    aobj = models.ForeignKey(to="Application", to_field="id", on_delete=models.CASCADE)


class Teacher(models.Model):
    name = models.CharField(max_length=128)
    age = models.SmallIntegerField()


class Student(models.Model):
    name = models.CharField(max_length=128)
    age = models.SmallIntegerField()


class NToNTeacherStudent(models.Model):
    teacher = models.ForeignKey(Teacher, to_field='id', on_delete=models.CASCADE)
    student = models.ForeignKey(Student, to_field='id', on_delete=models.CASCADE)
