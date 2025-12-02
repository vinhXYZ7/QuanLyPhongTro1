-- =====================================================================
-- HỆ THỐNG QUẢN LÝ PHÒNG TRỌ BOA - KỊCH BẢN HOÀN CHỈNH
-- Mục đích: Tạo database, các bảng, định nghĩa khóa ngoại,
--           và chèn dữ liệu mẫu (đã hoàn thiện phần bị thiếu).
-- =====================================================================

-- Bước 1: Thiết lập môi trường và dọn dẹp (Chạy lần đầu)
-- ---------------------------------------------------------------------

CREATE DATABASE IF NOT EXISTS QuanLyPhongTro;
USE QuanLyPhongTro;

-- Tắt kiểm tra khóa ngoại để dọn dẹp các bảng theo đúng thứ tự (từ con lên cha)
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Payment;
DROP TABLE IF EXISTS Room_Service;
DROP TABLE IF EXISTS Contract;
DROP TABLE IF EXISTS Staff;
DROP TABLE IF EXISTS Tenant;
DROP TABLE IF EXISTS Room;
DROP TABLE IF EXISTS Service;
DROP TABLE IF EXISTS Role;
DROP TABLE IF EXISTS users;

-- ⚠️ Khóa ngoại sẽ được bật lại ở cuối script sau khi tạo xong.

-- =====================================================================
-- BƯỚC 2: TẠO CÁC BẢNG (Đã tích hợp cột user_id cho multi-tenancy)
-- =====================================================================

-- Bảng 1: users (Tài khoản quản lý/chủ nhà)
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100),
    role VARCHAR(20) DEFAULT 'manager',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bảng 2: Role (Phân quyền nội bộ)
CREATE TABLE Role (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE
);

-- Bảng 3: Staff (Nhân viên quản lý)
CREATE TABLE Staff (
    staff_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(15),
    email VARCHAR(100),
    position VARCHAR(50),
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role_id INT DEFAULT 2,
    status VARCHAR(20) DEFAULT 'Active',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES Role(role_id)
);

