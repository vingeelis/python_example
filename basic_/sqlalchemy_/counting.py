from sqlalchemy.orm import aliased

from basic_.sqlalchemy_.create_a_session import Session
from basic_.sqlalchemy_.declare_mapping_ import User
from sqlalchemy import func

session = Session()

print(session.query(User).filter(User.name.like('%ed')).count())
print(session.query(func.count(User.name), User.name).group_by(User.name).all())

# achieve simple select count(*) from table
print(session.query(func.count('*')).select_from(User).scalar())

# The usage of Query.select_from() can be removed if we express the count in terms of the User primary key directly:
print(session.query(func.count(User.id)).scalar())

