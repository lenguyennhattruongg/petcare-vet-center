from flask import Blueprint, render_template

doctor_bp = Blueprint("doctor", __name__)


@doctor_bp.route("/dashboard")
def dashboard():
    """Phân hệ Bác sĩ Thú y khám bệnh lâm sàng"""
    return "<h1>Phân hệ Bác sĩ Khám Lâm Sàng & Bệnh Án Điện Tử (Doctor Portal)</h1>"
