# Đặc tả Yêu cầu Kỹ thuật Hệ thống Trung tâm Thú y PetCare (Production-Grade)
Phiên bản 1.3 · Cập nhật ngày 14/10/2026 · Hệ thống Thương mại & Chuyển đổi số Phòng khám Thú y
Trường Đại học Giao thông Vận tải TP. Hồ Chí Minh – Viện Công nghệ Thông tin và Điện, Điện tử
Giảng viên hướng dẫn: Trần Thịnh Mạnh Đức
Sinh viên thực hiện:
- Nguyễn Xuân Hiếu (nhóm trưởng) – 060206005938
- Lê Nguyễn Nhật Trường – 082206010882
- Nguyễn Thị Thảo Như – 079306030635
- Nguyễn Phạm Y Huỳnh – 089306012585
- Lê Hữu Châu – 064206014620
- Nguyễn Anh Thư – 075306020699

## Lịch sử phiên bản
| Phiên bản | Ngày | Nội dung thay đổi |
|---|---|---|
| 1.0 | 01/10/2026 | Bản đặc tả ban đầu |
| 1.1 | 14/10/2026 | Bổ sung phân quyền 4 vai trò, ma trận quyền hạn, quy tắc nghiệp vụ BR-01 đến BR-14, vòng đời trạng thái lịch hẹn/đơn hàng/thanh toán. |
| 1.2 | 14/10/2026 | Làm rõ phân công ca trực bác sĩ do Admin quản trị; thanh toán dùng hai khóa ngoại cụ thể thay quan hệ đa hình; chi tiết hóa cơ chế chống đặt lịch trùng bằng khóa dòng `FOR UPDATE`; bổ sung kích hoạt tài khoản quầy và trừ kho an toàn. |
| 1.3 | 14/10/2026 | **Nâng cấp toàn diện lên chuẩn Hệ thống Thương mại Thực tế (Production-Grade):** Chuyển đổi nền tảng sang **Python 3.10+ / Flask Clean N-Tier Architecture**, tích hợp hệ sinh thái **RESTful API v1 (`/api/v1/...`)**, hỗ trợ thanh toán chuyển khoản **VietQR động (Napas 247)**, tối ưu cơ chế khóa dòng Concurrency `with_for_update()`, nâng cấp bệnh án điện tử (Veterinary EHR), sẵn sàng triển khai Container hóa (Docker & WSGI Production Server). |

---

## 1. GIỚI THIỆU CHUNG & TẦM NHÌN SẢN PHẨM

### 1.1. Tầm nhìn hệ thống
PetCare là giải pháp phần mềm chuyển đổi số toàn diện cho chuỗi phòng khám và bệnh viện thú y hiện đại. Hệ thống tích hợp liền mạch giữa **Kênh dịch vụ trực tuyến dành cho khách hàng** và **Hệ thống điều hành vận hành nội bộ (Back-office ERP/Clinic Management)**.

Sản phẩm được thiết kế theo các tiêu chuẩn kỹ thuật cấp doanh nghiệp:
1. **Kiến trúc phân tầng sạch (Clean N-Tier Architecture):** Phân tách rạch ròi giữa Tầng giao diện (Templates/Jinja2), Tầng điều hướng (Blueprints/Controllers), Tầng nghiệp vụ (Services) và Tầng dữ liệu (SQLAlchemy ORM Models).
2. **Hệ thống API RESTful kép:** Phục vụ tương tác thời gian thực trên Web thông qua AJAX/Fetch API, đồng thời sẵn sàng mở rộng cho ứng dụng di động (Mobile App iOS/Android).
3. **Trải nghiệm người dùng cao cấp (Premium UI/UX):** Giao diện Bootstrap 5 được tùy biến hoàn toàn theo Design System thương hiệu, tối ưu trải nghiệm tương tác không gián đoạn, hỗ trợ đa màn hình từ thiết bị di động (Mobile-first) đến máy tính bảng và màn hình quầy lễ tân.

### 1.2. Các nhóm người dùng & Phân quyền vận hành
Hệ thống vận hành với 4 vai trò đăng nhập có kiểm soát bảo mật chặt chẽ:

