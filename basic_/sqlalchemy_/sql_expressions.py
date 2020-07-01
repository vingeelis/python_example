from basic_.sqlalchemy_.creating_table import student

ins = student.insert().values(name='Karan', lastname='Kapoor')
print(str(ins.compile().params))
