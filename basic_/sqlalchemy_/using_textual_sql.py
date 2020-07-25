from sqlalchemy.orm import aliased
from sqlalchemy import text

from basic_.sqlalchemy_.create_session import session
from basic_.sqlalchemy_.declare_mapping_ import User


# text()
for user in session.query(User).filter(text('id<100')).order_by(text('id')).all():
    print(user.name)

# bind parameters using Query.params()
print(
    session.query(User).filter(text('id<:value and name=:name')).params(value=100, name='fred').order_by(User.id).one())

# Query.from_statement()
for user in session.query(User).from_statement(text('select * from users where name=:name')).params(name='ed').all():
    print(user)

stmt = text('select name, id, fullname, nickname from users where name=:name')
print(session.query(User).from_statement(stmt).params(name='ed').all())

stmt = stmt.columns(User.name, User.id)
print(session.query(User).from_statement(stmt).params(name='ed').all())

# When selecting from a text() construct, the Query may still specify what columns and entities are to be returned;
# instead of query(User) we can also ask for the columns individually, as in any other case:
stmt = text("SELECT name, id FROM users where name=:name")
stmt = stmt.columns(User.name, User.id)
print(session.query(User.id, User.name).from_statement(stmt).params(name='ed').all())