| Phân hệ / Chức năng | Khách vãng lai | Khách hàng (Customer) | Tiếp tân / Quầy (Staff) | Bác sĩ Thú y (Doctor) | Giám đốc / Quản trị (Admin) |
|---|:---:|:---:|:---:|:---:|:---:|
| Xem dịch vụ, bảng giá, đội ngũ bác sĩ, bài viết | ✓ | ✓ | ✓ | ✓ | ✓ |
| Đăng ký, đăng nhập bảo mật, quản lý tài khoản | ✓ | ✓ | ✓ | ✓ | ✓ |
| Quản lý hồ sơ thú cưng cá nhân | – | ✓ | – | – | – |
| Đặt lịch khám, theo dõi, hủy/đổi lịch cá nhân | – | ✓ | – | – | – |
| Mua sắm, giỏ hàng, thanh toán VietQR / COD | – | ✓ | – | – | – |
| Tra cứu hồ sơ bệnh án điện tử thú cưng | – | ✓ (Của mình) | ✓ (Chỉ đọc) | ✓ (Toàn quyền) | ✓ (Xem có ghi log) |
| Tiếp nhận bệnh tại quầy, check-in, tạo khách vãng lai | – | – | ✓ | – | ✓ |
| Điều phối bác sĩ, xác nhận/hủy lịch hẹn | – | – | ✓ | ✓ (Lịch của mình) | ✓ |
| Khám bệnh lâm sàng, ghi chẩn đoán, kê đơn thuốc điện tử | – | – | – | ✓ | – |
| Thu ngân tại quầy, xuất hóa đơn, cập nhật thanh toán | – | – | ✓ | – | ✓ |
| Quản lý biến động xuất/nhập kho hàng & dược phẩm | – | – | ✓ | – | ✓ |
| Cấu hình ca trực bác sĩ, quản trị dịch vụ, người dùng | – | – | – | – | ✓ |
| Báo cáo tài chính, biểu đồ phân tích doanh thu BI | – | – | – | – | ✓ |
| Quản trị nhật ký kiểm toán y khoa (Audit Trail) | – | – | – | – | ✓ |

---

## 2. YÊU CẦU CHỨC NĂNG CHI TIẾT (FUNCTIONAL MODULES)

### 2.1. Phân hệ Cổng thông tin & Khách hàng (Client Portal)
- **2.1.1. Cổng thông tin thương hiệu:** Giới thiệu trang thiết bị hiện đại, đội ngũ bác sĩ chuyên khoa, bảng giá dịch vụ minh bạch, cẩm nang y tế thú cưng.
- **2.1.2. Đăng ký & Bảo mật tài khoản:** Xác thực an toàn, phiên làm việc bảo mật chống tấn công giả mạo, đổi mật khẩu, kích hoạt tài khoản tạo tại quầy (BR-12).
- **2.1.3. Hồ sơ thú cưng điện tử:** Quản lý thông tin chi tiết (giống, loài, tuổi, cân nặng, tiền sử dị ứng/bệnh lý, ảnh nhận diện), liên kết trọn đời với lịch sử khám.
- **2.1.4. Đặt lịch khám đa khoa / chuyên khoa thông minh:**
  - Lựa chọn linh hoạt: Khám tổng quát, tiêm phòng, phẫu thuật, spa/grooming.
  - Tự động hiển thị các khung giờ còn trống (live-slots) theo ca trực thực tế của bác sĩ.
  - Thuật toán chống đặt trùng đồng thời (BR-02) bảo vệ tính toàn vẹn dữ liệu.
- **2.1.5. Hồ sơ Bệnh án điện tử cá nhân (Personal Veterinary EHR):** Chủ thú cưng theo dõi chi tiết từng lần khám bệnh: triệu chứng ban đầu, kết luận chẩn đoán của bác sĩ, phác đồ điều trị, đơn thuốc chi tiết và hạn tiêm vắc-xin tiếp theo.
- **2.1.6. Cửa hàng Dược phẩm & Chăm sóc Thú cưng:** Tìm kiếm, lọc sản phẩm theo danh mục, giỏ hàng AJAX mượt mà, kiểm tra tồn kho theo thời gian thực (BR-08).
- **2.1.7. Thanh toán thông minh (Smart Checkout):**
  - Thanh toán tiền mặt tại quầy / COD khi nhận hàng.
  - **Tích hợp VietQR động:** Tự động sinh mã QR ngân hàng chuẩn Napas 247 gắn sẵn đúng số tiền và mã hóa đơn để khách quét thanh toán tức thì qua App Mobile Banking.

