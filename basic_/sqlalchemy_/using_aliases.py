from sqlalchemy.orm import aliased

from basic_.sqlalchemy_.building_a_relationship import Address
from basic_.sqlalchemy_.create_session import session
from basic_.sqlalchemy_.declare_mapping_ import User

ad1_alias = aliased(Address)
ad2_alias = aliased(Address)

#  we join to the Address entity twice, to locate a user who has two distinct email addresses at the same time:
stmt = session.query(User.name, ad1_alias.email_address, ad2_alias.email_address). \
    join(User.addresses.of_type(ad1_alias)). \
    join(User.addresses.of_type(ad2_alias)). \
    filter(ad1_alias.email_address == 'jack@google.com'). \
    filter(ad2_alias.email_address == 'j25@yahoo.com')

print(stmt)
for username, email1, email2 in stmt:
    print(username, email1, email2)
