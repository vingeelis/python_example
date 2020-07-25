from basic_.sqlalchemy_.building_a_relationship import Address
from basic_.sqlalchemy_.create_session import session
from basic_.sqlalchemy_.declare_mapping_ import User
from sqlalchemy.sql import func

'''
select users.*, adr_count.address_count from users left outer join
    (select user_id, count(*) as address_cuont
        from addresses group by user_id) as adr_count
    on users.id=adr_count.user_id;
'''

# construct a subquery
stmt = session.query(Address.user_id, func.count('*').label('address_count')).group_by(Address.user_id).subquery()
print(stmt)

# Once we have our statement, it behaves like a Table construct, such as the one we created for users at the start of this tutorial.
# The columns on the statement are accessible through an attribute called c:
for user,count in session.query(User, stmt.c.address_count).outerjoin(stmt, User.id==stmt.c.user_id).order_by(User.id):
    print(user, count)