### 2.2. Phân hệ Tiếp tân & Điều phối tại quầy (Front-Desk / Staff Portal)
- **2.2.1. Bàn tiếp tân thông minh (Reception Dashboard):** Tìm kiếm khách hàng và thú cưng tức thì qua số điện thoại; tạo nhanh hồ sơ cho khách vãng lai chưa có tài khoản.
- **2.2.2. Điều phối lịch hẹn & Check-in:** Quản lý hàng đợi khám bệnh; chuyển trạng thái lịch hẹn khi khách tới phòng khám (`confirmed` ➔ `in_progress`); phân bổ bác sĩ trực phù hợp với ca khám.
- **2.2.3. POS Thu ngân & Hóa đơn:** Thu tiền khám và tiền thuốc/sản phẩm; in phiếu thu / hóa đơn dịch vụ; xác nhận giao dịch chuyển khoản VietQR tại quầy.
- **2.2.4. Quản lý Kho Dược phẩm & Hàng hóa:** Cập nhật phiếu nhập/xuất kho (`stock_movements`), kiểm soát số lượng thuốc tồn thực tế, theo dõi cảnh báo khi mặt hàng chạm ngưỡng tồn an toàn.

### 2.3. Phân hệ Bác sĩ Thú y Khám chữa bệnh (Clinical Doctor Portal)
- **2.3.1. Bảng điều khiển Bác sĩ:** Xem lịch trực, danh sách thú cưng đang chờ khám trong ngày.
- **2.3.2. Bệnh án điện tử lâm sàng (Veterinary EHR):**
  - Ghi nhận triệu chứng lâm sàng (nhiệt độ, thể trạng, hô hấp...).
  - Chẩn đoán bệnh lý chính và bệnh lý kèm theo.
  - Ghi nhận phác đồ điều trị và dặn dò chăm sóc tại nhà.
  - Hẹn ngày tái khám / tiêm mũi nhắc lại.
- **2.3.3. Kê đơn thuốc điện tử (E-Prescription):**
  - Tra cứu danh mục dược phẩm có sẵn trong kho.
  - Kê đơn gồm: Tên thuốc, số lượng, hàm lượng, liều dùng (`mg/kg/lần`), số lần uống trong ngày và hướng dẫn sử dụng.

### 2.4. Phân hệ Giám đốc & Quản trị Hệ thống (Admin & Business Intelligence)
- **2.4.1. Quản lý Ca làm việc & Phòng khám (`work_schedules`):** Phân chia ca trực (Sáng / Chiều / Cả ngày) cho đội ngũ bác sĩ theo từng ngày cụ thể; thiết lập ngày nghỉ lễ, nghỉ đột xuất.
- **2.4.2. Báo cáo Quản trị & Phân tích Kinh doanh (BI Dashboard):**
  - Biểu đồ doanh thu đa chiều theo thời gian (ngày, tuần, tháng, quý, năm) bằng Chart.js.
  - Phân tích cơ cấu doanh thu: Tỷ trọng từ Dịch vụ khám chữa bệnh vs Bán lẻ dược phẩm/sản phẩm.
  - Thống kê hiệu suất làm việc của từng bác sĩ (số ca khám hoàn thành, đánh giá của khách).
  - Thống kê tỷ lệ hủy hẹn và tỷ lệ khách không đến (`no_show`).
- **2.4.3. Quản lý Đánh giá & Phản hồi Khách hàng:** Kiểm duyệt nhận xét, xếp hạng sao của khách sau khi dịch vụ hoàn tất trước khi hiển thị công khai.
- **2.4.4. Nhật ký Kiểm toán Y khoa (Audit Trail):** Tự động ghi nhận mọi hành vi chỉnh sửa hồ sơ bệnh án sau khi đã hoàn tất, thay đổi trạng thái thanh toán, khóa tài khoản nhằm phục vụ thanh tra và đảm bảo tính pháp lý y khoa.

---

## 3. QUY TẮC NGHIỆP VỤ HỆ THỐNG (BR-01 ĐẾN BR-14)

