from basic_.sqlalchemy_.declare_mapping_ import User
from basic_.sqlalchemy_.building_a_relationship import Address
from basic_.sqlalchemy_.create_session import session
from sqlalchemy.sql import exists

stmt_exists = exists().where(Address.user_id == User.id)

# an explicit EXISTS construct, which looks like this:
stmt = session.query(User.name).filter(stmt_exists)
print(stmt)
for name, in stmt:
    print(name)

# the statement can be expressed along the User.addresses relationship using Comparator.any()
stmt = session.query(User.name).filter(User.addresses.any())
print(stmt)
for name, in stmt:
    print(name)

# Comparator.any() takes criterion as well, to limit the rows matched:
stmt = session.query(User.name).filter(User.addresses.any(Address.email_address.like('%google%')))
print(stmt)
for name, in stmt:
    print(name)

# Comparator.has() is the same operator as Comparator.any() for many-to-one relationships (note the ~ operator here too, which means “NOT”):
stmt = session.query(Address).filter(~Address.user.has(User.name == 'jack')).all()
print(stmt)
for a in stmt:
    print(a)
