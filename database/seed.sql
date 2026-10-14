-- ==============================================================================
-- DATABASE SEED DATA: PETCARE VETERINARY CLINIC & HOSPITAL SYSTEM
-- Dữ liệu thực tế phòng khám thú y phục vụ phát triển & demo đánh giá
-- Mật khẩu mẫu chung cho mọi tài khoản: Password123@
-- ==============================================================================

USE `vet_center`;

SET FOREIGN_KEY_CHECKS = 0;

-- 1. Cấu hình hệ thống (settings)
INSERT INTO `settings` (`setting_key`, `setting_value`, `description`) VALUES
('clinic_name', 'Trung tâm & Bệnh viện Thú y PetCare', 'Tên thương hiệu phòng khám'),
('clinic_phone', '028.1234.5678', 'Hotline hỗ trợ khách hàng'),
('clinic_email', 'contact@petcare.test', 'Email liên hệ chính thức'),
('clinic_address', 'Số 2 Võ Oanh, Phường 25, Quận Bình Thạnh, TP. Hồ Chí Minh', 'Địa chỉ trụ sở chính'),
('working_hours_start', '08:00', 'Giờ mở cửa trung tâm'),
('working_hours_end', '17:00', 'Giờ đóng cửa trung tâm'),
('working_days', '1,2,3,4,5,6', 'Thứ 2 đến Thứ 7 (0 là CN)'),
('slot_duration_minutes', '30', 'Độ dài mỗi khung giờ khám (phút)'),
('booking_min_hours_ahead', '2', 'Số giờ phải đặt trước tối thiểu'),
('booking_max_days_ahead', '30', 'Số ngày được phép đặt trước tối đa'),
('cancel_min_hours_ahead', '2', 'Hạn chót cho phép hủy lịch trước giờ hẹn');

-- 2. Người dùng mẫu (users) - 1 admin, 2 staff, 3 doctors, 5 customers
-- Mật khẩu hash bên dưới là hash scrypt chuẩn của 'Password123@'
INSERT INTO `users` (`id`, `full_name`, `email`, `password_hash`, `phone`, `address`, `role`, `status`) VALUES
-- Admin
(1, 'Ban Giám Đốc PetCare', 'admin@petcare.test', 'scrypt:32768:8:1$1u5u6f0n$85ba99df031c510dbb8830fe3008ee72460ce4e0c45dae2eb52745cf0019e083c2670e302ce3709b1f7dca13759714aa40cbbe4c000c85c2759e66ffb2ef1b97', '0901234567', 'Trụ sở chính PetCare', 'admin', 'active'),

-- Staff (Tiếp tân / Thu ngân)
(2, 'Nguyễn Thị Thu Ngân', 'staff1@petcare.test', 'scrypt:32768:8:1$1u5u6f0n$85ba99df031c510dbb8830fe3008ee72460ce4e0c45dae2eb52745cf0019e083c2670e302ce3709b1f7dca13759714aa40cbbe4c000c85c2759e66ffb2ef1b97', '0902345678', 'Quận Bình Thạnh, TP.HCM', 'staff', 'active'),
(3, 'Trần Văn Tiếp Tân', 'staff2@petcare.test', 'scrypt:32768:8:1$1u5u6f0n$85ba99df031c510dbb8830fe3008ee72460ce4e0c45dae2eb52745cf0019e083c2670e302ce3709b1f7dca13759714aa40cbbe4c000c85c2759e66ffb2ef1b97', '0903456789', 'Quận 1, TP.HCM', 'staff', 'active'),

-- Doctors (Bác sĩ chuyên khoa Thú y)
(4, 'BS. CKI Trần Thịnh Mạnh Đức', 'doctor.duc@petcare.test', 'scrypt:32768:8:1$1u5u6f0n$85ba99df031c510dbb8830fe3008ee72460ce4e0c45dae2eb52745cf0019e083c2670e302ce3709b1f7dca13759714aa40cbbe4c000c85c2759e66ffb2ef1b97', '0911223344', 'Quận 3, TP.HCM', 'doctor', 'active'),
(5, 'BS. ThS Lê Nguyễn Nhật Trường', 'doctor.truong@petcare.test', 'scrypt:32768:8:1$1u5u6f0n$85ba99df031c510dbb8830fe3008ee72460ce4e0c45dae2eb52745cf0019e083c2670e302ce3709b1f7dca13759714aa40cbbe4c000c85c2759e66ffb2ef1b97', '0912334455', 'Quận Bình Thạnh, TP.HCM', 'doctor', 'active'),
(6, 'BS. Nguyễn Thị Thảo Như', 'doctor.nhu@petcare.test', 'scrypt:32768:8:1$1u5u6f0n$85ba99df031c510dbb8830fe3008ee72460ce4e0c45dae2eb52745cf0019e083c2670e302ce3709b1f7dca13759714aa40cbbe4c000c85c2759e66ffb2ef1b97', '0913445566', 'Quận Phú Nhuận, TP.HCM', 'doctor', 'active'),