- **BR-01 (Giờ hoạt động & Khung giờ):** Giờ trung tâm mặc định 08:00–17:00 (cấu hình trong `settings`); mỗi slot khám 30 phút. Khung giờ đặt lịch bắt buộc phải thỏa mãn đồng thời: nằm trong giờ trung tâm VÀ nằm trong ca trực của bác sĩ (`work_schedules`).
- **BR-02 (Chống xung đột lịch hẹn Concurrency):**
  - Khách chỉ chọn giờ bắt đầu, hệ thống tự động tính `end_time = start_time + duration`.
  - Hai lịch bị xem là xung đột khi `new_start < old_end` VÀ `new_end > old_start`.
  - Cơ chế khóa dòng an toàn: Trong transaction CSDL, sử dụng `SELECT ... FOR UPDATE` (khóa dòng Bác sĩ trước, thú cưng sau theo thứ tự cố định để tránh deadlock) trước khi kiểm tra và ghi bản ghi mới.
- **BR-03 (Thời điểm đặt lịch):** Đặt trước tối thiểu 2 giờ và tối đa 30 ngày so với thời điểm hiện tại.
- **BR-04 (Chính sách Hủy / Đổi lịch):** Khách chỉ được hủy hoặc đổi lịch trước giờ hẹn ít nhất 2 giờ và khi lịch ở trạng thái `pending` hoặc `confirmed`. Lịch đã đổi sẽ trở về `pending` để tiếp tân thẩm định và kiểm tra lại BR-02.
- **BR-05 (Điều phối bác sĩ):** Trường hợp khách không chỉ định bác sĩ khi đặt lịch, tiếp tân hoặc quản trị viên sẽ phân công bác sĩ có ca trực phù hợp khi xác nhận.
- **BR-06 (Toàn vẹn Hồ sơ Y khoa):** Chỉ Bác sĩ mới có quyền lập và chỉnh sửa bệnh án, đơn thuốc. Chỉ được tạo bệnh án khi lịch hẹn ở trạng thái `in_progress` hoặc `completed`. Bất kỳ thao tác chỉnh sửa nào sau khi hoàn thành đều bị ghi vết vào `audit_logs`.
- **BR-07 (Chính sách Xóa mềm):** Không xóa cứng các bản ghi đã phát sinh dữ liệu liên kết (người dùng, thú cưng, dịch vụ, sản phẩm); sử dụng cờ trạng thái hoặc cột `deleted_at`.
- **BR-08 (Trừ kho nguyên tử - Atomic Inventory Control):**
  - Trừ kho ngay khi đặt hàng thành công bằng câu lệnh cập nhật có điều kiện: `UPDATE products SET stock_quantity = stock_quantity - ? WHERE id = ? AND stock_quantity >= ?`.
  - Tự động hoàn lại tồn kho khi đơn hàng bị hủy trước khi giao.
  - Mọi biến động ghi nhận vào `stock_movements` với số lượng dương và định danh loại rõ ràng.
- **BR-09 (Toàn vẹn Giá & Doanh thu):** Giá trị đơn hàng và dịch vụ luôn được tính toán và kiểm tra độc lập tại tầng Server từ CSDL; tuyệt đối không tin cậy giá gửi lên từ Client.
- **BR-10 (Xác thực Đánh giá):** Chỉ cho phép đánh giá dịch vụ/sản phẩm đối với khách hàng đã hoàn thành thực tế (`status = completed`).
- **BR-11 (Quy trình Thanh toán & Hoàn tiền):** Hỗ trợ tiền mặt tại quầy, COD, chuyển khoản VietQR tự động. Mọi thao tác hoàn tiền (`refunded`) phải do nhân viên/admin thực hiện thủ công kèm lý do và ghi nhận audit log.
- **BR-12 (Tài khoản Quầy & Bảo mật Mật khẩu):** Khách tạo tại quầy có trạng thái `pending_activation` và không có mật khẩu. Khi bổ sung email, hệ thống gửi liên kết token kích hoạt (hiệu lực 30 phút) để khách tự đặt mật khẩu. Đăng nhập sai 5 lần liên tiếp sẽ khóa tài khoản tạm thời 15 phút.
- **BR-13 (Phân định Khu vực Truy cập):** Xem thông tin công khai không cần tài khoản; đặt lịch, xem bệnh án, giỏ hàng, thanh toán yêu cầu đăng nhập.
- **BR-14 (Hệ thống Thông báo Tự động):** Tự động phát sinh thông báo trong ứng dụng khi có biến động về lịch hẹn, trạng thái đơn hàng, thanh toán và nhắc lịch tiêm phòng.

