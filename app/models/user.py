from datetime import datetime
from flask_login import UserMixin
from werkzeug.security import generate_password_hash, check_password_hash
from app import db, login_manager


class User(UserMixin, db.Model):
    """
    Bảng người dùng (users) trong hệ thống PetCare
    Quản lý 4 vai trò: customer, staff, doctor, admin
    """
    __tablename__ = "users"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    full_name = db.Column(db.String(100), nullable=False)
    email = db.Column(db.String(150), unique=True, nullable=True)  # Cho phép NULL với hồ sơ quầy
    password_hash = db.Column(db.String(255), nullable=True)  # NULL cho đến khi kích hoạt
    phone = db.Column(db.String(20), nullable=True)
    address = db.Column(db.String(255), nullable=True)
    role = db.Column(
        db.Enum("customer", "staff", "doctor", "admin", name="user_role_enum"),
        default="customer",
        nullable=False
    )
    status = db.Column(
        db.Enum("active", "locked", "pending_activation", name="user_status_enum"),
        default="active",
        nullable=False
    )
    failed_login_count = db.Column(db.Integer, default=0, nullable=False)
    locked_until = db.Column(db.DateTime, nullable=True)
    must_change_password = db.Column(db.Boolean, default=False, nullable=False)
    deleted_at = db.Column(db.DateTime, nullable=True)
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    def set_password(self, password: str):
        """Băm mật khẩu an toàn bằng thuật toán scrypt/pbkdf2"""
        self.password_hash = generate_password_hash(password, method="scrypt")

    def check_password(self, password: str) -> bool:
        """Kiểm tra mật khẩu nhập vào"""
        if not self.password_hash:
            return False
        return check_password_hash(self.password_hash, password)

    @property
    def is_active(self):
        """Chỉ cho phép tài khoản 'active' đăng nhập theo BR-12"""
        return self.status == "active" and self.deleted_at is None

    def has_role(self, *roles) -> bool:
        """Kiểm tra quyền người dùng"""
        return self.role in roles

    def __repr__(self):
        return f"<User id={self.id} email={self.email} role={self.role}>"


@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))
