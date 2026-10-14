# 🐾 PetCare Clinic & Hospital Management System
> **Hệ thống Quản trị & Website Bệnh viện Thú y PetCare (Production-Grade)**  
> Đồ án môn học: **Lập trình Web (Mã HP: 012012103105)** – Nhóm 2 – GVHD: **Trần Thịnh Mạnh Đức**  
> Trường Đại học Giao thông Vận tải TP. Hồ Chí Minh (UTH) – Viện Công nghệ Thông tin & Điện, Điện tử

---

## 🌟 Tổng quan Dự án
PetCare là giải pháp phần mềm chuyển đổi số toàn diện cho phòng khám và bệnh viện thú y, giải quyết trọn vẹn nghiệp vụ cho 4 phân hệ:
1. **Khách hàng (Client Portal):** Đặt lịch khám trực tuyến với live-slot, quản lý hồ sơ thú cưng, tra cứu bệnh án điện tử (Veterinary EHR), mua sắm và thanh toán VietQR động.
2. **Tiếp tân tại quầy (Staff / Front-desk):** Tiếp nhận bệnh nhân, check-in nhanh, phân bổ bác sĩ trực, POS xuất hóa đơn và thu ngân.
3. **Bác sĩ Thú y (Clinical Doctor Portal):** Quản lý ca trực, khám bệnh lâm sàng, ghi chẩn đoán, kê đơn thuốc điện tử liều lượng chuẩn (`mg/kg`), hẹn tái khám & tiêm phòng.
4. **Quản trị & Giám đốc (Admin & BI):** Phân chia ca trực bác sĩ (`work_schedules`), quản lý kho dược phẩm, báo cáo phân tích doanh thu bằng Chart.js, kiểm soát nhật ký kiểm toán (Audit Trail).

---

## 🛠️ Công nghệ Sử dụng
- **Backend:** Python 3.10+ với **Flask** (Kiến trúc phân tầng N-Tier Clean Architecture, Blueprints)
- **Database:** **MySQL 8.0** (InnoDB, SQLAlchemy ORM, kiểm soát khóa dòng Concurrency `with_for_update()`)
- **API:** RESTful API v1 tại `/api/v1/...`
- **Frontend:** HTML5, CSS3 (Design System Tokens), JavaScript ES6, Bootstrap 5, Bootstrap Icons, Chart.js
- **Bảo mật:** `Flask-Login` (Session HttpOnly), `Flask-WTF` (CSRF Protection), `Werkzeug` (scrypt password hashing)
- **DevOps:** Docker, Docker Compose, Git/GitHub, Cloud Deployment Ready

---

## 🚀 Hướng dẫn Cài đặt & Chạy trên máy tính (Local Development)

### 1. Yêu cầu môi trường
- Python 3.10 trở lên
- MySQL 8.0 (qua XAMPP hoặc MySQL Server độc lập)
- Git

### 2. Các bước cài đặt nhanh
```bash
# 1. Clone repository về máy
git clone https://github.com/lenguyennhattruongg/petcare-vet-center.git
cd petcare-vet-center

# 2. Tạo môi trường ảo Python
python -m venv venv

# 3. Kích hoạt môi trường ảo
# Trên Windows:
.\venv\Scripts\activate
# Trên macOS / Linux:
source venv/bin/activate

# 4. Cài đặt các thư viện phụ thuộc
pip install -r requirements.txt

# 5. Cấu hình biến môi trường
cp .env.example .env
# (Chỉnh sửa file .env nếu mật khẩu MySQL của bạn khác mặc định)

# 6. Khởi tạo Cơ sở Dữ liệu MySQL
# Mở phpMyAdmin hoặc MySQL Workbench, tạo database 'vet_center'
# Import lần lượt: database/schema.sql và database/seed.sql

# 7. Khởi động ứng dụng
python app.py
```

Ứng dụng sẽ hoạt động tại: **`http://localhost:5000`**

---

## 🐳 Hoặc Chạy Bằng Docker (1 Lệnh duy nhất)
```bash
docker compose up -d
```
Ứng dụng và CSDL MySQL sẽ tự động khởi tạo và chạy tại: **`http://localhost:5000`**

---

## 🔑 Tài khoản Mẫu để Kiểm thử (Testing Credentials)
Mật khẩu chung cho tất cả các tài khoản demo: **`Password123@`**

| Vai trò (Role) | Email đăng nhập | Mô tả chức vụ |
|---|---|---|
| **Admin** | `admin@petcare.test` | Ban Giám Đốc / Quản trị toàn hệ thống |
| **Staff** | `staff1@petcare.test` | Tiếp tân / Thu ngân phòng khám |
| **Doctor** | `doctor.duc@petcare.test` | Bác sĩ Ngoại khoa & Phẫu thuật |
| **Doctor** | `doctor.truong@petcare.test` | Bác sĩ Nội khoa & Chẩn đoán hình ảnh |
| **Doctor** | `doctor.nhu@petcare.test` | Bác sĩ Da liễu & Nha khoa thú y |
| **Customer** | `customer1@gmail.com` | Khách hàng (Chủ thú cưng Milo & Bông) |

---

## 👥 Danh sách Thành viên Nhóm 2 (Lập trình Web)
1. **Nguyễn Xuân Hiếu** (Nhóm trưởng) – 060206005938
2. **Lê Nguyễn Nhật Trường** – 082206010882
3. **Nguyễn Thị Thảo Như** – 079306030635
4. **Nguyễn Phạm Y Huỳnh** – 089306012585
5. **Lê Hữu Châu** – 064206014620
6. **Nguyễn Anh Thư** – 075306020699

*Giảng viên hướng dẫn: **Trần Thịnh Mạnh Đức** – Học kỳ 1, Năm học 2026-2027*
