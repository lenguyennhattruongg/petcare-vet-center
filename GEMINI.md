# GEMINI.md - Quy tắc Kiến trúc & Phát triển Dự án Hệ thống Trung tâm Thú y PetCare (Production-Grade)

> File cấu hình quy chuẩn cho dự án. Mọi thay đổi về kiến trúc, CSDL hoặc nghiệp vụ phải đồng bộ tuyệt đối với `docs/dac-ta-yeu-cau.md` (phiên bản 1.3).
> Tiêu chuẩn chất lượng: **Sản phẩm thương mại hoàn chỉnh (Production-grade Web Application)** sẵn sàng đưa vào vận hành thực tế tại phòng khám/bệnh viện thú y.

---

## 1. Tầm nhìn & Quy chuẩn Dự án

- **Tên hệ thống:** Hệ thống Website & Quản trị Trung tâm Thú y PetCare (PetCare Veterinary Clinic & Hospital System).
- **Mục tiêu sản phẩm:** Xây dựng một giải pháp chuyển đổi số toàn diện cho phòng khám thú y, phục vụ đồng thời 4 đối tượng: Khách hàng (Chủ thú cưng), Nhân viên tiếp tân (Lễ tân/Thu ngân), Bác sĩ thú y (Khám lâm sàng & Kê đơn), và Ban Quản trị/Giám đốc trung tâm.
- **Tiêu chuẩn kỹ thuật:**
  - Không làm dạng bài tập mô phỏng sơ sài; mọi luồng nghiệp vụ, giao diện và dữ liệu phải đạt chuẩn sản phẩm thương mại thực tế.
  - Kiến trúc phân tầng rõ ràng (Clean N-Tier Architecture), tách biệt giữa Routes (Controllers), Services (Nghiệp vụ), Models (CSDL) và Templates (Giao diện).
  - Tích hợp hệ thống **RESTful API chuẩn mực (`/api/v1/...`)** song hành cùng Web UI truyền thống để hỗ trợ trải nghiệm mượt mà không tải lại trang (AJAX/Fetch API) và sẵn sàng kết nối Mobile App trong tương lai.

---

## 2. Công nghệ & Môi trường Chạy

- **Frontend & Giao diện:**
  - HTML5, Vanilla CSS3 (xây dựng Design System chuyên nghiệp với CSS Variables), JavaScript ES6.
  - Thư viện UI: Bootstrap 5, Bootstrap Icons, Chart.js (trực quan hóa dữ liệu thống kê).
  - Trải nghiệm động (AJAX / Fetch API): Lấy khung giờ trống real-time, thêm giỏ hàng không reload, sinh mã thanh toán VietQR động.
- **Backend:**
  - **Python 3.10+ với Flask**, thiết kế theo Application Factory Pattern (`create_app()`).
  - Phân chia module bằng **Flask Blueprints**:
    - `client_bp`: Cổng thông tin công khai & dịch vụ khách hàng.
    - `staff_bp`: Phân hệ tiếp tân, điều phối lịch hẹn và thu ngân tại quầy.
    - `doctor_bp`: Phân hệ khám bệnh lâm sàng, bệnh án điện tử, kê đơn thuốc.
    - `admin_bp`: Bảng điều khiển quản trị, báo cáo tài chính, nhân sự, kho bãi.
    - `api_v1_bp`: Hệ thống REST API chuẩn JSON.
- **Cơ sở dữ liệu (Database):**
  - **MySQL 8.0+** (InnoDB, `utf8mb4_unicode_ci`), kết nối qua **Flask-SQLAlchemy** và driver **PyMySQL**.
  - Kiểm soát giao dịch (Database Transactions) nghiêm ngặt, sử dụng khóa dòng `.with_for_update()` để triệt tiêu hoàn toàn race-condition khi đặt lịch hoặc trừ tồn kho đồng thời.
- **Bảo mật & Phiên làm việc:**
  - `Flask-Login` quản lý phiên người dùng (Session HttpOnly, SameSite, bảo mật chống Session Fixation).
  - `Flask-WTF` bảo vệ toàn diện chống CSRF trên mọi form POST và headers AJAX.
  - Băm mật khẩu bằng thuật toán `scrypt` an toàn thông qua `Werkzeug`.
  - Phân quyền theo vai trò (Role-Based Access Control - RBAC) tại tầng Server qua custom decorators (`@role_required`).
- **Thanh toán & Tích hợp:**
  - Tiền mặt tại quầy, COD khi giao hàng.
  - **Chuyển khoản VietQR động:** Tự động sinh mã QR ngân hàng chuẩn Napas 247 gắn sẵn đúng số tiền và mã hóa đơn/mã lịch khám để khách quét thanh toán tức thì.