-- Bảng 4: Service (Dịch vụ - Chung cho mọi quản lý)
CREATE TABLE Service (
    service_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    unit VARCHAR(50),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Bảng 5: Room (Phòng trọ) - Liên kết với users
CREATE TABLE Room (
    room_id INT AUTO_INCREMENT PRIMARY KEY,
    room_number VARCHAR(10) NOT NULL,
    type VARCHAR(50),
    price DECIMAL(10,2),
    status VARCHAR(20) DEFAULT 'Trống', -- Trống, Đang thuê, Bảo trì
    floor INT,
    description VARCHAR(255),
    user_id INT NOT NULL, -- Khóa ngoại liên kết với Bảng users
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Bảng 6: Tenant (Khách thuê) - Liên kết với users
CREATE TABLE Tenant (
    tenant_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(15),
    email VARCHAR(100),
    id_card VARCHAR(20),
    address VARCHAR(255),
    user_id INT NOT NULL, -- Khóa ngoại liên kết với Bảng users
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Bảng 7: Contract (Hợp đồng thuê) - Liên kết với users
CREATE TABLE Contract (
    contract_id INT AUTO_INCREMENT PRIMARY KEY,
    tenant_id INT NOT NULL,
    room_id INT NOT NULL,
    staff_id INT,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'Đang thuê', -- Đang thuê, Đã kết thúc, Hủy
    deposit_amount DECIMAL(10,2) DEFAULT 0,
    user_id INT NOT NULL, -- Khóa ngoại liên kết với Bảng users
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Bảng 8: Payment (Thanh toán)
CREATE TABLE Payment (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    contract_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_date DATE NOT NULL,
    method VARCHAR(50), -- Tiền mặt, Chuyển khoản
    description VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Bảng 9: Room_Service (Liên kết phòng và dịch vụ)
CREATE TABLE Room_Service (
    room_id INT NOT NULL,
    service_id INT NOT NULL,
    PRIMARY KEY (room_id, service_id)
);


-- =====================================================================
-- BƯỚC 3: ĐỊNH NGHĨA KHÓA NGOẠI VÀ RÀNG BUỘC
-- =====================================================================

-- Khóa ngoại từ Contract
ALTER TABLE Contract ADD CONSTRAINT fk_contract_tenant 
    FOREIGN KEY (tenant_id) REFERENCES Tenant(tenant_id) ON DELETE CASCADE;
ALTER TABLE Contract ADD CONSTRAINT fk_contract_room 
    FOREIGN KEY (room_id) REFERENCES Room(room_id) ON DELETE CASCADE;
ALTER TABLE Contract ADD CONSTRAINT fk_contract_staff 
    FOREIGN KEY (staff_id) REFERENCES Staff(staff_id);

-- Khóa ngoại từ Payment
ALTER TABLE Payment ADD CONSTRAINT fk_payment_contract 
    FOREIGN KEY (contract_id) REFERENCES Contract(contract_id) ON DELETE CASCADE;

-- Khóa ngoại từ Room_Service
ALTER TABLE Room_Service ADD CONSTRAINT fk_rs_room 
    FOREIGN KEY (room_id) REFERENCES Room(room_id) ON DELETE CASCADE;
ALTER TABLE Room_Service ADD CONSTRAINT fk_rs_service 
    FOREIGN KEY (service_id) REFERENCES Service(service_id) ON DELETE CASCADE;

-- Khóa ngoại Multi-Tenant (user_id)
ALTER TABLE Room ADD CONSTRAINT fk_room_user 
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;
ALTER TABLE Tenant ADD CONSTRAINT fk_tenant_user 
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;
ALTER TABLE Contract ADD CONSTRAINT fk_contract_user 
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

-- Ràng buộc duy nhất (Mỗi phòng chỉ duy nhất trong phạm vi người dùng đó quản lý)
ALTER TABLE Room ADD CONSTRAINT UQ_Room_User UNIQUE (room_number, user_id);

-- =====================================================================
-- BƯỚC 4: CHÈN DỮ LIỆU MẪU
-- =====================================================================

-- 1. TÀI KHOẢN NGƯỜI DÙNG (3 tài khoản: 1 admin, 2 manager)
INSERT INTO users (id, username, password, full_name, role) VALUES
(1, 'admin', 'admin', 'Quản Trị Viên Hệ Thống', 'admin'),
(2, 'manager1', '123456', 'Nguyễn Văn Quản Lý', 'manager'),
(3, 'manager2', '123456', 'Trần Thị Chủ Nhà', 'manager');

-- 2. ROLE VÀ SERVICE (Dữ liệu chung)
INSERT INTO Role (role_id, role_name) VALUES 
(1, 'Admin'), 
(2, 'Staff');

INSERT INTO Service (service_id, name, price, unit) VALUES
(1, 'Điện', 3500, 'kWh'),
(2, 'Nước', 20000, 'm³'),
(3, 'Internet', 150000, 'tháng'),
(4, 'Vệ sinh', 50000, 'tháng'),
(5, 'Bảo vệ', 100000, 'tháng'),
(6, 'Gửi xe', 50000, 'tháng');

-- 3. STAFF (Nhân viên)
INSERT INTO Staff (staff_id, name, phone, email, position, username, password, role_id, status) VALUES
(1, 'Admin Hệ Thống', '0900000000', 'admin@boa.vn', 'Quản lý cấp cao', 'admin_staff', 'admin123', 1, 'Active'),
(2, 'Nguyễn Thị Lan', '0901111111', 'lan.nguyen@boa.vn', 'Nhân viên quản lý', 'nv_lan', '123456', 2, 'Active'),
(3, 'Trần Văn Minh', '0902222222', 'minh.tran@boa.vn', 'Nhân viên kế toán', 'nv_minh', '123456', 2, 'Active');

-- ---------------------------------------------------------------------
-- DỮ LIỆU CHO ADMIN (user_id = 1)
-- ---------------------------------------------------------------------

-- PHÒNG CỦA ADMIN (20 phòng)
INSERT INTO Room (room_id, room_number, type, price, status, floor, description, user_id) VALUES
-- Tầng 1 (6 phòng)
(1, 'A101', 'Phòng Thường', 2500000, 'Đang thuê', 1, 'Phòng 20m², có WC riêng', 1),
(2, 'A102', 'Phòng Thường', 2500000, 'Đang thuê', 1, 'Phòng 20m², có ban công', 1),
(3, 'A103', 'Phòng Thường', 2500000, 'Trống', 1, 'Phòng 20m², view đẹp', 1),
(4, 'A104', 'Phòng VIP', 3500000, 'Đang thuê', 1, 'Phòng 30m², full nội thất', 1),
(5, 'A105', 'Phòng VIP', 3500000, 'Trống', 1, 'Phòng 30m², điều hòa 2 chiều', 1),
(6, 'A106', 'Căn Hộ', 5000000, 'Đang thuê', 1, 'Căn hộ 50m², bếp riêng', 1),

-- Tầng 2 (7 phòng)
(7, 'A201', 'Phòng Thường', 2700000, 'Đang thuê', 2, 'Phòng 22m², thoáng mát', 1),
(8, 'A202', 'Phòng Thường', 2700000, 'Đang thuê', 2, 'Phòng 22m², yên tĩnh', 1),
(9, 'A203', 'Phòng Thường', 2700000, 'Trống', 2, 'Phòng 22m², view sân vườn', 1),
(10, 'A204', 'Phòng VIP', 3800000, 'Đang thuê', 2, 'Phòng 32m², gác lửng', 1),
(11, 'A205', 'Phòng VIP', 3800000, 'Trống', 2, 'Phòng 32m², nội thất cao cấp', 1),
(12, 'A206', 'Căn Hộ', 5500000, 'Đang thuê', 2, 'Căn hộ 55m², 2 phòng ngủ', 1),
(13, 'A207', 'Căn Hộ', 5500000, 'Trống', 2, 'Căn hộ 55m², ban công rộng', 1),

-- Tầng 3 (7 phòng)
(14, 'A301', 'Phòng Thường', 2900000, 'Đang thuê', 3, 'Phòng 25m², tầng cao thoáng', 1),
(15, 'A302', 'Phòng Thường', 2900000, 'Trống', 3, 'Phòng 25m², ánh sáng tốt', 1),
(16, 'A303', 'Phòng VIP', 4000000, 'Đang thuê', 3, 'Phòng 35m², studio', 1),
(17, 'A304', 'Phòng VIP', 4000000, 'Trống', 3, 'Phòng 35m², view thành phố', 1),
(18, 'A305', 'Căn Hộ', 6000000, 'Đang thuê', 3, 'Penthouse 60m², sân thượng riêng', 1),
(19, 'A306', 'Phòng Thường', 2900000, 'Bảo trì', 3, 'Đang sửa chữa điện nước', 1),
(20, 'A307', 'Phòng VIP', 4000000, 'Trống', 3, 'Phòng 35m², mới hoàn thiện', 1);

-- KHÁCH THUÊ CỦA ADMIN (15 người)
INSERT INTO Tenant (tenant_id, name, phone, email, id_card, address, user_id) VALUES
(1, 'Nguyễn Văn An', '0912345001', 'nva@gmail.com', '001234567890', '123 Lê Lợi, Q1, TP.HCM', 1),
(2, 'Trần Thị Bình', '0912345002', 'ttb@gmail.com', '001234567891', '456 Nguyễn Huệ, Q1, TP.HCM', 1),
(3, 'Lê Văn Cường', '0912345003', 'lvc@gmail.com', '001234567892', '789 Điện Biên Phủ, Q3, TP.HCM', 1),
(4, 'Phạm Thị Dung', '0912345004', 'ptd@gmail.com', '001234567893', '321 Hai Bà Trưng, Q1, TP.HCM', 1),
(5, 'Hoàng Văn Em', '0912345005', 'hve@gmail.com', '001234567894', '654 Lý Thường Kiệt, Q10, TP.HCM', 1),
(6, 'Đỗ Thị Phương', '0912345006', 'dtp@gmail.com', '001234567895', '987 Trần Hưng Đạo, Q5, TP.HCM', 1),
(7, 'Vũ Văn Giang', '0912345007', 'vvg@gmail.com', '001234567896', '147 Võ Văn Tần, Q3, TP.HCM', 1),
(8, 'Bùi Thị Hoa', '0912345008', 'bth@gmail.com', '001234567897', '258 Cách Mạng Tháng 8, Q10, TP.HCM', 1),
(9, 'Ngô Văn Ích', '0912345009', 'nvi@gmail.com', '001234567898', '369 Lê Văn Sỹ, Q3, TP.HCM', 1),
(10, 'Đinh Thị Kim', '0912345010', 'dtk@gmail.com', '001234567899', '741 Pasteur, Q1, TP.HCM', 1),
(11, 'Mai Văn Long', '0912345011', 'mvl@gmail.com', '001234567900', '852 Nam Kỳ Khởi Nghĩa, Q3, TP.HCM', 1),
(12, 'Trương Thị Mai', '0912345012', 'ttm@gmail.com', '001234567901', '963 Nguyễn Thị Minh Khai, Q1, TP.HCM', 1),
(13, 'Phan Văn Nam', '0912345013', 'pvn@gmail.com', '001234567902', '159 Phan Xích Long, Q. Phú Nhuận, TP.HCM', 1),
(14, 'Lý Thị Oanh', '0912345014', 'lto@gmail.com', '001234567903', '357 Hoàng Văn Thụ, Q. Tân Bình, TP.HCM', 1),
(15, 'Tạ Văn Phúc', '0912345015', 'tvp@gmail.com', '001234567904', '486 Cộng Hòa, Q. Tân Bình, TP.HCM', 1);

-- HỢP ĐỒNG CỦA ADMIN (12 hợp đồng)
INSERT INTO Contract (contract_id, tenant_id, room_id, staff_id, start_date, end_date, status, deposit_amount, user_id) VALUES
(1, 1, 1, 2, '2024-01-01', '2024-12-31', 'Đang thuê', 2500000, 1), -- A101
(2, 2, 2, 2, '2024-01-15', '2024-12-31', 'Đang thuê', 2500000, 1), -- A102
(3, 3, 4, 2, '2024-02-01', '2025-01-31', 'Đang thuê', 3500000, 1), -- A104
(4, 4, 6, 2, '2024-02-15', '2025-02-14', 'Đang thuê', 5000000, 1), -- A106
(5, 5, 7, 2, '2024-03-01', '2025-02-28', 'Đang thuê', 2700000, 1), -- A201
(6, 6, 8, 2, '2024-03-15', '2025-03-14', 'Đang thuê', 2700000, 1), -- A202
(7, 7, 10, 3, '2024-04-01', '2025-03-31', 'Đang thuê', 3800000, 1), -- A204
(8, 8, 12, 3, '2024-04-15', '2025-04-14', 'Đang thuê', 5500000, 1), -- A206
(9, 9, 14, 3, '2024-05-01', '2025-04-30', 'Đang thuê', 2900000, 1), -- A301
(10, 10, 16, 3, '2024-05-15', '2025-05-14', 'Đang thuê', 4000000, 1), -- A303
(11, 11, 18, 3, '2024-06-01', '2025-05-31', 'Đang thuê', 6000000, 1), -- A305
(12, 12, 1, 2, '2023-01-01', '2023-12-31', 'Đã kết thúc', 2500000, 1); -- Hợp đồng cũ (Phòng A101)

-- THANH TOÁN CỦA ADMIN (Hoàn thiện dữ liệu 11 hợp đồng đang hoạt động)
INSERT INTO Payment (contract_id, amount, payment_date, method, description) VALUES
-- Hợp đồng 1 (A101 - 2.5tr) - 12 tháng (Jan-Dec 2024) + Cọc
(1, 2500000, '2024-01-01', 'Chuyển khoản', 'Tiền cọc A101'),
(1, 2500000, '2024-02-01', 'Chuyển khoản', 'Tiền thuê tháng 2/2024'),
(1, 2500000, '2024-03-01', 'Tiền mặt', 'Tiền thuê tháng 3/2024'),
(1, 2500000, '2024-04-01', 'Chuyển khoản', 'Tiền thuê tháng 4/2024'),
(1, 2500000, '2024-05-01', 'Chuyển khoản', 'Tiền thuê tháng 5/2024'),
(1, 2500000, '2024-06-01', 'Chuyển khoản', 'Tiền thuê tháng 6/2024'),
(1, 2500000, '2024-07-01', 'Tiền mặt', 'Tiền thuê tháng 7/2024'),
(1, 2500000, '2024-08-01', 'Chuyển khoản', 'Tiền thuê tháng 8/2024'),
(1, 2500000, '2024-09-01', 'Chuyển khoản', 'Tiền thuê tháng 9/2024'),
(1, 2500000, '2024-10-01', 'Chuyển khoản', 'Tiền thuê tháng 10/2024'),
(1, 2500000, '2024-11-01', 'Chuyển khoản', 'Tiền thuê tháng 11/2024'),
(1, 2500000, '2024-12-01', 'Chuyển khoản', 'Tiền thuê tháng 12/2024'),

-- Hợp đồng 2 (A102 - 2.5tr) - 11 tháng (Feb-Dec 2024) + Cọc
(2, 2500000, '2024-01-15', 'Tiền mặt', 'Tiền cọc A102'),
(2, 2500000, '2024-02-15', 'Chuyển khoản', 'Tiền thuê tháng 2/2024'),
(2, 2500000, '2024-03-15', 'Chuyển khoản', 'Tiền thuê tháng 3/2024'),
(2, 2500000, '2024-04-15', 'Tiền mặt', 'Tiền thuê tháng 4/2024'),
(2, 2500000, '2024-05-15', 'Chuyển khoản', 'Tiền thuê tháng 5/2024'),
(2, 2500000, '2024-06-15', 'Chuyển khoản', 'Tiền thuê tháng 6/2024'),
(2, 2500000, '2024-07-15', 'Chuyển khoản', 'Tiền thuê tháng 7/2024'),
(2, 2500000, '2024-08-15', 'Tiền mặt', 'Tiền thuê tháng 8/2024'),
(2, 2500000, '2024-09-15', 'Chuyển khoản', 'Tiền thuê tháng 9/2024'),
(2, 2500000, '2024-10-15', 'Chuyển khoản', 'Tiền thuê tháng 10/2024'),
(2, 2500000, '2024-11-15', 'Chuyển khoản', 'Tiền thuê tháng 11/2024'),
(2, 2500000, '2024-12-15', 'Tiền mặt', 'Tiền thuê tháng 12/2024'),

-- Hợp đồng 3 (A104 - 3.5tr) - 10 tháng (Mar-Dec 2024) + Cọc
(3, 3500000, '2024-02-01', 'Chuyển khoản', 'Tiền cọc A104'),
(3, 3500000, '2024-03-01', 'Chuyển khoản', 'Tiền thuê tháng 3/2024'),
(3, 3500000, '2024-04-01', 'Tiền mặt', 'Tiền thuê tháng 4/2024'),
(3, 3500000, '2024-05-01', 'Chuyển khoản', 'Tiền thuê tháng 5/2024'),
(3, 3500000, '2024-06-01', 'Chuyển khoản', 'Tiền thuê tháng 6/2024'),
(3, 3500000, '2024-07-01', 'Chuyển khoản', 'Tiền thuê tháng 7/2024'),
(3, 3500000, '2024-08-01', 'Chuyển khoản', 'Tiền thuê tháng 8/2024'),
(3, 3500000, '2024-09-01', 'Tiền mặt', 'Tiền thuê tháng 9/2024'),
(3, 3500000, '2024-10-01', 'Chuyển khoản', 'Tiền thuê tháng 10/2024'),
(3, 3500000, '2024-11-01', 'Chuyển khoản', 'Tiền thuê tháng 11/2024'),
(3, 3500000, '2024-12-01', 'Tiền mặt', 'Tiền thuê tháng 12/2024'),

-- Hợp đồng 4 (A106 - 5tr) - 10 tháng (Mar-Dec 2024) + Cọc
(4, 5000000, '2024-02-15', 'Chuyển khoản', 'Tiền cọc A106'),
(4, 5000000, '2024-03-15', 'Chuyển khoản', 'Tiền thuê tháng 3/2024'),
(4, 5000000, '2024-04-15', 'Chuyển khoản', 'Tiền thuê tháng 4/2024'),
(4, 5000000, '2024-05-15', 'Tiền mặt', 'Tiền thuê tháng 5/2024'),
(4, 5000000, '2024-06-15', 'Chuyển khoản', 'Tiền thuê tháng 6/2024'),
(4, 5000000, '2024-07-15', 'Chuyển khoản', 'Tiền thuê tháng 7/2024'),
(4, 5000000, '2024-08-15', 'Chuyển khoản', 'Tiền thuê tháng 8/2024'),
(4, 5000000, '2024-09-15', 'Chuyển khoản', 'Tiền thuê tháng 9/2024'),
(4, 5000000, '2024-10-15', 'Tiền mặt', 'Tiền thuê tháng 10/2024'),
(4, 5000000, '2024-11-15', 'Chuyển khoản', 'Tiền thuê tháng 11/2024'),
(4, 5000000, '2024-12-15', 'Chuyển khoản', 'Tiền thuê tháng 12/2024'),

-- Hợp đồng 5 (A201 - 2.7tr) - 9 tháng (Apr-Dec 2024) + Cọc
(5, 2700000, '2024-03-01', 'Chuyển khoản', 'Tiền cọc A201'),
(5, 2700000, '2024-04-01', 'Chuyển khoản', 'Tiền thuê tháng 4/2024'),
(5, 2700000, '2024-05-01', 'Tiền mặt', 'Tiền thuê tháng 5/2024'),
(5, 2700000, '2024-06-01', 'Chuyển khoản', 'Tiền thuê tháng 6/2024'),
(5, 2700000, '2024-07-01', 'Chuyển khoản', 'Tiền thuê tháng 7/2024'),
(5, 2700000, '2024-08-01', 'Chuyển khoản', 'Tiền thuê tháng 8/2024'),
(5, 2700000, '2024-09-01', 'Tiền mặt', 'Tiền thuê tháng 9/2024'),
(5, 2700000, '2024-10-01', 'Chuyển khoản', 'Tiền thuê tháng 10/2024'),
(5, 2700000, '2024-11-01', 'Chuyển khoản', 'Tiền thuê tháng 11/2024'),
(5, 2700000, '2024-12-01', 'Chuyển khoản', 'Tiền thuê tháng 12/2024'),

-- Hợp đồng 6 (A202 - 2.7tr) - 9 tháng (Apr-Dec 2024) + Cọc
(6, 2700000, '2024-03-15', 'Tiền mặt', 'Tiền cọc A202'),
(6, 2700000, '2024-04-15', 'Chuyển khoản', 'Tiền thuê tháng 4/2024'),
(6, 2700000, '2024-05-15', 'Chuyển khoản', 'Tiền thuê tháng 5/2024'),
(6, 2700000, '2024-06-15', 'Tiền mặt', 'Tiền thuê tháng 6/2024'),
(6, 2700000, '2024-07-15', 'Chuyển khoản', 'Tiền thuê tháng 7/2024'),
(6, 2700000, '2024-08-15', 'Chuyển khoản', 'Tiền thuê tháng 8/2024'),
(6, 2700000, '2024-09-15', 'Chuyển khoản', 'Tiền thuê tháng 9/2024'),
(6, 2700000, '2024-10-15', 'Tiền mặt', 'Tiền thuê tháng 10/2024'),
(6, 2700000, '2024-11-15', 'Chuyển khoản', 'Tiền thuê tháng 11/2024'),
(6, 2700000, '2024-12-15', 'Tiền mặt', 'Tiền thuê tháng 12/2024'),

-- Hợp đồng 7 (A204 - 3.8tr) - 8 tháng (May-Dec 2024) + Cọc
(7, 3800000, '2024-04-01', 'Chuyển khoản', 'Tiền cọc A204'),
(7, 3800000, '2024-05-01', 'Chuyển khoản', 'Tiền thuê tháng 5/2024'),
(7, 3800000, '2024-06-01', 'Tiền mặt', 'Tiền thuê tháng 6/2024'),
(7, 3800000, '2024-07-01', 'Chuyển khoản', 'Tiền thuê tháng 7/2024'),
(7, 3800000, '2024-08-01', 'Chuyển khoản', 'Tiền thuê tháng 8/2024'),
(7, 3800000, '2024-09-01', 'Chuyển khoản', 'Tiền thuê tháng 9/2024'),
(7, 3800000, '2024-10-01', 'Tiền mặt', 'Tiền thuê tháng 10/2024'),
(7, 3800000, '2024-11-01', 'Chuyển khoản', 'Tiền thuê tháng 11/2024'),
(7, 3800000, '2024-12-01', 'Chuyển khoản', 'Tiền thuê tháng 12/2024'),

-- Hợp đồng 8 (A206 - 5.5tr) - 8 tháng (May-Dec 2024) + Cọc
(8, 5500000, '2024-04-15', 'Chuyển khoản', 'Tiền cọc A206'),
(8, 5500000, '2024-05-15', 'Tiền mặt', 'Tiền thuê tháng 5/2024'),
(8, 5500000, '2024-06-15', 'Chuyển khoản', 'Tiền thuê tháng 6/2024'),
(8, 5500000, '2024-07-15', 'Chuyển khoản', 'Tiền thuê tháng 7/2024'),
(8, 5500000, '2024-08-15', 'Tiền mặt', 'Tiền thuê tháng 8/2024'),
(8, 5500000, '2024-09-15', 'Chuyển khoản', 'Tiền thuê tháng 9/2024'),
(8, 5500000, '2024-10-15', 'Chuyển khoản', 'Tiền thuê tháng 10/2024'),
(8, 5500000, '2024-11-15', 'Tiền mặt', 'Tiền thuê tháng 11/2024'),
(8, 5500000, '2024-12-15', 'Chuyển khoản', 'Tiền thuê tháng 12/2024'),

-- Hợp đồng 9 (A301 - 2.9tr) - 7 tháng (Jun-Dec 2024) + Cọc
(9, 2900000, '2024-05-01', 'Chuyển khoản', 'Tiền cọc A301'),
(9, 2900000, '2024-06-01', 'Chuyển khoản', 'Tiền thuê tháng 6/2024'),
(9, 2900000, '2024-07-01', 'Tiền mặt', 'Tiền thuê tháng 7/2024'),
(9, 2900000, '2024-08-01', 'Chuyển khoản', 'Tiền thuê tháng 8/2024'),
(9, 2900000, '2024-09-01', 'Chuyển khoản', 'Tiền thuê tháng 9/2024'),
(9, 2900000, '2024-10-01', 'Tiền mặt', 'Tiền thuê tháng 10/2024'),
(9, 2900000, '2024-11-01', 'Chuyển khoản', 'Tiền thuê tháng 11/2024'),
(9, 2900000, '2024-12-01', 'Chuyển khoản', 'Tiền thuê tháng 12/2024'),

-- Hợp đồng 10 (A303 - 4.0tr) - 7 tháng (Jun-Dec 2024) + Cọc
(10, 4000000, '2024-05-15', 'Tiền mặt', 'Tiền cọc A303'),
(10, 4000000, '2024-06-15', 'Chuyển khoản', 'Tiền thuê tháng 6/2024'),
(10, 4000000, '2024-07-15', 'Chuyển khoản', 'Tiền thuê tháng 7/2024'),
(10, 4000000, '2024-08-15', 'Tiền mặt', 'Tiền thuê tháng 8/2024'),
(10, 4000000, '2024-09-15', 'Chuyển khoản', 'Tiền thuê tháng 9/2024'),
(10, 4000000, '2024-10-15', 'Chuyển khoản', 'Tiền thuê tháng 10/2024'),
(10, 4000000, '2024-11-15', 'Tiền mặt', 'Tiền thuê tháng 11/2024'),
(10, 4000000, '2024-12-15', 'Chuyển khoản', 'Tiền thuê tháng 12/2024'),

-- Hợp đồng 11 (A305 - 6.0tr) - 6 tháng (Jul-Dec 2024) + Cọc
(11, 6000000, '2024-06-01', 'Chuyển khoản', 'Tiền cọc A305'),
(11, 6000000, '2024-07-01', 'Chuyển khoản', 'Tiền thuê tháng 7/2024'),
(11, 6000000, '2024-08-01', 'Tiền mặt', 'Tiền thuê tháng 8/2024'),
(11, 6000000, '2024-09-01', 'Chuyển khoản', 'Tiền thuê tháng 9/2024'),
(11, 6000000, '2024-10-01', 'Chuyển khoản', 'Tiền thuê tháng 10/2024'),
(11, 6000000, '2024-11-01', 'Tiền mặt', 'Tiền thuê tháng 11/2024'),
(11, 6000000, '2024-12-01', 'Chuyển khoản', 'Tiền thuê tháng 12/2024'),

-- Hợp đồng 12 (Đã kết thúc) - Dữ liệu cũ
(12, 2500000, '2023-01-01', 'Chuyển khoản', 'Tiền cọc HD cũ A101'),
(12, 2500000, '2023-12-01', 'Tiền mặt', 'Tiền thuê cuối cùng HD cũ A101');


-- LIÊN KẾT DỊCH VỤ VÀ PHÒNG
-- Phòng Thường (A101, A102, A201, A202, A301) - Điện, Nước, Internet, Vệ sinh
INSERT INTO Room_Service (room_id, service_id) VALUES
(1, 1), (1, 2), (1, 3), (1, 4), -- A101
(2, 1), (2, 2), (2, 3), (2, 4), -- A102
(7, 1), (7, 2), (7, 3), (7, 4), -- A201
(8, 1), (8, 2), (8, 3), (8, 4), -- A202
(14, 1), (14, 2), (14, 3), (14, 4); -- A301

-- Phòng VIP/Căn Hộ (A104, A106, A204, A206, A303, A305) - Full Service (có thêm Bảo vệ, Gửi xe)
INSERT INTO Room_Service (room_id, service_id) VALUES
(4, 1), (4, 2), (4, 3), (4, 4), (4, 5), (4, 6), -- A104
(6, 1), (6, 2), (6, 3), (6, 4), (6, 5), (6, 6), -- A106
(10, 1), (10, 2), (10, 3), (10, 4), (10, 5), (10, 6), -- A204
(12, 1), (12, 2), (12, 3), (12, 4), (12, 5), (12, 6), -- A206
(16, 1), (16, 2), (16, 3), (16, 4), (16, 5), (16, 6), -- A303
(18, 1), (18, 2), (18, 3), (18, 4), (18, 5), (18, 6); -- A305

-- =====================================================================
-- BƯỚC 5: KẾT THÚC
-- =====================================================================

-- Bật lại kiểm tra khóa ngoại (nên giữ ở cuối cùng)
SET FOREIGN_KEY_CHECKS = 1;