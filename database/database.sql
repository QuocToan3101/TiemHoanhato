-- =====================================================
-- FLOWERSTORE DATABASE INITIALIZATION
-- File gộp tất cả các script SQL cần thiết
-- Chạy file này để khởi tạo database hoàn chỉnh
-- =====================================================

-- =====================================================
-- PHẦN 1: TẠO DATABASE VÀ CÁC BẢNG
-- =====================================================

CREATE DATABASE IF NOT EXISTS flowerstore 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE flowerstore;

-- Bảng Users (với email verification)
DROP TABLE IF EXISTS users;
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    fullname VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    avatar VARCHAR(500),
    bio TEXT,
    gender ENUM('Nam', 'Nữ', 'Khác'),
    birthday DATE,
    role ENUM('customer', 'admin') DEFAULT 'customer',
    status ENUM('pending', 'active', 'inactive', 'banned') DEFAULT 'active',
    verification_token VARCHAR(255) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_verification_token (verification_token)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng Categories
DROP TABLE IF EXISTS categories;
CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    slug VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    image VARCHAR(500),
    parent_id INT DEFAULT NULL,
    display_order INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng Products
DROP TABLE IF EXISTS products;
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    short_description VARCHAR(500),
    price DECIMAL(15, 0) NOT NULL,
    sale_price DECIMAL(15, 0),
    quantity INT DEFAULT 0,
    image VARCHAR(500),
    images TEXT,
    is_featured BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    view_count INT DEFAULT 0,
    sold_count INT DEFAULT 0,
    average_rating DECIMAL(3,2) DEFAULT 0.00,
    review_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng Addresses
DROP TABLE IF EXISTS addresses;
CREATE TABLE addresses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    receiver_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    province VARCHAR(100),
    district VARCHAR(100),
    ward VARCHAR(100),
    address_detail VARCHAR(255) NOT NULL,
    note TEXT,
    is_default BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng Orders
DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_code VARCHAR(50) NOT NULL UNIQUE,
    user_id INT,
    receiver_name VARCHAR(100) NOT NULL,
    receiver_phone VARCHAR(20) NOT NULL,
    receiver_email VARCHAR(255),
    shipping_address TEXT NOT NULL,
    note TEXT,
    subtotal DECIMAL(15, 0) NOT NULL,
    shipping_fee DECIMAL(15, 0) DEFAULT 0,
    discount DECIMAL(15, 0) DEFAULT 0,
    total DECIMAL(15, 0) NOT NULL,
    payment_method ENUM('cod', 'bank_transfer', 'vnpay', 'momo') DEFAULT 'cod',
    payment_status ENUM('pending', 'paid', 'failed', 'refunded') DEFAULT 'pending',
    order_status ENUM('pending', 'confirmed', 'processing', 'shipping', 'delivered', 'cancelled') DEFAULT 'pending',
    cancelled_reason TEXT,
    delivered_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng Order Items
DROP TABLE IF EXISTS order_items;
CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT,
    product_name VARCHAR(255) NOT NULL,
    product_image VARCHAR(500),
    price DECIMAL(15, 0) NOT NULL,
    quantity INT NOT NULL,
    total DECIMAL(15, 0) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng Cart
