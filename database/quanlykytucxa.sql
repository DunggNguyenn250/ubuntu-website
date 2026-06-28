-- 1. TÀI KHOẢN ADMIN (đăng nhập: admin / admin123)
INSERT INTO taikhoan_admin (username, password) VALUES
('admin',  'admin123'),
('quantri', 'quantri123');

-- 2. PHÒNG KÝ TÚC XÁ (Tòa A: Nam | Tòa B: Nữ)
INSERT INTO phong (maphong, sophong, toa, succhua, phonghientai, gia, trangthai) VALUES
('A101', '101', 'A', 8, 6, 500000, 'Còn chỗ'),
('A102', '102', 'A', 8, 8, 500000, 'Hết chỗ'),
('A103', '103', 'A', 8, 3, 500000, 'Còn chỗ'),
('A201', '201', 'A', 8, 0, 600000, 'Còn chỗ'),
('A202', '202', 'A', 8, 7, 600000, 'Còn chỗ'),
('B101', '101', 'B', 8, 5, 500000, 'Còn chỗ'),
('B102', '102', 'B', 8, 8, 500000, 'Hết chỗ'),
('B103', '103', 'B', 8, 2, 500000, 'Còn chỗ'),
('B201', '201', 'B', 8, 4, 600000, 'Còn chỗ'),
('B202', '202', 'B', 8, 6, 600000, 'Còn chỗ');

-- 3. SINH VIÊN MẪU
INSERT INTO sinhvien (masv, hoten, lop, gioitinh, cccd, sodienthoai, email, diachi) VALUES
('74DCTT001', 'Nguyễn Văn An',    '74DCTT01', 'Nam', '001234567890', '0912345678', 'nguyenvanan@email.com',  'Hà Nội'),
('74DCTT002', 'Trần Thị Bình',    '74DCTT01', 'Nữ',  '001234567891', '0912345679', 'tranthihinh@email.com',  'Bắc Giang'),
('74DCTT003', 'Lê Văn Cường',     '74DCTT02', 'Nam', '001234567892', '0912345680', 'levancuong@email.com',   'Hải Phòng'),
('74DCTT004', 'Phạm Thị Dung',    '74DCTT02', 'Nữ',  '001234567893', '0912345681', 'phamthidung@email.com',  'Nam Định'),
('74DCTT005', 'Hoàng Văn Em',     '74DCTT03', 'Nam', '001234567894', '0912345682', 'hoangvanem@email.com',   'Thái Bình'),
('74DCTT006', 'Vũ Thị Phương',    '74DCTT03', 'Nữ',  '001234567895', '0912345683', 'vuthiphuong@email.com',  'Ninh Bình'),
('74DCTT007', 'Đặng Văn Giang',   '74DCTT04', 'Nam', '001234567896', '0912345684', 'dangvangiang@email.com', 'Hưng Yên'),
('74DCTT008', 'Bùi Thị Hoa',      '74DCTT04', 'Nữ',  '001234567897', '0912345685', 'buithihoa@email.com',    'Vĩnh Phúc');

-- 4. TÀI KHOẢN SINH VIÊN (mật khẩu mặc định: 123456)
INSERT INTO taikhoan_user (masv, password) VALUES
('74DCTT001', '123456'),
('74DCTT002', '123456'),
('74DCTT003', '123456'),
('74DCTT004', '123456'),
('74DCTT005', '123456'),
('74DCTT006', '123456'),
('74DCTT007', '123456'),
('74DCTT008', '123456');

-- 5. HỢP ĐỒNG
INSERT INTO hopdong (mahopdong, masv, maphong, batdau, hethan, trangthai) VALUES
('HD001', '74DCTT001', 'A101', '2025-09-01', '2026-06-30', 'Còn hiệu lực'),
('HD002', '74DCTT003', 'A101', '2025-09-01', '2026-06-30', 'Còn hiệu lực'),
('HD003', '74DCTT005', 'A103', '2025-09-01', '2026-06-30', 'Còn hiệu lực'),
('HD004', '74DCTT007', 'A202', '2025-09-01', '2026-06-30', 'Còn hiệu lực'),
('HD005', '74DCTT002', 'B101', '2025-09-01', '2026-06-30', 'Còn hiệu lực'),
('HD006', '74DCTT004', 'B101', '2025-09-01', '2026-06-30', 'Còn hiệu lực'),
('HD007', '74DCTT006', 'B201', '2025-09-01', '2026-06-30', 'Còn hiệu lực'),
('HD008', '74DCTT008', 'B201', '2025-09-01', '2026-06-30', 'Còn hiệu lực');

-- 6. THANH TOÁN
INSERT INTO thanhtoan (maphong, sotien, ngaytra, trangthai) VALUES
('A101', 500000, '2026-01-05', 'Đã thanh toán'),
('A101', 500000, '2026-02-05', 'Đã thanh toán'),
('A101', 500000, '2026-03-05', 'Đã thanh toán'),
('A103', 500000, '2026-01-05', 'Đã thanh toán'),
('A103', 500000, '2026-02-05', 'Đã thanh toán'),
('A103', 500000, '2026-03-06', 'Trễ hạn'),
('B101', 500000, '2026-01-04', 'Đã thanh toán'),
('B101', 500000, '2026-02-04', 'Đã thanh toán'),
('A202', 600000, '2026-01-03', 'Đã thanh toán'),
('A202', 600000, '2026-02-10', 'Trễ hạn'),
('B201', 600000, '2026-01-05', 'Đã thanh toán'),
('B201', 600000, '2026-02-05', 'Đã thanh toán');

-- 7. SỰ CỐ
INSERT INTO suco (maphong, mota, ngaybao, trangthai) VALUES
('A101', 'Bóng đèn phòng tắm bị cháy, cần thay mới',      '2026-05-10', 'Đã xử lý'),
('A103', 'Vòi nước bị rò rỉ, chảy nước liên tục',          '2026-05-15', 'Đang xử lý'),
('B101', 'Quạt trần bị hỏng, không chạy được',             '2026-05-20', 'Chờ xử lý'),
('B201', 'Cửa phòng bị hỏng khóa, không đóng được',        '2026-06-01', 'Đã xử lý'),
('A202', 'Điều hoà không lạnh, cần kiểm tra gas',          '2026-06-05', 'Đang xử lý'),
('B103', 'Tường bị ẩm mốc sau mưa lớn',                    '2026-06-10', 'Chờ xử lý');