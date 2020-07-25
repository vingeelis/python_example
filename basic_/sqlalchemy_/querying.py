from sqlalchemy.orm import aliased

from basic_.sqlalchemy_.create_session import session
from basic_.sqlalchemy_.declare_mapping_ import User

for instance in session.query(User).order_by(User.id):
    print(instance.name, instance.fullname)

for name, fullname in session.query(User.name, User.fullname):
    print(name, fullname)

# The tuples returned by Query are named tuples, supplied by the KeyedTuple class, and can be treated much like an ordinary Python object.
# The names are the same as the attribute’s name for an attribute, and the class name for a class:
for row in session.query(User.id, User).all():
    print(row.User.id, row.User)

# You can control the names of individual column expressions using the ColumnElement.label() construct,
# which is available from any ColumnElement-derived object, as well as any class attribute which is mapped to one (such as User.name):
for row in session.query(User.name.label('name_label')).all():
    print(row.name_label)

# The name given to a full entity such as User, assuming that multiple entities are present in the call to Session.query(), can be controlled using aliased() :
user_alias = aliased(User, name='user_alias')
for row in session.query(user_alias, user_alias.name).all():
    print(row.user_alias)

# Basic operations with Query include issuing LIMIT and OFFSET, most conveniently using Python array slices and typically in conjunction with ORDER BY:
for u in session.query(User).order_by(User.id)[1:3]:
    print(u)

# and filtering results, which is accomplished either with filter_by(), which uses keyword arguments:
for name, in session.query(User.name).filter_by(fullname='Ed Jones'):
    print(name)

# …or filter(), which uses more flexible SQL expression language constructs.
# These allow you to use regular Python operators with the class-level attributes on your mapped class:
for name, in session.query(User.name).filter(User.fullname == 'Ed Jones'):
    print(name)

# The Query object is fully generative, meaning that most method calls return a new Query object upon which further criteria may be added.
# For example, to query for users named “ed” with a full name of “Ed Jones”, you can call filter() twice, which joins criteria using AND:
for user in session.query(User).filter(User.name == 'ed').filter(User.fullname == 'Ed Jones'):
    print(user)
