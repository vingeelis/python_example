from sqlalchemy.orm import aliased

from basic_.sqlalchemy_.create_session import session
from basic_.sqlalchemy_.declare_mapping_ import User

for un in session.query(User.name).filter(User.name == 'ed'):
    print(un)

for un in session.query(User.name).filter(User.name != 'ed'):
    print(un)

for un in session.query(User.name).filter(User.name.like('%ed%')):
    print(un)

for un in session.query(User.name).filter(User.name.ilike('%ed%')):
    print(un)

for un in session.query(User.name).filter(User.name.in_('ed wendy jack'.split())):
    print(un)

from sqlalchemy import tuple_

'''this sql statement equals to\
 SELECT users.name AS users_name, users.nickname AS users_nickname
 FROM users
 WHERE (users.name='ed' and users.nickname='edsnickname') or (users.name='wendy' and users.nickname='wendy');
'''
for un, unn in session.query(User.name, User.nickname).filter(
        tuple_(User.name, User.nickname).in_([('ed', 'edsnickname'), ('wendy', 'windy')])
):
    print(f'["{un}", "{unn}"]')

# '~...in_' equals to 'notin_'
for un in session.query(User.name).filter(~User.name.in_('ed wendy jack'.split())):
    print(f"~in_: {un}")

for un in session.query(User.name).filter(User.name.notin_('ed wendy jack'.split())):
    print(f"notin_: {un}")

for un in session.query(User.name).filter(User.name.is_(None)):
    print(f"is_(Nono): {un}")

for un in session.query(User.name).filter(User.name.isnot(None)):
    print(f"isnot(None): {un}")

from sqlalchemy import and_

for un, ufn in session.query(User.name, User.fullname).filter(and_(User.name == 'ed', User.fullname == 'Ed Jones')):
    print(f"and_: {un},{ufn}")

for un, ufn in session.query(User.name, User.fullname).filter(User.name == 'ed', User.fullname == 'Ed Jones'):
    print(f"and using ,: {un},{ufn}")

for un, ufn in session.query(User.name, User.fullname).filter(User.name == 'ed').filter(User.fullname == 'Ed Jones'):
    print(f"and using filter chain: {un},{ufn}")

from sqlalchemy import or_

for un in session.query(User.name).filter(or_(User.name == 'ed', User.name == 'wendy')):
    print(f"or {un}")

for un in session.query(User.name).filter(User.name.match('wendy')):
    print(un)
