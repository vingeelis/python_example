from basic_.sqlalchemy_.declare_mapping_ import User

ed_user = User(name='ed', fullname='Ed Jones', nickname='edsnickname')
print(ed_user.name)
print(ed_user.nickname)
print(str(ed_user.id))