---

## 4. KIẾN TRÚC KỸ THUẬT & HỆ SINH THÁI REST API

### 4.1. Kiến trúc phân tầng (Clean N-Tier Architecture)
- **Tầng Điều khiển (Routes & Controllers):** Chia tách thành các Flask Blueprints riêng biệt (`client`, `staff`, `doctor`, `admin`, `api_v1`).
- **Tầng Nghiệp vụ (Business Services):** Đóng gói toàn bộ logic phức tạp trong thư mục `app/services/` (`BookingService`, `InventoryService`, `PaymentService`, `MedicalService`, `AuthService`).
- **Tầng Truy cập Dữ liệu (ORM Models):** SQLAlchemy ORM ánh xạ 23 bảng CSDL quan hệ, hỗ trợ transaction rollback và khóa dòng `with_for_update()`.
- **Tầng Giao diện (Presentation Layer):** Template Jinja2 kết hợp Design System Bootstrap 5, AJAX Fetch API.

### 4.2. Hệ thống RESTful API v1 (`/api/v1/...`)
Hệ thống cung cấp danh mục endpoints chuẩn RESTful phục vụ cả Web AJAX và Mobile App:
- `GET /api/v1/appointments/available-slots`: Lấy danh sách khung giờ trống theo ngày và bác sĩ.
- `POST /api/v1/appointments`: Đặt lịch khám nhanh qua API.
- `GET /api/v1/pets`: Lấy danh sách thú cưng của khách hàng đang đăng nhập.
- `POST /api/v1/cart/items`: Thêm sản phẩm vào giỏ hàng (cập nhật badge số lượng không reload trang).
- `GET /api/v1/payments/vietqr`: Sinh chuỗi và hình ảnh mã VietQR thanh toán cho đơn hàng / lịch hẹn.
- `GET /api/v1/admin/analytics/revenue`: Cung cấp dữ liệu doanh thu thời gian thực cho biểu đồ Chart.js.

---

## 5. MÔ HÌNH CƠ SỞ DỮ LIỆU (DATABASE SCHEMA - 23 BẢNG)

Hệ thống quản lý toàn diện trên CSDL MySQL 8.0 với các nhóm bảng:
1. **Người dùng & Nhân sự:** `users`, `doctors`, `password_resets`.
2. **Hồ sơ Thú cưng:** `pets`.
3. **Dịch vụ & Ca trực:** `service_categories`, `services`, `work_schedules`.
4. **Lịch hẹn & Tiếp nhận:** `appointments`.
5. **Hồ sơ Y khoa & Dược phẩm:** `medical_records`, `prescriptions`, `prescription_items`, `vaccinations`.
6. **Thương mại & Quản lý Kho:** `product_categories`, `products`, `stock_movements`, `cart_items`, `orders`, `order_items`.
7. **Thanh toán:** `payments` (hỗ trợ liên kết hóa đơn đơn hàng hoặc dịch vụ thông qua 2 khóa ngoại tường minh và ràng buộc CHECK).
8. **Hệ thống & Tương tác:** `reviews`, `notifications`, `email_logs`, `posts`, `settings`, `contact_messages`, `audit_logs`.

---

## 6. TIÊU CHÍ NGHIỆM THU CHẤT LƯỢNG THƯƠNG MẠI
- Vận hành mượt mà, đầy đủ tính năng của cả 4 phân hệ (Khách hàng, Tiếp tân, Bác sĩ, Quản trị).
- Thuật toán chống trùng lịch (BR-02) và trừ tồn kho (BR-08) vượt qua bài kiểm thử mô phỏng đa luồng (Concurrency Test).
- Giao diện đẹp, chuyên nghiệp, responsive hoàn hảo trên mọi kích thước màn hình.
- Hệ thống REST API chuẩn mực, hỗ trợ sinh mã VietQR chuyển khoản động chính xác.
- Sẵn sàng triển khai thực tế trên môi trường máy chủ với Docker Compose và WSGI Server.
