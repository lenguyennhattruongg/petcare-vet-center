from flask import Blueprint, render_template

admin_bp = Blueprint("admin", __name__)


@admin_bp.route("/dashboard")
def dashboard():
    """Phân hệ Ban Giám đốc & Quản trị Hệ thống PetCare"""
    return "<h1>Phân hệ Ban Giám Đốc & Quản Trị Hệ Thống (Admin Portal)</h1>"
