from sqlalchemy import MetaData, create_engine
from sqlalchemy import Table
from sqlalchemy import Column
from sqlalchemy import Integer
from sqlalchemy import String

engine = create_engine('postgresql+psycopg2://pgadmin:123456@192.168.1.241/cassini', echo=True)
meta = MetaData()

student = Table(
    'student', meta,
    Column('id', Integer, primary_key=True),
    Column('name', String),
    Column('lastname', String),
)

meta.create_all(engine)
