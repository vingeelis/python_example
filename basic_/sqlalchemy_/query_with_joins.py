from basic_.sqlalchemy_.building_a_relationship import Address
from basic_.sqlalchemy_.create_session import session
from basic_.sqlalchemy_.declare_mapping_ import User

# a simple implicit join between User and Address
for u,a in session.query(User, Address).filter(User.id == Address.user_id).filter(Address.email_address=='jack@google.com').all():
    print(u)
    print(a)

# actual SQL JOIN syntax
print(session.query(User).join(Address).filter(Address.email_address=='jack@google.com').all())

# If there were no foreign keys, or several, Query.join() works better when one of the following forms are used
print(session.query(User).join(Address, User.id==Address.user_id))
print(session.query(User).join(User.addresses))
print(session.query(User).join(Address, User.addresses))

# outer join
print(session.query(User).outerjoin(User.addresses))

# multiple entities
print(session.query(User,Address).select_from(Address).join(User))
