import sqlalchemy
from sqlalchemy import create_engine
from sqlalchemy.orm import scoped_session
from sqlalchemy.orm import sessionmaker

engine = create_engine('postgresql+psycopg2://pgadmin:123456@192.168.1.241/cassini', echo=False)

# db = scoped_session(sessionmaker(bind=engine))
# print(sqlalchemy.__version__)
# print(db.execute("select version()").fetchall())
