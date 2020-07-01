from basic_.sqlalchemy_.connect_to_database import engine
from basic_.sqlalchemy_.creating_table import student
from sqlalchemy import select

conn = engine.connect()
s = student.select()

result = conn.execute(s)

# fetch one
# row = result.fetchone()
# print(row)

# fetch all
for row in result:
    print(row)

print('-' * 79)

# where, here c attribute is an alias for column
s = student.select().where(student.c.id > 2)
result = conn.execute(s)

for row in result:
    print(row)


print('-'*79)

# select() function
s = select([student])
result = conn.execute(s)
for row in result:
    print(row)