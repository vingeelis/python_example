from sqlalchemy.orm import sessionmaker

from basic_.sqlalchemy_.create_engine_ import engine

Session = sessionmaker(bind=engine)

session = Session()

# # or
# Session = sessionmaker()
# Session.configure(bind=engine)
