from sqlalchemy.orm import aliased

from basic_.sqlalchemy_.building_a_relationship import Address
from basic_.sqlalchemy_.create_session import session
from basic_.sqlalchemy_.declare_mapping_ import User

jack = User(name='jack', fullname='Jack Bean', nickname='gjffdd')
print(jack.addresses)

jack.addresses = [Address(email_address='jack@google.com'), Address(email_address='j25@yahoo.com')]
print(jack.addresses[0])
print(jack.addresses[1].user)

session.add(jack)
session.commit()

jack = session.query(User).filter_by(name='jack').one()
print(jack)
print(jack.addresses)
