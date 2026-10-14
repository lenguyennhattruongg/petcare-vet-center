from flask import Blueprint, render_template

staff_bp = Blueprint("staff", __name__)


@staff_bp.route("/dashboard")
def dashboard():
    """Bàn tiếp tân & Điều phối tại quầy"""
    return "<h1>Phân hệ Tiếp tân & Điều phối Phòng khám PetCare (Staff Portal)</h1>"