- **DevOps & Triển khai:**
  - Môi trường ảo Python (`venv`), quản lý gói qua `requirements.txt`.
  - Hỗ trợ triển khai Production: WSGI Server (Gunicorn / Waitress), file cấu hình môi trường `.env`, `Dockerfile` và `docker-compose.yml`.

---

## 3. Kiến trúc Mã nguồn (Directory Structure)

```
vet-center/
├── app/
│   ├── __init__.py              # Application Factory (create_app), nạp extension & Blueprints
│   ├── routes/                  # Controller / Routes phân theo đối tượng
│   │   ├── __init__.py
│   │   ├── client.py            # Trang chủ, dịch vụ, đặt lịch, giỏ hàng, hồ sơ thú cưng
│   │   ├── staff.py             # Tiếp nhận tại quầy, check-in, phân công bác sĩ, POS đơn hàng
│   │   ├── doctor.py            # Bệnh án điện tử, kê đơn, tiêm phòng, lịch tái khám
│   │   ├── admin.py             # Quản lý nhân sự, ca trực, báo cáo BI, cấu hình trung tâm
│   │   └── api/                 # Phân hệ RESTful API v1
│   │       ├── __init__.py
│   │       ├── appointments.py  # API lấy slot trống, đặt lịch nhanh
│   │       ├── cart.py          # API cập nhật giỏ hàng AJAX
│   │       └── analytics.py     # API cung cấp số liệu vẽ biểu đồ Chart.js
│   ├── models/                  # SQLAlchemy Models (23 bảng dữ liệu quan hệ)
│   │   ├── __init__.py
│   │   ├── user.py              # users, doctors, password_resets
│   │   ├── pet.py               # pets
│   │   ├── service.py           # services, service_categories, work_schedules
│   │   ├── appointment.py       # appointments
│   │   ├── medical.py           # medical_records, prescriptions, prescription_items, vaccinations
│   │   ├── shop.py              # products, product_categories, stock_movements, cart_items, orders, order_items
│   │   ├── payment.py           # payments
│   │   └── system.py            # reviews, notifications, settings, audit_logs, contact_messages
│   ├── services/                # Tầng nghiệp vụ xử lý logic độc lập (Business Services)
│   │   ├── booking_service.py   # Thuật toán BR-02 chống trùng lịch, khóa dòng with_for_update
│   │   ├── inventory_service.py # Xử lý trừ kho nguyên tử BR-08, cảnh báo tồn kho
│   │   ├── payment_service.py   # Sinh mã VietQR, xác nhận thanh toán, hoàn tiền BR-11
│   │   ├── auth_service.py      # Đăng ký, kích hoạt tài khoản tại quầy BR-12
│   │   └── mail_service.py      # Gửi email khôi phục mật khẩu & nhắc lịch
│   ├── middleware/              # auth.py (login_required, role_required, audit_middleware)
│   ├── templates/               # Giao diện Jinja2 chuyên nghiệp
│   │   ├── layouts/             # base.html, navbar, footer, sidebar admin/staff, alerts
│   │   ├── client/              # Giao diện khách hàng (trang chủ, đặt lịch, giỏ hàng...)
│   │   ├── staff/               # Giao diện điều phối tiếp tân tại quầy
│   │   ├── doctor/              # Giao diện khám bệnh lâm sàng của Bác sĩ
│   │   ├── admin/               # Giao diện Dashboard quản trị & phân tích
│   │   └── errors/              # 400.html, 403.html, 404.html, 500.html
│   ├── static/                  # Tài nguyên tĩnh
│   │   ├── css/                 # design-system.css, style.css, admin.css
│   │   ├── js/                  # main.js, booking-wizard.js, cart.js, charts.js
│   │   ├── images/              # Logo, banner, default avatars
│   │   └── uploads/             # Thư mục lưu file tải lên an toàn (pets, doctors, products)
│   └── utils/                   # helpers.py, validators.py, vietqr.py
├── config/
│   ├── __init__.py
│   ├── config.py                # DevelopmentConfig, TestingConfig, ProductionConfig
│   └── .env.example             # Mẫu khai báo biến môi trường chuẩn
├── database/
│   ├── schema.sql               # CSDL MySQL chuẩn DDL đầy đủ chỉ mục và ràng buộc
│   └── seed.sql                 # Dữ liệu phòng khám mẫu thực tế (bác sĩ, dịch vụ, ca trực)
├── storage/
│   └── logs/                    # File log xoay vòng: app.log, error.log, audit.log
├── tests/                       # Unit tests & Concurrency integration tests
├── docs/                        # Đặc tả yêu cầu, tài liệu API, sơ đồ ERD
├── GEMINI.md
├── requirements.txt
├── app.py                       # Điểm khởi chạy WSGI Application
└── README.md
```

---

## 4. Bốn Phân hệ Vận hành Thực tế của Trung tâm Thú y