DROP TABLE IF EXISTS cart;
CREATE TABLE cart (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_user_product (user_id, product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng Wishlist
DROP TABLE IF EXISTS wishlist;
CREATE TABLE wishlist (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_user_product (user_id, product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng Reviews (Product Reviews)
DROP TABLE IF EXISTS product_reviews;
CREATE TABLE product_reviews (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    user_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'approved' CHECK (status IN ('pending', 'approved', 'rejected')),
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_product_id (product_id),
    INDEX idx_user_id (user_id),
    INDEX idx_status (status),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng Coupons
DROP TABLE IF EXISTS coupons;
CREATE TABLE coupons (
    id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    discount_type ENUM('percent', 'fixed') NOT NULL,
    discount_value DECIMAL(15, 0) NOT NULL,
    min_order_value DECIMAL(15, 0) DEFAULT 0,
    max_discount DECIMAL(15, 0),
    usage_limit INT,
    used_count INT DEFAULT 0,
    start_date TIMESTAMP NULL,
    end_date TIMESTAMP NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng Contacts
DROP TABLE IF EXISTS contacts;
CREATE TABLE contacts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NULL,
    phone VARCHAR(20) NOT NULL,
    subject VARCHAR(255),
    message TEXT NOT NULL,
    status ENUM('new', 'read', 'replied') DEFAULT 'new',
    admin_note TEXT,
    user_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng Gallery
DROP TABLE IF EXISTS gallery;
CREATE TABLE gallery (
    id INT PRIMARY KEY AUTO_INCREMENT,
    image_url VARCHAR(500) NOT NULL,
    caption VARCHAR(255) NOT NULL,
    description TEXT,
    display_order INT DEFAULT 0,
    is_active TINYINT(1) DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng News
DROP TABLE IF EXISTS news;
CREATE TABLE news (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    excerpt TEXT,
    content TEXT NOT NULL,
    image_url VARCHAR(500),
    category VARCHAR(50) DEFAULT 'tips',
    author VARCHAR(100),
    views INT DEFAULT 0,
    is_published TINYINT(1) DEFAULT 1,
    published_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_category (category),
    INDEX idx_published (is_published, published_date),
    INDEX idx_slug (slug)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng Password Reset Tokens
DROP TABLE IF EXISTS password_reset_tokens;
CREATE TABLE password_reset_tokens (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    token VARCHAR(255) NOT NULL UNIQUE,
    expires_at TIMESTAMP NOT NULL,
    used BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_email (email),
    INDEX idx_token (token),
    INDEX idx_expires (expires_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- PHẦN 2: THÊM DỮ LIỆU MẪU
-- =====================================================

-- 1. USERS
-- Admin: admin@gmail.com / admin123
-- User: user@gmail.com / 123456
INSERT INTO users (email, password, fullname, phone, role, status) VALUES
('admin@gmail.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZRGdjGj/n3.1wL5oKsJLBwQbGj1G2', 'Administrator', '0921450620', 'admin', 'active'),
('user@gmail.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', 'Nguyen Van A', '0987654321', 'customer', 'active');

-- 2. CATEGORIES
INSERT INTO categories (id, name, slug, description, image, parent_id, display_order, is_active) VALUES
(1, 'Hoa Tươi', 'hoa-tuoi', 'Các loại hoa tươi đẹp', NULL, NULL, 1, TRUE),
(2, 'Hoa Giả', 'hoa-gia', 'Hoa giả trang trí', NULL, NULL, 2, TRUE),
(3, 'Bó Hoa', 'bo-hoa', 'Bó hoa tươi', 'https://file.hstatic.net/200000846175/file/z5900937479779_23a78c66588e62ae16962ab99bf0d410.jpg', 1, 1, TRUE),
(4, 'Hoa Tulip', 'hoa-tulip', 'Hoa tulip các màu', 'https://file.hstatic.net/200000846175/file/d7a376e45096e9c8b087-min.jpg', 1, 2, TRUE),
(5, 'Bình Hoa', 'binh-hoa', 'Bình hoa trang trí', 'https://file.hstatic.net/200000846175/file/z5899444875229_e1c7d0304e0a53ca2be88b52766f04e6.jpg', 1, 3, TRUE),
(6, 'Giỏ Hoa', 'gio-hoa', 'Giỏ hoa quà tặng', 'https://file.hstatic.net/200000846175/file/z5900937515947_82c85e8a4d5c70527c21e29fce363cef.jpg', 1, 4, TRUE),
(7, 'Hộp Hoa', 'hop-hoa', 'Hộp hoa cao cấp', 'https://images.unsplash.com/photo-1487530811176-3780de880c2d?w=600', 1, 5, TRUE),
(8, 'Hoa Cưới', 'hoa-cuoi', 'Hoa cưới, hoa cầm tay cô dâu', 'https://images.unsplash.com/photo-1522057384400-681b421cfebc?w=600', 1, 6, TRUE),
(9, 'Lan Hồ Điệp', 'lan-ho-diep', 'Lan hồ điệp các loại', 'https://images.unsplash.com/photo-1566873535350-a3f5d4a804b7?w=600', 1, 7, TRUE),
(10, 'Hoa Mẫu Đơn', 'hoa-mau-don', 'Hoa mẫu đơn', 'https://images.unsplash.com/photo-1490750967868-88aa4486c946?w=600', 1, 8, TRUE),
(11, 'Kệ Hoa Chúc Mừng', 'ke-hoa-chuc-mung', 'Kệ hoa khai trương, chúc mừng', 'https://images.unsplash.com/photo-1455659817273-f96807779a8a?w=600', 1, 9, TRUE),
(12, 'Hoa Tốt Nghiệp', 'hoa-tot-nghiep', 'Hoa tốt nghiệp', 'https://images.unsplash.com/photo-1561181286-d3fee7d55364?w=600', 1, 10, TRUE),
(13, 'Hoa Lụa', 'hoa-lua', 'Hoa lụa cao cấp', 'https://images.unsplash.com/photo-1508610048659-a06b669e3321?w=600', 2, 1, TRUE),
(14, 'Hoa Nhựa', 'hoa-nhua', 'Hoa nhựa trang trí', 'https://images.unsplash.com/photo-1563241527-3004b7be0ffd?w=600', 2, 2, TRUE),
(15, 'Hoa Giấy', 'hoa-giay', 'Hoa giấy handmade', 'https://images.unsplash.com/photo-1597848212624-a19eb35e2651?w=600', 2, 3, TRUE),
(16, 'Hoa Vải', 'hoa-vai', 'Hoa vải trang trí', 'https://images.unsplash.com/photo-1494972308805-463bc619d34e?w=600', 2, 4, TRUE);

-- 3. PRODUCTS
INSERT INTO products (category_id, name, slug, description, short_description, price, sale_price, quantity, image, is_featured, is_active, sold_count) VALUES
-- Bó hoa (category_id = 3)
(3, 'Bó hoa hồng đỏ tình yêu', 'bo-hoa-hong-do-tinh-yeu', 'Bó hoa hồng đỏ 20 bông tượng trưng cho tình yêu nồng cháy', 'Bó hoa hồng đỏ 20 bông', 450000, 399000, 50, 'https://images.unsplash.com/photo-1494972308805-463bc619d34e?w=400', TRUE, TRUE, 150),
(3, 'Bó hoa hướng dương rạng rỡ', 'bo-hoa-huong-duong-rang-ro', 'Bó hoa hướng dương 15 bông mang đến sự tươi sáng và may mắn', 'Bó hoa hướng dương 15 bông', 380000, NULL, 30, 'https://images.unsplash.com/photo-1597848212624-a19eb35e2651?w=400', TRUE, TRUE, 120),
(3, 'Bó hoa mix pastel', 'bo-hoa-mix-pastel', 'Bó hoa mix các loại hoa màu pastel nhẹ nhàng', 'Bó hoa mix pastel', 520000, 480000, 25, 'https://images.unsplash.com/photo-1487530811176-3780de880c2d?w=400', FALSE, TRUE, 55),
(3, 'Bó hoa cẩm tú cầu xanh', 'bo-hoa-cam-tu-cau-xanh', 'Bó hoa cẩm tú cầu xanh pastel thanh lịch', 'Cẩm tú cầu xanh', 550000, 499000, 25, 'https://images.unsplash.com/photo-1468327768560-75b778cbb551?w=400', TRUE, TRUE, 85),
(3, 'Bó hoa cúc họa mi trắng', 'bo-hoa-cuc-hoa-mi-trang', 'Bó hoa cúc họa mi trắng trong sáng', 'Cúc họa mi trắng', 320000, NULL, 40, 'https://images.unsplash.com/photo-1490750967868-88aa4486c946?w=400', FALSE, TRUE, 62),
(3, 'Bó hoa ly trắng sang trọng', 'bo-hoa-ly-trang-sang-trong', 'Bó hoa ly trắng 10 cành thanh lịch', 'Hoa ly trắng 10 cành', 780000, 720000, 15, 'https://images.unsplash.com/photo-1518882605630-8809df6a2b9a?w=400', TRUE, TRUE, 45),

-- Hoa Tulip (category_id = 4)
(4, 'Hoa Tulip hồng ngọt ngào', 'hoa-tulip-hong-ngot-ngao', 'Bó hoa tulip hồng 10 bông thể hiện sự dịu dàng', 'Bó tulip hồng 10 bông', 650000, NULL, 20, 'https://images.unsplash.com/photo-1520763185298-1b434c919102?w=400', TRUE, TRUE, 75),
(4, 'Hoa Tulip đỏ rực rỡ', 'hoa-tulip-do-ruc-ro', 'Bó hoa tulip đỏ 12 bông tượng trưng cho tình yêu hoàn hảo', 'Bó tulip đỏ 12 bông', 720000, 680000, 15, 'https://images.unsplash.com/photo-1518701005037-d53b1f67bb1c?w=400', FALSE, TRUE, 38),
(4, 'Hoa Tulip vàng rực rỡ', 'hoa-tulip-vang-ruc-ro', 'Bó hoa tulip vàng 15 bông tươi sáng', 'Tulip vàng 15 bông', 750000, 690000, 18, 'https://images.unsplash.com/photo-1459411552884-841db9b3cc2a?w=400', TRUE, TRUE, 48),
(4, 'Hoa Tulip tím quý phái', 'hoa-tulip-tim-quy-phai', 'Bó hoa tulip tím 12 bông sang trọng', 'Tulip tím 12 bông', 820000, NULL, 12, 'https://images.unsplash.com/photo-1520219306100-ec2f5c359546?w=400', FALSE, TRUE, 35),

-- Bình hoa (category_id = 5)  
(5, 'Bình hoa hồng đỏ Ecuador', 'binh-hoa-hong-do-ecuador', 'Bình hoa hồng đỏ Ecuador 30 bông sang trọng', 'Hồng Ecuador 30 bông', 1800000, 1650000, 10, 'https://images.unsplash.com/photo-1455659817273-f96807779a8a?w=400', TRUE, TRUE, 72),
(5, 'Bình hoa mix sắc màu', 'binh-hoa-mix-sac-mau', 'Bình hoa mix nhiều loại đầy màu sắc', 'Bình hoa mix màu', 680000, NULL, 20, 'https://images.unsplash.com/photo-1487530811176-3780de880c2d?w=400', FALSE, TRUE, 55),

-- Giỏ hoa (category_id = 6)
(6, 'Giỏ hoa sinh nhật ấm áp', 'gio-hoa-sinh-nhat-am-ap', 'Giỏ hoa tươi thích hợp làm quà sinh nhật', 'Giỏ hoa sinh nhật', 850000, 799000, 18, 'https://images.unsplash.com/photo-1561181286-d3fee7d55364?w=400', TRUE, TRUE, 88),
(6, 'Giỏ hoa chúc mừng khai trương', 'gio-hoa-chuc-mung-khai-truong', 'Giỏ hoa lớn phù hợp cho dịp khai trương', 'Giỏ hoa khai trương', 1200000, NULL, 10, 'https://images.unsplash.com/photo-1522057384400-681b421cfebc?w=400', FALSE, TRUE, 40),
(6, 'Giỏ hoa hồng mix baby', 'gio-hoa-hong-mix-baby', 'Giỏ hoa hồng mix baby trắng xinh xắn', 'Giỏ hồng baby', 950000, 880000, 15, 'https://images.unsplash.com/photo-1522057384400-681b421cfebc?w=400', TRUE, TRUE, 58),
(6, 'Giỏ hoa cúc đại đóa', 'gio-hoa-cuc-dai-doa', 'Giỏ hoa cúc đại đóa tươi tắn', 'Giỏ cúc đại đóa', 450000, NULL, 25, 'https://images.unsplash.com/photo-1508610048659-a06b669e3321?w=400', FALSE, TRUE, 40),

-- Hộp hoa (category_id = 7)
(7, 'Hộp hoa hồng cao cấp', 'hop-hoa-hong-cao-cap', 'Hộp hoa hồng sang trọng với 25 bông hồng Ecuador', 'Hộp hoa hồng Ecuador', 1500000, 1350000, 12, 'https://images.unsplash.com/photo-1455659817273-f96807779a8a?w=400', TRUE, TRUE, 95),
(7, 'Hộp hoa mix hồng baby', 'hop-hoa-mix-hong-baby', 'Hộp hoa mix hồng và baby trắng tinh khôi', 'Hộp hoa mix', 680000, NULL, 22, 'https://images.unsplash.com/photo-1563241527-3004b7be0ffd?w=400', FALSE, TRUE, 42),
(7, 'Hộp hoa hướng dương', 'hop-hoa-huong-duong', 'Hộp hoa hướng dương 12 bông rạng rỡ', 'Hộp hướng dương', 750000, 680000, 20, 'https://images.unsplash.com/photo-1597848212624-a19eb35e2651?w=400', TRUE, TRUE, 65),
(7, 'Hộp hoa cẩm chướng', 'hop-hoa-cam-chuong', 'Hộp hoa cẩm chướng đủ màu sắc', 'Hộp cẩm chướng', 520000, NULL, 28, 'https://images.unsplash.com/photo-1468327768560-75b778cbb551?w=400', FALSE, TRUE, 38),

-- Hoa cưới (category_id = 8)
(8, 'Hoa cầm tay cô dâu trắng', 'hoa-cam-tay-co-dau-trang', 'Hoa cầm tay cô dâu hồng trắng thanh lịch', 'Hoa cầm tay cô dâu', 650000, 599000, 15, 'https://images.unsplash.com/photo-1519225421980-715cb0215aed?w=400', TRUE, TRUE, 92),
(8, 'Hoa cưới cascade sang trọng', 'hoa-cuoi-cascade-sang-trong', 'Hoa cưới kiểu cascade rũ xuống sang trọng', 'Hoa cưới cascade', 1200000, 1080000, 8, 'https://images.unsplash.com/photo-1522057384400-681b421cfebc?w=400', TRUE, TRUE, 28),

-- Lan Hồ Điệp (category_id = 9)
(9, 'Chậu lan hồ điệp trắng 5 cánh', 'chau-lan-ho-diep-trang-5-canh', 'Chậu lan hồ điệp trắng 5 cánh sang trọng, may mắn', 'Lan hồ điệp trắng 5 cánh', 2500000, 2300000, 8, 'https://images.unsplash.com/photo-1566873535350-a3f5d4a804b7?w=400', TRUE, TRUE, 68),
(9, 'Chậu lan hồ điệp tím 3 cánh', 'chau-lan-ho-diep-tim-3-canh', 'Chậu lan hồ điệp tím 3 cánh quý phái', 'Lan hồ điệp tím 3 cánh', 1800000, NULL, 10, 'https://images.unsplash.com/photo-1612363148951-15f16817648f?w=400', FALSE, TRUE, 22),
(9, 'Chậu lan hồ điệp vàng 7 cành', 'chau-lan-ho-diep-vang-7-canh', 'Chậu lan hồ điệp vàng 7 cành may mắn', 'Lan vàng 7 cành', 3200000, 2900000, 6, 'https://images.unsplash.com/photo-1566873535350-a3f5d4a804b7?w=400', TRUE, TRUE, 22),

-- Hoa Mẫu Đơn (category_id = 10)
(10, 'Bó hoa mẫu đơn hồng', 'bo-hoa-mau-don-hong', 'Bó hoa mẫu đơn hồng phấn 8 bông', 'Mẫu đơn hồng 8 bông', 1100000, 980000, 12, 'https://images.unsplash.com/photo-1490750967868-88aa4486c946?w=400', TRUE, TRUE, 52),
(10, 'Bó hoa mẫu đơn trắng', 'bo-hoa-mau-don-trang', 'Bó hoa mẫu đơn trắng tinh khôi', 'Mẫu đơn trắng', 1250000, NULL, 10, 'https://images.unsplash.com/photo-1563241527-3004b7be0ffd?w=400', FALSE, TRUE, 35),

-- Hoa Lụa (category_id = 13)
(13, 'Bình hoa lụa trang trí phòng khách', 'binh-hoa-lua-trang-tri-phong-khach', 'Bình hoa lụa cao cấp trang trí nội thất', 'Bình hoa lụa phòng khách', 350000, 299000, 40, 'https://images.unsplash.com/photo-1490750967868-88aa4486c946?w=400', FALSE, TRUE, 30),
(13, 'Bó hoa lụa hồng vintage', 'bo-hoa-lua-hong-vintage', 'Bó hoa lụa phong cách vintage lãng mạn', 'Bó hoa lụa vintage', 280000, NULL, 35, 'https://images.unsplash.com/photo-1508610048659-a06b669e3321?w=400', TRUE, TRUE, 30);

-- 4. COUPONS
INSERT INTO coupons (code, description, discount_type, discount_value, min_order_value, max_discount, usage_limit, start_date, end_date, is_active) VALUES
('WELCOME10', 'Giảm 10% cho khách hàng mới', 'percent', 10, 200000, 100000, 100, '2025-01-01 00:00:00', '2025-12-31 23:59:59', TRUE),
('FREESHIP', 'Miễn phí vận chuyển', 'fixed', 30000, 300000, NULL, 50, '2025-01-01 00:00:00', '2025-06-30 23:59:59', TRUE),
('SALE50K', 'Giảm 50.000đ cho đơn từ 500K', 'fixed', 50000, 500000, NULL, 30, '2025-01-01 00:00:00', '2025-03-31 23:59:59', TRUE);

-- 5. GALLERY
INSERT INTO gallery (image_url, caption, description, display_order, is_active) VALUES
('https://cdn.hstatic.net/files/200000846175/file/caf51f824f9dc2c39b8c.jpg', 'Bó hoa pastel dịu dàng', 'Bó hoa pastel với tông màu nhẹ nhàng, phù hợp cho mọi dịp', 1, 1),
('https://product.hstatic.net/200000846175/product/w6_57fe7e7ee65f4097aef741ba053a4609.jpg', 'Kệ hoa khai trương', 'Kệ hoa chúc mừng khai trương với thiết kế sang trọng', 2, 1),
('https://images.unsplash.com/photo-1563241527-3004b7be0ffd?w=400', 'Bó hoa cưới lãng mạn', 'Bó hoa cưới đẹp cho ngày trọng đại của bạn', 3, 1),
('https://images.unsplash.com/photo-1490750967868-88aa4486c946?w=400', 'Bó hoa sinh nhật', 'Bó hoa tươi tắn để chúc mừng sinh nhật', 4, 1),
('https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=400', 'Tulip tươi sắc', 'Hoa tulip với màu sắc rực rỡ', 5, 1),
('https://images.unsplash.com/photo-1455659817273-f96807779a8a?w=400', 'Hồng đỏ cổ điển', 'Hoa hồng đỏ - biểu tượng của tình yêu', 6, 1);

-- 6. NEWS
INSERT INTO news (title, slug, excerpt, content, image_url, category, author, is_published, published_date) VALUES
('Gợi ý chọn bó hoa pastel cho những ngày cần sự dịu dàng', 'goi-y-chon-bo-hoa-pastel', 
 'Tone pastel luôn mang lại cảm giác nhẹ nhàng, trong trẻo – rất hợp để tặng những người mình thương vào dịp sinh nhật, kỷ niệm hoặc đơn giản là "vì nhớ bạn".', 
 '<p>Tone màu pastel với những gam màu nhẹ nhàng như hồng phấn, tím lavender, xanh mint luôn mang đến cảm giác dịu dàng và thanh thoát. Đây là lựa chọn hoàn hảo khi bạn muốn gửi gắm những tình cảm chân thành nhất đến người thân yêu.</p><p>Bó hoa pastel không chỉ đẹp mắt mà còn có ý nghĩa sâu sắc, thể hiện sự tinh tế và quan tâm của người tặng. Hãy để Tiệm Hoa nhà tớ giúp bạn lựa chọn bó hoa pastel phù hợp nhất!</p>', 
 'https://cdn.hstatic.net/files/200000846175/file/caf51f824f9dc2c39b8c.jpg', 
 'tips', 'Admin', 1, '2025-11-10 10:00:00'),

('Chọn kệ hoa khai trương sao cho tinh tế mà vẫn sang trọng?', 'chon-ke-hoa-khai-truong-sang-trong', 
 'Lễ khai trương là dịp quan trọng đánh dấu bước khởi đầu mới. Vậy nên chọn kệ hoa như thế nào để vừa thể hiện sự chúc mừng, vừa tôn lên không gian sang trọng?', 
 '<p>Kệ hoa khai trương không chỉ là món quà chúc mừng mà còn là biểu tượng của sự thành công và thịnh vượng. Việc lựa chọn kệ hoa phù hợp sẽ tạo ấn tượng tốt đẹp và mang lại may mắn cho chủ nhân.</p><p>Các loại hoa thường dùng trong kệ khai trương bao gồm: lan hồ điệp (sang trọng), hoa hồng (thành công), hướng dương (tươi sáng). Màu sắc nên chọn tông vàng, đỏ, hồng để tượng trưng cho sự phát đạt.</p>', 
 'https://product.hstatic.net/200000846175/product/w6_57fe7e7ee65f4097aef741ba053a4609.jpg', 
 'opening', 'Admin', 1, '2025-11-02 09:00:00'),

('10 Tips bảo quản hoa tươi lâu cho người bận rộn', '10-tips-bao-quan-hoa-tuoi-lau', 
 'Bạn yêu hoa nhưng không có nhiều thời gian chăm sóc? Đừng lo! Dưới đây là 10 mẹo siêu đơn giản giúp hoa tươi của bạn có thể "sống" lâu hơn.', 
 '<h3>10 mẹo bảo quản hoa tươi:</h3><ol><li><strong>Cắt thân hoa xiên</strong>: Cắt xiên góc 45 độ để tăng diện tích hấp thụ nước</li><li><strong>Thay nước thường xuyên</strong>: 2-3 ngày/lần để tránh vi khuẩn phát triển</li><li><strong>Loại bỏ lá dưới nước</strong>: Lá ngâm trong nước sẽ thối và tạo mùi hôi</li><li><strong>Đặt hoa ở nơi thoáng mát</strong>: Tránh ánh nắng trực tiếp và gió mạnh</li><li><strong>Thêm đường hoặc aspirin</strong>: Giúp hoa tươi lâu hơn</li><li><strong>Tránh đặt gần trái cây</strong>: Khí ethylene từ trái cây làm hoa héo nhanh</li><li><strong>Phun sương nhẹ</strong>: Giữ độ ẩm cho cánh hoa</li><li><strong>Cắt bớt lá thừa</strong>: Giảm lượng nước bị bay hơi</li><li><strong>Sử dụng bình sạch</strong>: Rửa bình kỹ trước khi cắm hoa</li><li><strong>Thêm chất bảo quản</strong>: Sử dụng gói bột bảo quản hoa chuyên dụng</li></ol>', 
 'https://file.hstatic.net/200000846175/article/6_d6bdb32719444cc5ad4a6193f4c065f1_master.png', 
 'tips', 'Admin', 1, '2025-10-18 11:00:00'),

('Ý nghĩa của từng loại hoa và khi nào nên tặng', 'y-nghia-cua-tung-loai-hoa', 
 'Mỗi loại hoa mang một thông điệp riêng. Hiểu rõ ý nghĩa của hoa sẽ giúp bạn chọn đúng loại hoa để tặng vào từng dịp.', 
 '<h3>Ý nghĩa các loại hoa phổ biến:</h3><ul><li><strong>Hoa hồng đỏ</strong>: Tình yêu nồng nàn - Tặng người yêu, ngày Valentine</li><li><strong>Hoa hồng vàng</strong>: Tình bạn, niềm vui - Tặng bạn bè, đồng nghiệp</li><li><strong>Hoa tulip</strong>: Tình yêu hoàn hảo - Tặng vào mùa xuân, lễ tình nhân</li><li><strong>Hoa hướng dương</strong>: Sự lạc quan, thành công - Tặng khai trương, tốt nghiệp</li><li><strong>Hoa lily</strong>: Thanh khiết, cao quý - Tặng người lớn tuổi, thầy cô</li><li><strong>Hoa cẩm tú cầu</strong>: Lòng biết ơn - Tặng mẹ, người có ơn</li><li><strong>Hoa lan hồ điệp</strong>: Sang trọng, may mắn - Tặng khai trương, chúc mừng</li></ul>', 
 'https://images.unsplash.com/photo-1490750967868-88aa4486c946?w=400', 
 'tips', 'Admin', 1, '2025-09-28 13:00:00');

-- 7. PRODUCT REVIEWS (Đánh giá mẫu)
INSERT INTO product_reviews (product_id, user_id, rating, comment, status) VALUES
(1, 2, 5, 'Hoa rất đẹp và tươi, giao hàng nhanh. Rất hài lòng!', 'approved'),
(1, 2, 4, 'Chất lượng tốt, giá hợp lý. Sẽ ủng hộ shop lần sau.', 'approved'),
(2, 2, 5, 'Bó hoa sinh nhật đẹp quá! Người nhận rất thích.', 'approved'),
(3, 2, 3, 'Hoa đẹp nhưng giao hơi lâu so với dự kiến.', 'approved'),
(4, 2, 5, 'Hoa cưới tuyệt vời, đúng như mô tả!', 'approved');

-- =====================================================
-- PHẦN 3: HOÀN THIỆN VÀ KIỂM TRA
-- =====================================================

-- Cập nhật average_rating và review_count cho products
UPDATE products p
SET 
    average_rating = (
        SELECT COALESCE(AVG(rating), 0)
        FROM product_reviews
        WHERE product_id = p.id AND status = 'approved'
    ),
    review_count = (
        SELECT COUNT(*)
        FROM product_reviews
        WHERE product_id = p.id AND status = 'approved'
    );

-- =====================================================
-- KIỂM TRA DỮ LIỆU
-- =====================================================
SELECT '=== TỔNG QUAN HỆ THỐNG ===' as info;

SELECT 
    (SELECT COUNT(*) FROM users) as 'Users',
    (SELECT COUNT(*) FROM categories) as 'Categories',
    (SELECT COUNT(*) FROM products) as 'Products',
    (SELECT COUNT(*) FROM coupons) as 'Coupons',
    (SELECT COUNT(*) FROM gallery) as 'Gallery',
    (SELECT COUNT(*) FROM news) as 'News',
    (SELECT COUNT(*) FROM product_reviews) as 'Reviews';

SELECT '=== SETUP HOÀN TẤT ===' as info;
SELECT 'Database đã được khởi tạo thành công!' as message;
SELECT 'Đăng nhập Admin: admin@gmail.com / admin123' as admin_account;
SELECT 'Đăng nhập User: user@gmail.com / 123456' as user_account;


-- =====================================================
-- OPTIONAL: STATISTICS QUERIES
-- =====================================================

-- =====================================================
-- SCRIPT KIỂM TRA THỐNG KÊ
-- =====================================================

USE flowerstore;

-- =====================================================
-- 1. KIỂM TRA TỔNG QUAN
-- =====================================================

SELECT 
    '=== TỔNG QUAN HỆ THỐNG ===' as info;

SELECT 
    (SELECT COUNT(*) FROM users) as 'Tổng Khách Hàng',
    (SELECT COUNT(*) FROM products) as 'Tổng Sản Phẩm',
    (SELECT COUNT(*) FROM orders) as 'Tổng Đơn Hàng',
    (SELECT COUNT(*) FROM categories) as 'Tổng Danh Mục',
    (SELECT COUNT(*) FROM contacts) as 'Tổng Liên Hệ';

-- =====================================================
-- 2. THỐNG KÊ ĐỜN HÀNG THEO TRẠNG THÁI
-- =====================================================

SELECT 
    '=== ĐƠN HÀNG THEO TRẠNG THÁI ===' as info;

SELECT 
    order_status as 'Trạng Thái',
    COUNT(*) as 'Số Lượng',
    FORMAT(SUM(total), 0) as 'Tổng Tiền (VNĐ)'
FROM orders
GROUP BY order_status
ORDER BY 
    FIELD(order_status, 'pending', 'confirmed', 'processing', 'shipping', 'delivered', 'cancelled');

-- =====================================================
-- 3. THỐNG KÊ THANH TOÁN
-- =====================================================

SELECT 
    '=== THANH TOÁN THEO TRẠNG THÁI ===' as info;

SELECT 
    payment_status as 'Trạng Thái Thanh Toán',
    COUNT(*) as 'Số Lượng',
    FORMAT(SUM(total), 0) as 'Tổng Tiền (VNĐ)'
FROM orders
GROUP BY payment_status
ORDER BY 
    FIELD(payment_status, 'pending', 'paid', 'failed', 'refunded');

-- =====================================================
-- 4. TỔNG DOANH THU (ĐIỀU KIỆN CHÍNH XÁC)
-- =====================================================

SELECT 
    '=== TỔNG DOANH THU ===' as info;

-- Đơn hàng đã giao VÀ đã thanh toán
SELECT 
    COUNT(*) as 'Số Đơn Đã Giao & Đã Thanh Toán',
    FORMAT(SUM(total), 0) as 'Tổng Doanh Thu (VNĐ)',
    FORMAT(AVG(total), 0) as 'Trung Bình/Đơn (VNĐ)',
    FORMAT(MIN(total), 0) as 'Đơn Nhỏ Nhất (VNĐ)',
    FORMAT(MAX(total), 0) as 'Đơn Lớn Nhất (VNĐ)'
FROM orders
WHERE order_status = 'delivered' 
  AND payment_status = 'paid';

-- =====================================================
-- 5. BREAKDOWN CHI TIẾT
-- =====================================================

SELECT 
    '=== BREAKDOWN CHI TIẾT ===' as info;

SELECT 
    order_status as 'Trạng Thái Đơn',
    payment_status as 'Trạng Thái Thanh Toán',
    COUNT(*) as 'Số Lượng',
    FORMAT(SUM(total), 0) as 'Tổng Tiền (VNĐ)',
    CONCAT(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM orders), 2), '%') as 'Tỷ Lệ %'
FROM orders
GROUP BY order_status, payment_status
ORDER BY COUNT(*) DESC;

-- =====================================================
-- 6. ĐƠN HÀNG GẦN ĐÂY (10 ĐƠN)
-- =====================================================

SELECT 
    '=== 10 ĐƠN HÀNG GẦN NHẤT ===' as info;

SELECT 
    order_code as 'Mã Đơn',
    receiver_name as 'Người Nhận',
    FORMAT(total, 0) as 'Tổng Tiền (VNĐ)',
    order_status as 'Trạng Thái',
    payment_status as 'Thanh Toán',
    payment_method as 'Phương Thức',
    DATE_FORMAT(created_at, '%d/%m/%Y %H:%i') as 'Ngày Tạo'
FROM orders
ORDER BY created_at DESC
LIMIT 10;

-- =====================================================
-- 7. KIỂM TRA CÁC ĐƠN HÀNG ĐANG CÓ VẤN ĐỀ
-- =====================================================

SELECT 
    '=== ĐƠN HÀNG CẦN CHÚ Ý ===' as info;

-- Đơn đã giao nhưng chưa thanh toán (COD chưa thu tiền)
SELECT 
    'Đã Giao - Chưa Thanh Toán' as 'Loại Vấn Đề',
    COUNT(*) as 'Số Lượng',
    FORMAT(SUM(total), 0) as 'Tổng Tiền (VNĐ)'
FROM orders
WHERE order_status = 'delivered' 
  AND payment_status = 'pending';

-- Đơn đã thanh toán nhưng chưa giao (Cần xử lý)
SELECT 
    'Đã Thanh Toán - Chưa Giao' as 'Loại Vấn Đề',
    COUNT(*) as 'Số Lượng',
    FORMAT(SUM(total), 0) as 'Tổng Tiền (VNĐ)'
FROM orders
WHERE payment_status = 'paid' 
  AND order_status NOT IN ('delivered', 'cancelled');

-- Đơn bị hủy sau khi đã thanh toán (Cần hoàn tiền)
SELECT 
    'Đã Hủy - Đã Thanh Toán' as 'Loại Vấn Đề',
    COUNT(*) as 'Số Lượng',
    FORMAT(SUM(total), 0) as 'Tổng Tiền (VNĐ)'
FROM orders
WHERE order_status = 'cancelled' 
  AND payment_status = 'paid';

-- =====================================================
-- 8. THỐNG KÊ THEO THỜI GIAN
-- =====================================================

SELECT 
    '=== DOANH THU 7 NGÀY GẦN NHẤT ===' as info;

SELECT 
    DATE(created_at) as 'Ngày',
    COUNT(*) as 'Số Đơn',
    FORMAT(SUM(CASE WHEN order_status = 'delivered' AND payment_status = 'paid' 
                    THEN total ELSE 0 END), 0) as 'Doanh Thu (VNĐ)'
FROM orders
WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
GROUP BY DATE(created_at)
ORDER BY DATE(created_at) DESC;

-- =====================================================
-- 9. SẢN PHẨM BÁN CHẠY
-- =====================================================

SELECT 
    '=== TOP 10 SẢN PHẨM BÁN CHẠY ===' as info;

SELECT 
    p.name as 'Tên Sản Phẩm',
    SUM(oi.quantity) as 'Số Lượng Bán',
    FORMAT(SUM(oi.quantity * oi.price), 0) as 'Doanh Thu (VNĐ)',
    COUNT(DISTINCT oi.order_id) as 'Số Đơn Hàng'
FROM products p
JOIN order_items oi ON p.id = oi.product_id
JOIN orders o ON oi.order_id = o.id
WHERE o.order_status != 'cancelled'
GROUP BY p.id, p.name
ORDER BY SUM(oi.quantity) DESC
LIMIT 10;

-- =====================================================
-- 10. KIỂM TRA DỮ LIỆU MẪU
-- =====================================================

SELECT 
    '=== KIỂM TRA DỮ LIỆU MẪU ===' as info;

-- Có ít nhất 1 đơn hàng delivered + paid không?
SELECT 
    CASE 
        WHEN COUNT(*) > 0 THEN 'CÓ DỮ LIỆU - Dashboard sẽ hiển thị doanh thu'
        ELSE 'KHÔNG CÓ DỮ LIỆU - Cần tạo đơn hàng mẫu'
    END as 'Trạng Thái',
    COUNT(*) as 'Số Đơn Hợp Lệ',
    FORMAT(COALESCE(SUM(total), 0), 0) as 'Tổng Doanh Thu (VNĐ)'
FROM orders
WHERE order_status = 'delivered' 
  AND payment_status = 'paid';
