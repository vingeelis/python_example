from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship

from basic_.sqlalchemy_.create_engine_ import engine
from basic_.sqlalchemy_.declare_mapping_ import Base, User


class Address(Base):
    __tablename__ = 'addresses'
    id = Column(Integer, primary_key=True)
    email_address = Column(String, nullable=False)
    user_id = Column(Integer, ForeignKey('users.id'))
    user = relationship("User", back_populates="addresses")

    def __repr__(self):
        return f"<Address(email_address='{self.email_address}')>"


User.addresses = relationship("Address", order_by=Address.id, back_populates="user")

Base.metadata.create_all(engine)