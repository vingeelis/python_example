from basic_.sqlalchemy_.create_session import session
from basic_.sqlalchemy_.declare_mapping_ import User

ed_user = session.query(User).filter_by(name='ed').first()
print(ed_user)

ed_user.name = 'Edwardo'
fake_user = User(name='fakeuser', fullname='Invalid', nickname='12345')
session.add(fake_user)

for user in session.query(User).filter(User.name.in_(['Edwardo', 'fakeuser'])).all():
    print(user)

session.rollback()

print(ed_user.name)

# issuing a SELECT illustrates the changes made to the database:
for user in session.query(User).filter(User.name.in_(['ed', 'fakeuser'])).all():
    print(user)