### 4.1. Phân hệ Khách hàng & Chủ thú cưng (Customer Portal)
- Khám phá dịch vụ, giá niêm yết rõ ràng, xem thông tin chuyên môn của từng Bác sĩ.
- Luồng đặt lịch khám thông minh 6 bước: Chọn thú cưng ➔ Chọn dịch vụ ➔ Chọn Bác sĩ ➔ Chọn ngày/giờ (chỉ hiện giờ trống theo ca trực) ➔ Ghi chú triệu chứng ➔ Xác nhận & Nhận mã lịch hẹn `LH...`.
- Bệnh án điện tử cho thú cưng: Xem lại phác đồ điều trị, chẩn đoán, đơn thuốc điện tử và lịch sử tiêm phòng.
- Cửa hàng trực tuyến: Mua sắm thức ăn, phụ kiện, thuốc chăm sóc; thanh toán linh hoạt bằng VietQR hoặc COD.

### 4.2. Phân hệ Tiếp tân & Điều phối tại quầy (Front-Desk / Staff Portal)
- Tiếp nhận bệnh nhân: Tìm kiếm hồ sơ thú cưng/khách hàng bằng số điện thoại trong 1 giây.
- Check-in tại quầy: Tạo hồ sơ khách vãng lai, chuyển trạng thái lịch hẹn sang `confirmed` hoặc `in_progress`.
- Điều phối bác sĩ: Phân công bác sĩ trực tiếp cho các lịch hẹn khách không chọn bác sĩ cụ thể.
- POS thu ngân: Thu tiền mặt / tạo mã VietQR thanh toán tại quầy, xuất hóa đơn và xác nhận thanh toán dịch vụ.

### 4.3. Phân hệ Bác sĩ Thú y Lâm sàng (Doctor Clinical Portal)
- Bảng ca trực cá nhân: Bác sĩ theo dõi danh sách bệnh nhân được phân công theo ngày/giờ.
- Hồ sơ khám bệnh điện tử (Veterinary EHR): Ghi nhận triệu chứng lâm sàng, chẩn đoán bệnh, phương pháp điều trị, hẹn ngày tái khám.
- Kê đơn thuốc điện tử: Chọn thuốc, nhập số lượng, liều dùng (`mg/kg/ngày`), thời gian dùng và lời dặn dò.

### 4.4. Phân hệ Giám đốc & Quản trị Hệ thống (Admin & Business Intelligence)
- Quản trị ca làm việc (`work_schedules`): Cấu hình ca trực linh hoạt cho từng bác sĩ theo từng ngày trong tuần.
- Quản lý kho dược phẩm & hàng hóa: Quản lý biến động nhập/xuất kho (`stock_movements`), tự động cảnh báo tồn kho thấp dưới ngưỡng.
- Báo cáo tài chính & vận hành (BI Dashboard): Thống kê doanh thu theo ngày/tháng/năm, phân tích dịch vụ được ưa chuộng, năng suất làm việc của bác sĩ bằng biểu đồ Chart.js trực quan.
- Hệ thống Kiểm toán (Audit Logging): Bắt buộc ghi lại mọi thao tác chỉnh sửa bệnh án sau khi hoàn tất hoặc hủy thanh toán để đảm bảo tính pháp lý y khoa.

---

## 5. Quy tắc Nghiệp vụ Cốt lõi (BR-01 đến BR-14)

