from sqlalchemy import create_engine, Column, Integer, String, ForeignKey
from sqlalchemy.orm import sessionmaker, relationship


# The echo flag is a shortcut to setting up SQLAlchemy logging, which is accomplished via Python’s standard logging module.
# With it enabled, we’ll see all the generated SQL produced.
# If you are working through this tutorial and want less output generated, set it to False.
# The return value of create_engine() is an instance of Engine, and it represents the core interface to the database,
# adapted through a dialect that handles the details of the database and DBAPI in use.
# In this case the SQLite dialect will interpret instructions to the Python built-in sqlite3 module.


class Database(object):
    from sqlalchemy.ext.declarative import declarative_base
    Base = declarative_base()

    @staticmethod
    def get_engine(echo=False):
        return create_engine('postgresql+psycopg2://pgadmin:123456@192.168.1.241/cassini', echo=echo)

    @staticmethod
    def get_session(echo=False):
        return sessionmaker(
            bind=Database.get_engine(echo=echo)
        )()

    @staticmethod
    def create_tables():
        Database.Base.metadata.create_all(Database.get_engine(echo=False))


# declare a mapping


class User(Database.Base):
    __tablename__ = 'users'
    id = Column(Integer, primary_key=True)
    name = Column(String(50))
    fullname = Column(String(50))
    nickname = Column(String(50))
    # In both relationship() directives, the parameter relationship.back_populates is assigned to refer to the complementary attribute names;
    # by doing so, each relationship() can make intelligent decision about the same relationship as expressed in reverse;
    # on one side, Address.user refers to a User instance, and on the other side, User.addresses refers to a list of Address instances.
    # addresses = relationship('Address', back_populates='user')
    addresses = relationship('Address', back_populates='user', cascade="all, delete, delete-orphan")

    def __repr__(self):
        return f"<User(id={self.id}, name={self.name}, fullname={self.fullname}, nickname={self.nickname})>"


class Address(Database.Base):
    __tablename__ = 'addresses'
    id = Column(Integer, primary_key=True)
    email_address = Column(String, nullable=False)
    user_id = Column(Integer, ForeignKey('users.id'))
    # relationship(), tells the ORM that the Address class itself should be linked to the User class, using the attribute Address.user.
    # relationship() uses the foreign key relationships between the two tables to determine the nature of this linkage, determining that Address.user will be many to one.
    user = relationship('User', back_populates='addresses')

    def __repr__(self):
        return f"<Address(id={self.id}, email_address={self.email_address})>"


def horizontal_rule():
    print('-' * 79)
