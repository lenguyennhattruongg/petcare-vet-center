import logging
from logging.handlers import RotatingFileHandler
from pathlib import Path
from flask import Flask, render_template
from flask_sqlalchemy import SQLAlchemy
from flask_login import LoginManager
from flask_wtf.csrf import CSRFProtect
from flask_mail import Mail

from config import get_config

# Khởi tạo các extension của Flask ở tầng module
db = SQLAlchemy()
login_manager = LoginManager()
csrf = CSRFProtect()
mail = Mail()


def create_app(config_class=None):
    """
    Application Factory Pattern: Khởi tạo và lắp ráp ứng dụng Flask chuẩn doanh nghiệp
    """
    app = Flask(__name__, instance_relative_config=True)

    # 1. Nạp cấu hình
    if config_class is None:
        config_class = get_config()
    app.config.from_object(config_class)

    # Đảm bảo thư mục lưu trữ tồn tại
    app.config["UPLOAD_FOLDER"].mkdir(parents=True, exist_ok=True)
    log_dir = app.config["BASE_DIR"] / "storage" / "logs"
    log_dir.mkdir(parents=True, exist_ok=True)

    # 2. Khởi tạo Extensions với app
    db.init_app(app)
    csrf.init_app(app)
    login_manager.init_app(app)
    mail.init_app(app)

    # Cấu hình Flask-Login
    login_manager.login_view = "client.login"
    login_manager.login_message = "Vui lòng đăng nhập để truy cập trang này."
    login_manager.login_message_category = "warning"

    # 3. Cấu hình Hệ thống Ghi nhật ký (Rotating Logging)
    if not app.debug and not app.testing:
        file_handler = RotatingFileHandler(
            log_dir / "app.log", maxBytes=10 * 1024 * 1024, backupCount=5, encoding="utf-8"
        )
        file_handler.setFormatter(
            logging.Formatter(
                "%(asctime)s [%(levelname)s] in %(pathname)s:%(lineno)d: %(message)s"
            )
        )
        file_handler.setLevel(logging.INFO)
        app.logger.addHandler(file_handler)
        app.logger.setLevel(logging.INFO)
        app.logger.info("PetCare Application Startup")

    # 4. Đăng ký các Blueprints (Các phân hệ)
    from app.routes.client import client_bp
    from app.routes.staff import staff_bp
    from app.routes.doctor import doctor_bp
    from app.routes.admin import admin_bp
    from app.routes.api import api_v1_bp

    app.register_blueprint(client_bp)
    app.register_blueprint(staff_bp, url_prefix="/staff")
    app.register_blueprint(doctor_bp, url_prefix="/doctor")
    app.register_blueprint(admin_bp, url_prefix="/admin")
    app.register_blueprint(api_v1_bp, url_prefix="/api/v1")

    # 5. Đăng ký Trang báo lỗi thân thiện (Error Handlers)
    register_error_handlers(app)

    # 6. Context Processors (Dữ liệu toàn cục cho Jinja2 Templates)
    @app.context_processor
    def inject_global_settings():
        return {
            "CLINIC_NAME": "Trung tâm Thú y PetCare",
            "CLINIC_PHONE": "028.1234.5678",
            "CLINIC_EMAIL": "contact@petcare.test",
            "CLINIC_ADDRESS": "Số 2 Võ Oanh, Phường 25, Q. Bình Thạnh, TP. Hồ Chí Minh",
        }

    return app


def register_error_handlers(app):
    """Đăng ký các hàm bắt lỗi HTTP trả về giao diện đẹp mắt"""
    @app.errorhandler(400)
    def bad_request(error):
        return render_template("errors/400.html", error=error), 400

    @app.errorhandler(403)
    def forbidden(error):
        return render_template("errors/403.html", error=error), 403

    @app.errorhandler(404)
    def not_found(error):
        return render_template("errors/404.html", error=error), 404

    @app.errorhandler(500)
    def internal_server_error(error):
        db.session.rollback()
        return render_template("errors/500.html", error=error), 500
