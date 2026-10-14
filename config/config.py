import os
from pathlib import Path
from dotenv import load_dotenv

# Xác định thư mục gốc của dự án
BASE_DIR = Path(__file__).resolve().parent.parent

# Tải biến môi trường từ file .env nếu có
load_dotenv(BASE_DIR / ".env")


class Config:
    """Cấu hình cơ sở dùng chung cho mọi môi trường"""
    SECRET_KEY = os.getenv("SECRET_KEY", "petcare_default_secret_key_2026_dev")
    BASE_DIR = BASE_DIR

    # SQLAlchemy Config
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    SQLALCHEMY_ENGINE_OPTIONS = {
        "pool_recycle": 280,
        "pool_pre_ping": True,
    }

    # Session & Security Cookies
    SESSION_COOKIE_HTTPONLY = True
    SESSION_COOKIE_SAMESITE = "Lax"
    PERMANENT_SESSION_LIFETIME = 1800  # 30 phút theo chuẩn BR-12

    # Uploads Config
    UPLOAD_FOLDER = BASE_DIR / "app" / "static" / "uploads"
    MAX_CONTENT_LENGTH = 2 * 1024 * 1024  # 2MB theo đặc tả
    ALLOWED_EXTENSIONS = {"jpg", "jpeg", "png", "webp"}

    # Mail Config (Flask-Mail)
    MAIL_SERVER = os.getenv("MAIL_SERVER", "smtp.gmail.com")
    MAIL_PORT = int(os.getenv("MAIL_PORT", 587))
    MAIL_USE_TLS = os.getenv("MAIL_USE_TLS", "True").lower() in ("true", "1")
    MAIL_USERNAME = os.getenv("MAIL_USERNAME", "")
    MAIL_PASSWORD = os.getenv("MAIL_PASSWORD", "")
    MAIL_DEFAULT_SENDER = os.getenv("MAIL_DEFAULT_SENDER", "PetCare Clinic <no-reply@petcare.test>")


class DevelopmentConfig(Config):
    """Cấu hình cho môi trường phát triển (Development)"""
    DEBUG = True
    # Mặc định kết nối MySQL XAMPP (hoặc fallback sang SQLite nếu chưa bật MySQL)
    DB_USER = os.getenv("DB_USER", "root")
    DB_PASS = os.getenv("DB_PASSWORD", "")
    DB_HOST = os.getenv("DB_HOST", "127.0.0.1")
    DB_PORT = os.getenv("DB_PORT", "3306")
    DB_NAME = os.getenv("DB_NAME", "vet_center")

    SQLALCHEMY_DATABASE_URI = os.getenv(
        "DATABASE_URL",
        f"mysql+pymysql://{DB_USER}:{DB_PASS}@{DB_HOST}:{DB_PORT}/{DB_NAME}?charset=utf8mb4"
    )


class TestingConfig(Config):
    """Cấu hình cho môi trường kiểm thử (Testing)"""
    TESTING = True
    SQLALCHEMY_DATABASE_URI = "sqlite:///:memory:"
    WTF_CSRF_ENABLED = False


class ProductionConfig(Config):
    """Cấu hình cho môi trường chạy thật (Production)"""
    DEBUG = False
    SESSION_COOKIE_SECURE = True
    SQLALCHEMY_DATABASE_URI = os.getenv("DATABASE_URL")


def get_config():
    """Hàm lấy cấu hình tương ứng với biến môi trường FLASK_ENV"""
    env = os.getenv("FLASK_ENV", "development").lower()
    if env == "production":
        return ProductionConfig
    if env == "testing":
        return TestingConfig
    return DevelopmentConfig
