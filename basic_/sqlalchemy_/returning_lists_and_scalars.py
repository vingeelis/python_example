from sqlalchemy.orm import aliased
from sqlalchemy.orm.exc import MultipleResultsFound, NoResultFound
from basic_.sqlalchemy_.create_a_session import Session
from basic_.sqlalchemy_.declare_mapping_ import User

session = Session()

query = session.query(User).filter(User.name.like('%ed')).order_by(User.id)
print(query.all())

print(session.query(User).first())

# raise error of with multiple rows found by one()
try:
    query = session.query(User).one()
except MultipleResultsFound as e:
    print(f"error: {e}")
else:
    print(query)

# raise error of with no rows found by one()
try:
    query = session.query(User).filter(User.id == 99).one()
except NoResultFound as e:
    print(f"error: {e}")
else:
    print(query)

# if no results are found, it doesn't raise an error, it just returns None
print(session.query(User).filter(User.id == 99).one_or_none())

# Query.scalar() invokes the Query.one() method, and upon success returns the first column of the row:
query = session.query(User.id).filter(User.name == 'ed').order_by(User.id)
print(query.scalar())

