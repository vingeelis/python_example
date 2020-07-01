from basic_.sqlalchemy_.connect_to_database import engine
from basic_.sqlalchemy_.creating_table import student

conn = engine.connect()

# insert one
ins = student.insert().values(name='Ravi', lastname='Kappor')
result = conn.execute(ins)

print(result.inserted_primary_key)

# insert many
conn.execute(student.insert(), [
    {'name': 'Rajiv', 'lastname': 'Khanna'},
    {'name': 'Komal', 'lastname': 'Bhandari'},
    {'name': 'Abdul', 'lastname': 'Sattar'},
    {'name': 'Priya', 'lastname': 'Rajhans'},
])
