from flask import Blueprint, render_template, request, flash, redirect, url_for
from flask_login import login_required, current_user

client_bp = Blueprint("client", __name__)


@client_bp.route("/")
def home():
    """Trang chủ cổng thông tin Trung tâm Thú y PetCare"""
    featured_services = [
        {
            "id": 1,
            "name": "Khám Sức Khỏe Tổng Quát",
            "description": "Kiểm tra toàn diện tim mạch, hô hấp, mắt, răng miệng và thể trạng của bé cưng.",
            "price": "150.000₫",
            "duration": "30 phút",
            "icon": "bi-heart-pulse",
        },
        {
            "id": 2,
            "name": "Tiêm Phòng Vắc-xin Đa Giá",
            "description": "Tiêm phòng 7 bệnh cho chó, 4 bệnh cho mèo và vắc-xin dại nhập khẩu chính hãng.",
            "price": "250.000₫",
            "duration": "30 phút",
            "icon": "bi-shield-check",
        },
        {
            "id": 3,
            "name": "Spa & Grooming Chuyên Nghiệp",
            "description": "Tắm sấy dưỡng lông, cắt tỉa thẩm mỹ, vệ sinh tai móng với tinh dầu thư giãn.",
            "price": "300.000₫",
            "duration": "60 phút",
            "icon": "bi-scissors",
        },
        {
            "id": 4,
            "name": "Phẫu Thuật & Triệt Sản An Toàn",
            "description": "Phòng mổ vô trùng áp lực dương, gây mê khí dung hiện đại, chăm sóc hậu phẫu chu đáo.",
            "price": "800.000₫",
            "duration": "60 phút",
            "icon": "bi-bandaid",
        },
    ]
    return render_template("client/home.html", services=featured_services)


@client_bp.route("/services")
def services():
    """Trang danh mục dịch vụ phòng khám"""
    return render_template("client/home.html")


@client_bp.route("/login")
def login():
    """Trang đăng nhập (Mốc 2)"""
    flash("Chức năng đăng nhập đang được cập nhật ở Mốc 2.", "info")
    return redirect(url_for("client.home"))


@client_bp.route("/register")
def register():
    """Trang đăng ký (Mốc 2)"""
    flash("Chức năng đăng ký đang được cập nhật ở Mốc 2.", "info")
    return redirect(url_for("client.home"))