- **BR-01 (Giờ hoạt động & Khung giờ):** Giờ phòng khám mặc định 08:00–17:00 (lấy từ `settings`); mỗi slot khám 30 phút. Slot đặt phải đồng thời hợp lệ trong giờ trung tâm VÀ nằm trong ca trực của bác sĩ (`work_schedules`).
- **BR-02 (Chống trùng lịch tuyệt đối - Concurrency Protection):** Khách chọn giờ bắt đầu, hệ thống tự tính `end_time = start_time + duration`. Trong transaction CSDL, sử dụng khóa dòng `SELECT ... FOR UPDATE` (khóa bác sĩ trước, thú cưng sau) để đảm bảo nếu 2 khách bấm đặt cùng 1 mili-giây thì chỉ 1 người thành công, người còn lại nhận thông báo khung giờ vừa được đặt.
- **BR-03 (Thời điểm đặt lịch):** Đặt trước tối thiểu 2 giờ, tối đa 30 ngày.
- **BR-04 (Hủy/Đổi lịch):** Khách chỉ được hủy/đổi lịch trước giờ hẹn ít nhất 2 giờ. Lịch đổi quay về trạng thái `pending` và kiểm tra lại BR-02.
- **BR-05 (Phân công bác sĩ):** Nếu khách không chọn bác sĩ, tiếp tân/admin phân công bác sĩ có ca trực phù hợp khi xác nhận lịch.
- **BR-06 (Bảo mật Bệnh án):** Chỉ Bác sĩ được tạo/sửa bệnh án và đơn thuốc khi lịch hẹn ở trạng thái `in_progress` hoặc `completed`. Sửa sau khi hoàn thành phải lưu vết vào `audit_logs`.
- **BR-07 (Xóa mềm - Soft Delete):** Không xóa cứng các thực thể đã phát sinh dữ liệu (User, Pet, Service, Product).
- **BR-08 (Trừ kho an toàn - Atomic Inventory):** Trừ kho khi đặt hàng thành công bằng lệnh cập nhật nguyên tử: `UPDATE products SET stock_quantity = stock_quantity - ? WHERE id = ? AND stock_quantity >= ?`. Hoàn kho tự động khi đơn bị hủy.
- **BR-09 (Toàn vẹn giá):** Giá và tổng tiền luôn do máy chủ tính toán từ CSDL, không bao giờ tin giá gửi từ trình duyệt.
- **BR-10 (Đánh giá thực tế):** Chỉ khách hàng đã hoàn thành dịch vụ hoặc đơn hàng mới được gửi đánh giá; đánh giá hiển thị sau khi Admin duyệt.
- **BR-11 (Thanh toán & Hoàn tiền):** Hỗ trợ tiền mặt, COD và chuyển khoản VietQR tự động. Hoàn tiền ghi nhận trạng thái `refunded` và ghi audit log.
- **BR-12 (Tài khoản quầy):** Hồ sơ tạo tại quầy có `status = pending_activation`, chưa có mật khẩu. Khi cập nhật email sẽ gửi link kích hoạt để khách tự tạo mật khẩu.
- **BR-13 (Kiểm soát truy cập):** Xem thông tin dịch vụ, bác sĩ, bài viết không cần đăng nhập; đặt lịch, xem bệnh án, giỏ hàng, mua sắm cần tài khoản.
- **BR-14 (Hệ thống Thông báo):** Tự động phát thông báo trong hệ thống khi lịch hẹn, đơn hàng hoặc lịch tiêm phòng có cập nhật mới.

---

## 6. Kế hoạch Triển khai theo 5 Mốc Chuẩn (Milestones)

- **Mốc 1: Nền tảng Kiến trúc, CSDL & Layout Doanh nghiệp**
  - Khởi tạo Application Factory, kết nối MySQL qua SQLAlchemy, hệ thống log xoay vòng.
  - Xây dựng Design System CSS, Base Layout Bootstrap 5 chuẩn mực và các trang lỗi HTTP (400, 403, 404, 500).
  - Viết file `database/schema.sql` và `database/seed.sql` với dữ liệu thực tế phòng khám.
- **Mốc 2: Phân hệ Xác thực & Phân quyền Đa tầng (Auth & RBAC)**
  - Đăng ký, đăng nhập bảo mật, đổi mật khẩu, bảo vệ CSRF toàn diện.
  - Phân quyền nghiêm ngặt 4 vai trò (`customer`, `staff`, `doctor`, `admin`) bằng decorators.
- **Mốc 3: Danh mục Dịch vụ, Đội ngũ Bác sĩ & Hồ sơ Thú cưng**
  - Trang chủ chuyên nghiệp, trang giới thiệu bác sĩ chuyên khoa, bảng giá dịch vụ.
  - Phân hệ khách hàng quản lý thú cưng (ảnh đại diện, giống loài, cân nặng, tiền sử bệnh).
  - Admin quản lý dịch vụ và nhân sự.
- **Mốc 4: Đặt lịch Khám thông minh & Thuật toán Chống Trùng giờ (Core Booking)**
  - Quản lý ca làm việc bác sĩ, API lấy slot trống theo thời gian thực.
  - Quy trình đặt lịch 6 bước mượt mà, kiểm tra khóa dòng `with_for_update()` chống race condition.
  - Tiếp tân tiếp nhận, điều phối bác sĩ và check-in tại quầy.
- **Mốc 5: Bệnh án Điện tử, Đơn thuốc & Vận hành Lâm sàng**
  - Bác sĩ ghi bệnh án, kê đơn thuốc chi tiết liều lượng, hẹn ngày tiêm phòng & tái khám.
  - Khách hàng xem hồ sơ sức khỏe thú cưng online.
  - Hệ thống ghi nhật ký kiểm toán (Audit Trail) cho toàn bộ thao tác y khoa.
- **Giai đoạn tiếp theo: Cửa hàng Dược phẩm, Thanh toán VietQR & Báo cáo BI**
  - Giỏ hàng, đặt hàng, trừ tồn kho an toàn, tạo mã QR VietQR động thanh toán.
  - Báo cáo phân tích doanh thu và hiệu suất phòng khám bằng Chart.js.
