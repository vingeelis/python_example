from basic_.sqlalchemy_.create_engine_ import engine

from basic_.sqlalchemy_.declare_mapping_ import Base

Base.metadata.create_all(engine)
