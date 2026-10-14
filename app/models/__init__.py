"""
Package chứa các SQLAlchemy Models của Hệ thống PetCare
"""
from app import db
from .user import User

__all__ = ["db", "User"]
