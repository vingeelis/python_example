from basic_.sqlalchemy_.declare_mapping_ import User
from basic_.sqlalchemy_.building_a_relationship import Address
from basic_.sqlalchemy_.create_session import session
from sqlalchemy.sql import exists

# the following examples are not working

someuser = User(name='jack')

# Comparator.__eq__() (many-to-one "equals" comparison):
stmt = session.query(Address).filter(Address.user == someuser)
print(stmt)

# Comparator.__ne__() (many-to-one “not equals” comparison):
stmt = session.query(Address).filter(Address.user != someuser)
print(stmt)

# IS NULL (many-to-one comparison, also uses Comparator.__eq__()):
stmt = session.query(Address).filter(Address.user == None)
print(stmt)

someaddress = Address(email_address='jack@google.com')
# Comparator.contains() (used for one-to-many collections):
stmt = session.query(Address).filter(User.addresses.contains(someaddress))
print(stmt)

# Comparator.any() (used for collections):
stmt = session.query(User).filter(User.addresses.any(Address.email_address == 'bar'))
print(stmt)
stmt = session.query(User).filter(User.addresses.any(email_address = 'bar'))
print(stmt)

# Comparator.has() (used for scalar references):
# stmt = session.query(Address).filter(Address.user.has(name='ed'))
# print(stmt)

# Query.with_parent() (used for any relationship):
stmt = session.query(Address).with_parent(someuser, 'addresses')
print(stmt)