-- Customers (Khách hàng)
(7, 'Hoàng Minh Tuấn', 'customer1@gmail.com', 'scrypt:32768:8:1$1u5u6f0n$85ba99df031c510dbb8830fe3008ee72460ce4e0c45dae2eb52745cf0019e083c2670e302ce3709b1f7dca13759714aa40cbbe4c000c85c2759e66ffb2ef1b97', '0981112223', 'Quận 7, TP.HCM', 'customer', 'active'),
(8, 'Phạm Quỳnh Anh', 'customer2@gmail.com', 'scrypt:32768:8:1$1u5u6f0n$85ba99df031c510dbb8830fe3008ee72460ce4e0c45dae2eb52745cf0019e083c2670e302ce3709b1f7dca13759714aa40cbbe4c000c85c2759e66ffb2ef1b97', '0982223334', 'Quận 2, TP.HCM', 'customer', 'active'),
(9, 'Đỗ Khắc Nam', 'customer3@gmail.com', 'scrypt:32768:8:1$1u5u6f0n$85ba99df031c510dbb8830fe3008ee72460ce4e0c45dae2eb52745cf0019e083c2670e302ce3709b1f7dca13759714aa40cbbe4c000c85c2759e66ffb2ef1b97', '0983334445', 'Quận Gò Vấp, TP.HCM', 'customer', 'active'),
(10, 'Vũ Mai Linh', 'customer4@gmail.com', 'scrypt:32768:8:1$1u5u6f0n$85ba99df031c510dbb8830fe3008ee72460ce4e0c45dae2eb52745cf0019e083c2670e302ce3709b1f7dca13759714aa40cbbe4c000c85c2759e66ffb2ef1b97', '0984445556', 'Quận 10, TP.HCM', 'customer', 'active'),
(11, 'Lê Quốc Hưng', 'customer5@gmail.com', 'scrypt:32768:8:1$1u5u6f0n$85ba99df031c510dbb8830fe3008ee72460ce4e0c45dae2eb52745cf0019e083c2670e302ce3709b1f7dca13759714aa40cbbe4c000c85c2759e66ffb2ef1b97', '0985556667', 'Quận Tân Bình, TP.HCM', 'customer', 'active');

-- 3. Hồ sơ chuyên môn Bác sĩ (doctors)
INSERT INTO `doctors` (`id`, `user_id`, `specialty`, `qualification`, `bio`) VALUES
(1, 4, 'Ngoại khoa & Phẫu thuật mô mềm', 'Tiến sĩ - Bác sĩ Thú y (ĐH Nông Lâm)', 'Chuyên gia hơn 15 năm kinh nghiệm trong phẫu thuật chỉnh hình và can thiệp ngoại khoa thú cưng.'),
(2, 5, 'Nội khoa & Chẩn đoán hình ảnh', 'Thạc sĩ Bác sĩ Thú y', 'Chuyên gia siêu âm Doppler, X-quang kỹ thuật số và điều trị bệnh truyền nhiễm ở chó mèo.'),
(3, 6, 'Da liễu & Nha khoa Thú cưng', 'Bác sĩ Thú y Chính quy', 'Nhiều năm kinh nghiệm điều trị nấm mốc, dị ứng da và phẫu thuật nha khoa thú y.');

-- 4. Danh mục Dịch vụ (service_categories)
INSERT INTO `service_categories` (`id`, `name`) VALUES
(1, 'Khám & Chẩn đoán lâm sàng'),
(2, 'Tiêm chủng & Phòng dịch'),
(3, 'Phẫu thuật & Ngoại khoa'),
(4, 'Spa, Tắm sấy & Cắt tỉa lông');

-- 5. Bảng giá Dịch vụ Thú y (services)
INSERT INTO `services` (`id`, `category_id`, `name`, `description`, `price`, `duration_minutes`, `status`) VALUES
(1, 1, 'Khám lâm sàng tổng quát', 'Đo thể thân, nghe tim phổi, kiểm tra tai mắt mũi họng cho thú cưng', 150000, 30, 'active'),
(2, 1, 'Siêu âm ổ bụng 4D', 'Khảo sát gan mật, thận, bàng quang và tử cung chẩn đoán thai sớm', 250000, 30, 'active'),
(3, 2, 'Tiêm vắc-xin 7 bệnh cho Chó (Vanguard)', 'Phòng bệnh Care, Parvo, Viêm gan, Ho cũi chó, Phế cầu...', 220000, 30, 'active'),
(4, 2, 'Tiêm vắc-xin 4 bệnh cho Mèo (Felocell)', 'Phòng bệnh Giảm bạch cầu, Viêm mũi khí quản, Calicivirus...', 240000, 30, 'active'),
(5, 2, 'Tiêm phòng bệnh Dại (Rabisin)', 'Vắc-xin phòng bệnh dại chứng nhận quốc tế', 100000, 30, 'active'),
(6, 3, 'Triệt sản Mèo Đực', 'Tiểu phẫu nhẹ nhàng, mau lành thương, giảm stress cho mèo', 500000, 60, 'active'),
(7, 3, 'Triệt sản Mèo Cái', 'Phẫu thuật đường bụng vô trùng, chỉ tự tiêu thẩm mỹ', 800000, 60, 'active'),
(8, 3, 'Cạo vôi răng & Đánh bóng', 'Làm sạch mảng bám ố vàng, khử mùi hôi miệng và viêm nướu', 350000, 60, 'active'),
(9, 4, 'Combo Tắm vệ sinh & Cắt tỉa Mèo', 'Tắm sấy, chải lông rụng, cắt móng, vệ sinh tai vắt tuyến hôi', 280000, 60, 'active'),
(10, 4, 'Combo Cắt tỉa tạo kiểu Chó Poodle', 'Grooming phong cách gấu bông Teddy chuẩn thẩm mỹ', 400000, 90, 'active');

