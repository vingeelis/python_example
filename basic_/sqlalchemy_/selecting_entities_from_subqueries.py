from basic_.sqlalchemy_.declare_mapping_ import User
from basic_.sqlalchemy_.building_a_relationship import Address
from basic_.sqlalchemy_.create_session import session
from sqlalchemy.orm import aliased

sub_stmt = session.query(Address).filter(Address.email_address != 'j25@yahoo.com').subquery()

ad_alias = aliased(Address, sub_stmt)

stmt = session.query(User, ad_alias).join(ad_alias, User.addresses)
print(stmt)

for user, address in stmt:
    print(user)
    print(address)
