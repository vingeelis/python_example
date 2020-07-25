from basic_.sqlalchemy_.building_a_relationship import Address
from basic_.sqlalchemy_.create_session import session
from basic_.sqlalchemy_.declare_mapping_ import User

jack = session.query(User).get(10)
del jack.addresses[1]

print(session.query(User).filter_by(name='jack').count())

# Uh oh, they’re still there ! Analyzing the flush SQL, we can see that the user_id column of each address was set to NULL,
# but the rows weren’t deleted. SQLAlchemy doesn’t assume that deletes cascade, you have to tell it to do so.
print(session.query(Address).filter(Address.email_address.in_(['jack@google.com', 'j25@yahoo.com'])).count())