-- 6. Hồ sơ Thú cưng (pets)
INSERT INTO `pets` (`id`, `owner_id`, `name`, `species`, `breed`, `gender`, `birth_date`, `weight_kg`, `health_note`) VALUES
(1, 7, 'Milo', 'Chó', 'Poodle Tiny', 'male', '2023-05-10', 3.2, 'Ngoan, đã tiêm phòng 2 mũi'),
(2, 7, 'Bông', 'Mèo', 'Anh lông ngắn', 'female', '2024-01-15', 4.1, 'Khỏe mạnh, thích ăn pate cá hồi'),
(3, 8, 'Lucky', 'Chó', 'Golden Retriever', 'male', '2022-11-20', 28.5, 'Hay bị viêm da dị ứng vào mùa mưa'),
(4, 8, 'Miu Miu', 'Mèo', 'Mèo Ta Tam Thể', 'female', '2023-08-05', 3.0, 'Đã triệt sản'),
(5, 9, 'Kiki', 'Chó', 'Corgi Pembroke', 'female', '2023-03-12', 11.4, 'Thừa cân nhẹ, cần kiểm soát chế độ ăn'),
(6, 9, 'Choco', 'Chó', 'Phốc Sóc Pomeranian', 'male', '2024-02-01', 2.5, 'Răng có mảng bám vôi răng'),
(7, 10, 'Simba', 'Mèo', 'Mèo Ba Tư', 'male', '2022-06-18', 4.8, 'Mắt hay chảy nước mắt, lông dài'),
(8, 10, 'Lu', 'Chó', 'Husky Siberian', 'male', '2021-09-09', 24.0, 'Năng động, tiêu hóa tốt'),
(9, 11, 'Sushi', 'Mèo', 'Mèo Xiêm', 'female', '2023-12-01', 3.6, 'Rất hiền, sợ tiếng sấm'),
(10, 11, 'Kem', 'Mèo', 'Anh lông dài', 'female', '2024-03-22', 2.8, 'Sắp đến lịch tiêm nhắc lại mũi 2');

-- 7. Danh mục & Sản phẩm (product_categories, products)
INSERT INTO `product_categories` (`id`, `name`) VALUES
(1, 'Thức ăn & Dinh dưỡng Thú cưng'),
(2, 'Thuốc thú y & Chăm sóc sức khỏe'),
(3, 'Phụ kiện & Đồ chơi thú cưng');

INSERT INTO `products` (`id`, `category_id`, `name`, `description`, `price`, `stock_quantity`, `low_stock_threshold`) VALUES
(1, 1, 'Hạt Royal Canin Mini Adult (Chó nhỏ 2kg)', 'Dinh dưỡng cân bằng kiểm soát cân nặng cho chó nhỏ', 360000, 45, 5),
(2, 1, 'Hạt Royal Canin British Shorthair (Mèo ALN 2kg)', 'Đặc chế cho khung xương và cơ bắp của mèo Anh lông ngắn', 390000, 38, 5),
(3, 1, 'Pate Wanpy Hộp Dinh Dưỡng 80g (Vị Cá Hồi)', 'Bổ sung Omega 3 mượt lông và cấp nước tối đa', 22000, 120, 15),
(4, 2, 'Viên nhai trị ve rận NexGard (Chó 2 - 4kg)', 'Bảo vệ toàn diện diệt sạch bọ chét và ve rận trong 30 ngày', 145000, 60, 10),
(5, 2, 'Thuốc nhỏ gáy trị rận mèo Revolution Plus', 'Phòng ngừa giun tim, ve, rận và ký sinh trùng tai', 185000, 50, 8),
(6, 2, 'Men tiêu hóa vi sinh Bioline L-Pet (Gói 5g)', 'Cân bằng hệ vi sinh đường ruột chống tiêu chảy ói mửa', 15000, 200, 20),
(7, 3, 'Sữa tắm khử mùi SOS Trắng lông 530ml', 'Chiết xuất thảo dược giữ hương thơm lâu dài 7 ngày', 125000, 30, 5),
(8, 3, 'Cát vệ sinh đậu nành Cature Tofu 6L', 'Vón nhanh, xả trực tiếp bồn cầu, an toàn cho mèo con', 135000, 85, 10);

SET FOREIGN_KEY_CHECKS = 1;
