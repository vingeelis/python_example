from sqlalchemy.orm import selectinload, joinedload, contains_eager

from basic_.sqlalchemy_.building_a_relationship import Address
from basic_.sqlalchemy_.create_session import session
from basic_.sqlalchemy_.declare_mapping_ import User


# selectiin load
jack = session.query(User).options(selectinload(User.addresses)).filter_by(name='jack').one()
print(jack)


# joined load
jack = session.query(User).options(joinedload(User.addresses)).filter_by(name='jack').one()
print(jack)

# explicit join eagerload
jacks_addresses = session.query(Address).join(Address.user).filter(User.name=='jack').options(contains_eager(Address.user)).all()
print(jacks_addresses)
print(jacks_addresses[0].user)

