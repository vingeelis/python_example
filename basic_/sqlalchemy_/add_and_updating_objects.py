from basic_.sqlalchemy_.create_session import session
from basic_.sqlalchemy_.declare_mapping_ import User

ed_user = User(name='ed', fullname='Ed Jones', nickname='edsnickname')
session.add(ed_user)

# At this point, we say that the instance is pending; no SQL has yet been issued and the object is not yet represented by a row in the database.
# The Session will issue the SQL to persist Ed Jones as soon as is needed, using a process known as a flush.
# If we query the database for Ed Jones, all pending information will first be flushed, and the query is issued immediately thereafter.
our_user = session.query(User).filter_by(name='ed').first()
print(our_user)
print(our_user.id)
print(ed_user is our_user)

session.add_all([
    User(name='wendy', fullname='Wendy Williams', nickname='windy'),
    User(name='mary', fullname='Mary Contrary', nickname='mary'),
    User(name='fred', fullname='Fred Flintstone', nickname='freddy'),
])

ed_user.nickname = 'eddie'

print(session.dirty)
print(session.new)

session.commit()

print(ed_user.id)
