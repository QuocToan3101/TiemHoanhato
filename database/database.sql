-- FlowerStore database initialization
-- Rebuilt schema for the current application codebase

CREATE DATABASE IF NOT EXISTS flowerStore
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE flowerStore;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS newsletter_subscribers;
DROP TABLE IF EXISTS password_reset_tokens;
DROP TABLE IF EXISTS contacts;
DROP TABLE IF EXISTS coupons;
DROP TABLE IF EXISTS product_reviews;
DROP TABLE IF EXISTS wishlist;
DROP TABLE IF EXISTS cart_items;
DROP TABLE IF EXISTS carts;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS addresses;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS gallery;
DROP TABLE IF EXISTS news;

SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    fullname VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    avatar VARCHAR(500),
    bio TEXT,
    gender VARCHAR(20),
    birthday DATE,
    role ENUM('customer', 'admin') NOT NULL DEFAULT 'customer',
    status ENUM('pending', 'active', 'inactive', 'banned') NOT NULL DEFAULT 'active',
    verification_token VARCHAR(255) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_users_status (status),
    INDEX idx_verification_token (verification_token)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_categories_parent
        FOREIGN KEY (parent_id) REFERENCES categories(id)
        ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_products_category_id (category_id),
    INDEX idx_products_active (is_active),
    INDEX idx_products_featured (is_featured),
    CONSTRAINT fk_products_category
        FOREIGN KEY (category_id) REFERENCES categories(id)
        ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_addresses_user_id (user_id),
    CONSTRAINT fk_addresses_user
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_code VARCHAR(50) NOT NULL UNIQUE,
    user_id INT DEFAULT NULL,
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
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_orders_user_id (user_id),
    INDEX idx_orders_status (order_status),
    INDEX idx_orders_payment_status (payment_status),
    CONSTRAINT fk_orders_user
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT DEFAULT NULL,
    product_name VARCHAR(255) NOT NULL,
    product_image VARCHAR(500),
    price DECIMAL(15, 0) NOT NULL,
    quantity INT NOT NULL,
    total DECIMAL(15, 0) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_order_items_order_id (order_id),
    INDEX idx_order_items_product_id (product_id),
    CONSTRAINT fk_order_items_order
        FOREIGN KEY (order_id) REFERENCES orders(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_order_items_product
        FOREIGN KEY (product_id) REFERENCES products(id)
        ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE carts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_user_cart (user_id),
    INDEX idx_carts_user_id (user_id),
    CONSTRAINT fk_carts_user
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE cart_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cart_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    price DECIMAL(15, 0) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_cart_product (cart_id, product_id),
    INDEX idx_cart_items_cart_id (cart_id),
    INDEX idx_cart_items_product_id (product_id),
    CONSTRAINT fk_cart_items_cart
        FOREIGN KEY (cart_id) REFERENCES carts(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_cart_items_product
        FOREIGN KEY (product_id) REFERENCES products(id)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE wishlist (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_user_product (user_id, product_id),
    INDEX idx_wishlist_user_id (user_id),
    INDEX idx_wishlist_product_id (product_id),
    CONSTRAINT fk_wishlist_user
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_wishlist_product
        FOREIGN KEY (product_id) REFERENCES products(id)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE product_reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    user_id INT NOT NULL,
    rating INT NOT NULL,
    comment TEXT,
    status ENUM('pending', 'approved', 'rejected') DEFAULT 'approved',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_product_reviews_product_id (product_id),
    INDEX idx_product_reviews_user_id (user_id),
    INDEX idx_product_reviews_status (status),
    CONSTRAINT fk_product_reviews_product
        FOREIGN KEY (product_id) REFERENCES products(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_product_reviews_user
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_coupons_code (code),
    INDEX idx_coupons_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE contacts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NULL,
    phone VARCHAR(20) NOT NULL,
    subject VARCHAR(255),
    message TEXT NOT NULL,
    status ENUM('new', 'read', 'replied') DEFAULT 'new',
    admin_note TEXT,
    user_id INT DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_contacts_status (status),
    INDEX idx_contacts_user_id (user_id),
    CONSTRAINT fk_contacts_user
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE gallery (
    id INT AUTO_INCREMENT PRIMARY KEY,
    image_url VARCHAR(500) NOT NULL,
    caption VARCHAR(255) NOT NULL,
    description TEXT,
    display_order INT DEFAULT 0,
    is_active TINYINT(1) DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_gallery_active (is_active),
    INDEX idx_gallery_display_order (display_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE news (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    slug VARCHAR(255) NOT NULL UNIQUE,
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
    INDEX idx_news_category (category),
    INDEX idx_news_published (is_published, published_date),
    INDEX idx_news_slug (slug)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE password_reset_tokens (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    token VARCHAR(255) NOT NULL UNIQUE,
    expires_at DATETIME NOT NULL,
    used BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_password_reset_email (email),
    INDEX idx_password_reset_token (token),
    INDEX idx_password_reset_expires_at (expires_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE newsletter_subscribers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    subscribed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    INDEX idx_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3.1) Demo users
INSERT INTO users (
    id, email, password, fullname, phone, avatar, bio, gender, birthday, role, status, verification_token, created_at, updated_at
) VALUES
(1, 'admin@flowerstore.local', '$2a$10$QGNq3N1mXDn2d9asGoI9W.qhs9Yzc9T/bO.M6quC2QTSd2FJHL92K', 'FlowerStore Admin', '0909000001', NULL, 'System administrator account', 'Nam', NULL, 'admin', 'active', NULL, NOW(), NOW()),
(2, 'customer@flowerstore.local', '$2a$10$Eoa7v9zu0tduowBBIRHuputlg3M84ucYceuXLjTMjn.YiJW7CE26e', 'Demo Customer', '0909000002', NULL, 'Demo account for testing', 'Nu', NULL, 'customer', 'active', NULL, NOW(), NOW());

-- 3.2) Categories
INSERT INTO categories (
    id, name, slug, description, image, parent_id, display_order, is_active, created_at, updated_at
) VALUES
(1, 'Bouquets', 'bouquets', 'Main bouquet category', NULL, NULL, 1, TRUE, NOW(), NOW()),
(2, 'Roses', 'roses', 'Rose bouquets and boxes', NULL, 1, 1, TRUE, NOW(), NOW()),
(3, 'Mixed Flowers', 'mixed-flowers', 'Mixed bouquet arrangements', NULL, 1, 2, TRUE, NOW(), NOW()),
(4, 'Occasions', 'occasions', 'Flowers for special occasions', NULL, NULL, 2, TRUE, NOW(), NOW()),
(5, 'Birthday', 'birthday', 'Birthday flower gifts', NULL, 4, 1, TRUE, NOW(), NOW()),
(6, 'Wedding', 'wedding', 'Wedding bouquets and decorations', NULL, 4, 2, TRUE, NOW(), NOW()),
(7, 'Sympathy', 'sympathy', 'Sympathy flower arrangements', NULL, 4, 3, TRUE, NOW(), NOW()),
(8, 'Plants', 'plants', 'Indoor and decorative plants', NULL, NULL, 3, TRUE, NOW(), NOW()),
(9, 'Orchids', 'orchids', 'Orchid plants and gifts', NULL, 8, 1, TRUE, NOW(), NOW()),
(10, 'Succulents', 'succulents', 'Small potted succulents', NULL, 8, 2, TRUE, NOW(), NOW());

-- 3.3) Products
INSERT INTO products (
    id, category_id, name, slug, description, short_description, price, sale_price, quantity, image, images,
    is_featured, is_active, view_count, sold_count, average_rating, review_count, created_at, updated_at
) VALUES
(1, 2, 'Classic Red Roses', 'classic-red-roses', 'A classic bouquet of red roses for romantic moments.', 'Elegant red roses for anniversaries and dates.', 450000, 390000, 20, 'https://via.placeholder.com/600x600?text=Red+Roses', '["https://via.placeholder.com/600x600?text=Red+Roses+1"]', TRUE, TRUE, 120, 54, 4.80, 12, NOW(), NOW()),
(2, 2, 'Pink Rose Box', 'pink-rose-box', 'A premium pink rose box with soft romantic tones.', 'Gift box of pink roses.', 520000, 0, 15, 'https://via.placeholder.com/600x600?text=Pink+Rose+Box', '["https://via.placeholder.com/600x600?text=Pink+Rose+Box+1"]', TRUE, TRUE, 98, 31, 4.60, 8, NOW(), NOW()),
(3, 3, 'Sunny Harmony Bouquet', 'sunny-harmony-bouquet', 'Bright mixed bouquet with a cheerful color palette.', 'Mixed bouquet for every occasion.', 380000, 330000, 18, 'https://via.placeholder.com/600x600?text=Mixed+Bouquet', '["https://via.placeholder.com/600x600?text=Mixed+Bouquet+1"]', TRUE, TRUE, 76, 28, 4.70, 7, NOW(), NOW()),
(4, 3, 'Pastel Tulip Bouquet', 'pastel-tulip-bouquet', 'Soft pastel tulips arranged in a modern bouquet.', 'Fresh tulips with a gentle look.', 560000, 0, 12, 'https://via.placeholder.com/600x600?text=Tulips', '["https://via.placeholder.com/600x600?text=Tulips+1"]', TRUE, TRUE, 64, 22, 4.90, 9, NOW(), NOW()),
(5, 5, 'Birthday Joy Basket', 'birthday-joy-basket', 'A joyful birthday basket with flowers and accents.', 'Colorful birthday gift basket.', 620000, 590000, 10, 'https://via.placeholder.com/600x600?text=Birthday+Basket', '["https://via.placeholder.com/600x600?text=Birthday+Basket+1"]', TRUE, TRUE, 51, 16, 4.50, 5, NOW(), NOW()),
(6, 6, 'Wedding White Bouquet', 'wedding-white-bouquet', 'Elegant white bouquet for wedding ceremonies.', 'Clean white wedding arrangement.', 780000, 720000, 9, 'https://via.placeholder.com/600x600?text=Wedding+Bouquet', '["https://via.placeholder.com/600x600?text=Wedding+Bouquet+1"]', TRUE, TRUE, 45, 14, 4.85, 6, NOW(), NOW()),
(7, 7, 'Gentle Sympathy Arrangement', 'gentle-sympathy-arrangement', 'A respectful arrangement designed for condolence ceremonies.', 'Soft sympathy flower set.', 650000, 0, 8, 'https://via.placeholder.com/600x600?text=Sympathy+Flowers', '["https://via.placeholder.com/600x600?text=Sympathy+Flowers+1"]', FALSE, TRUE, 33, 11, 4.40, 4, NOW(), NOW()),
(8, 9, 'Premium Purple Orchid', 'premium-purple-orchid', 'A premium potted orchid with a long blooming cycle.', 'Orchid gift for home or office.', 850000, 790000, 14, 'https://via.placeholder.com/600x600?text=Orchid', '["https://via.placeholder.com/600x600?text=Orchid+1"]', TRUE, TRUE, 58, 19, 4.75, 10, NOW(), NOW()),
(9, 9, 'Mini White Orchid', 'mini-white-orchid', 'A compact orchid suitable for desks and small spaces.', 'Small orchid plant.', 430000, 0, 25, 'https://via.placeholder.com/600x600?text=Mini+Orchid', '["https://via.placeholder.com/600x600?text=Mini+Orchid+1"]', FALSE, TRUE, 24, 8, 4.20, 3, NOW(), NOW()),
(10, 10, 'Green Succulent Set', 'green-succulent-set', 'A set of decorative succulents for modern interiors.', 'Low maintenance plant set.', 290000, 240000, 30, 'https://via.placeholder.com/600x600?text=Succulents', '["https://via.placeholder.com/600x600?text=Succulents+1"]', FALSE, TRUE, 39, 17, 4.30, 5, NOW(), NOW()),
(11, 3, 'Luxury Vase Bouquet', 'luxury-vase-bouquet', 'A premium bouquet arranged in a reusable vase.', 'Ready-to-display flower gift.', 910000, 870000, 7, 'https://via.placeholder.com/600x600?text=Vase+Bouquet', '["https://via.placeholder.com/600x600?text=Vase+Bouquet+1"]', TRUE, TRUE, 44, 13, 4.88, 6, NOW(), NOW()),
(12, 5, 'Happy Day Mini Bouquet', 'happy-day-mini-bouquet', 'A small, affordable bouquet for quick gifting.', 'Mini bouquet for birthdays.', 220000, 0, 40, 'https://via.placeholder.com/600x600?text=Mini+Bouquet', '["https://via.placeholder.com/600x600?text=Mini+Bouquet+1"]', FALSE, TRUE, 29, 9, 4.10, 2, NOW(), NOW());

-- 3.4) Supporting demo data
INSERT INTO addresses (
    id, user_id, receiver_name, phone, province, district, ward, address_detail, note, is_default, created_at, updated_at
) VALUES
(1, 2, 'Demo Customer', '0909000002', 'Ha Noi', 'Cau Giay', 'Dich Vong', '123 Flower Street', 'Default demo address', TRUE, NOW(), NOW());

INSERT INTO product_reviews (
    id, product_id, user_id, rating, comment, status, created_at, updated_at
) VALUES
(1, 1, 2, 5, 'Beautiful bouquet and fast delivery.', 'approved', NOW(), NOW()),
(2, 3, 2, 4, 'Fresh flowers and nice packaging.', 'approved', NOW(), NOW());

INSERT INTO wishlist (
    id, user_id, product_id, created_at
) VALUES
(1, 2, 4, NOW()),
(2, 2, 8, NOW());

INSERT INTO newsletter_subscribers (
    id, email, subscribed_at, is_active
) VALUES
(1, 'subscriber@flowerstore.local', NOW(), TRUE);

INSERT INTO gallery (
    id, image_url, caption, description, display_order, is_active, created_at, updated_at
) VALUES
(1, 'https://via.placeholder.com/1200x800?text=FlowerStore+Gallery+1', 'Spring Collection', 'Seasonal bouquets and gifts', 1, 1, NOW(), NOW()),
(2, 'https://via.placeholder.com/1200x800?text=FlowerStore+Gallery+2', 'Romantic Roses', 'Romantic bouquet showcase', 2, 1, NOW(), NOW()),
(3, 'https://via.placeholder.com/1200x800?text=FlowerStore+Gallery+3', 'Orchid Corner', 'Elegant orchid arrangements', 3, 1, NOW(), NOW()),
(4, 'https://via.placeholder.com/1200x800?text=FlowerStore+Gallery+4', 'Occasion Gifts', 'Flower gifts for special days', 4, 1, NOW(), NOW());

INSERT INTO news (
    id, title, slug, excerpt, content, image_url, category, author, views, is_published, published_date, created_at, updated_at
) VALUES
(1, 'How to keep flowers fresh longer', 'how-to-keep-flowers-fresh-longer', 'Simple care tips for keeping bouquets beautiful.', 'Keep stems trimmed, change the water regularly, and place bouquets away from direct sunlight and heat.', 'https://via.placeholder.com/1200x800?text=Fresh+Flowers', 'tips', 'FlowerStore Team', 120, 1, NOW(), NOW(), NOW()),
(2, 'Best flowers for birthdays', 'best-flowers-for-birthdays', 'Popular flower gifts that work well for birthdays.', 'Birthday gifts work best when they feel bright, cheerful, and personal. Mixed bouquets and roses are always a safe choice.', 'https://via.placeholder.com/1200x800?text=Birthday+Flowers', 'gift-guide', 'FlowerStore Team', 86, 1, NOW(), NOW(), NOW()),
(3, 'Wedding bouquet trends this season', 'wedding-bouquet-trends-this-season', 'Modern wedding bouquet ideas for the current season.', 'Soft white palettes, light pastel flowers, and minimal wrapping remain popular for wedding bouquets this year.', 'https://via.placeholder.com/1200x800?text=Wedding+Flowers', 'wedding', 'FlowerStore Team', 74, 1, NOW(), NOW(), NOW()),
(4, 'Office plants that are easy to care for', 'office-plants-that-are-easy-to-care-for', 'Low-maintenance plants suitable for desks and reception areas.', 'Succulents and orchids are excellent choices for offices because they need relatively little daily care and still look elegant.', 'https://via.placeholder.com/1200x800?text=Office+Plants', 'plants', 'FlowerStore Team', 51, 1, NOW(), NOW(), NOW());

-- 3.5) Password reset tokens table is intentionally empty on import.

-- 3.6) System tables are now seeded; keep this section before coupons for clarity.

-- 3.7) Final product image override
-- Keep this block after any other image-source blocks and before coupons.
UPDATE products SET image = 'https://images.pexels.com/photos/931151/pexels-photo-931151.jpeg?auto=compress&cs=tinysrgb&w=1200', images = '["https://images.pexels.com/photos/931151/pexels-photo-931151.jpeg?auto=compress&cs=tinysrgb&w=1200"]' WHERE id = 1;
UPDATE products SET image = 'https://images.pexels.com/photos/931177/pexels-photo-931177.jpeg?auto=compress&cs=tinysrgb&w=1200', images = '["https://images.pexels.com/photos/931177/pexels-photo-931177.jpeg?auto=compress&cs=tinysrgb&w=1200"]' WHERE id = 2;
UPDATE products SET image = 'https://images.pexels.com/photos/931180/pexels-photo-931180.jpeg?auto=compress&cs=tinysrgb&w=1200', images = '["https://images.pexels.com/photos/931180/pexels-photo-931180.jpeg?auto=compress&cs=tinysrgb&w=1200"]' WHERE id = 3;
UPDATE products SET image = 'https://images.pexels.com/photos/931181/pexels-photo-931181.jpeg?auto=compress&cs=tinysrgb&w=1200', images = '["https://images.pexels.com/photos/931181/pexels-photo-931181.jpeg?auto=compress&cs=tinysrgb&w=1200"]' WHERE id = 4;
UPDATE products SET image = 'https://images.pexels.com/photos/931182/pexels-photo-931182.jpeg?auto=compress&cs=tinysrgb&w=1200', images = '["https://images.pexels.com/photos/931182/pexels-photo-931182.jpeg?auto=compress&cs=tinysrgb&w=1200"]' WHERE id = 5;
UPDATE products SET image = 'https://images.pexels.com/photos/931183/pexels-photo-931183.jpeg?auto=compress&cs=tinysrgb&w=1200', images = '["https://images.pexels.com/photos/931183/pexels-photo-931183.jpeg?auto=compress&cs=tinysrgb&w=1200"]' WHERE id = 6;
UPDATE products SET image = 'https://images.pexels.com/photos/931184/pexels-photo-931184.jpeg?auto=compress&cs=tinysrgb&w=1200', images = '["https://images.pexels.com/photos/931184/pexels-photo-931184.jpeg?auto=compress&cs=tinysrgb&w=1200"]' WHERE id = 7;
UPDATE products SET image = 'https://images.pexels.com/photos/931185/pexels-photo-931185.jpeg?auto=compress&cs=tinysrgb&w=1200', images = '["https://images.pexels.com/photos/931185/pexels-photo-931185.jpeg?auto=compress&cs=tinysrgb&w=1200"]' WHERE id = 8;
UPDATE products SET image = 'https://images.pexels.com/photos/931186/pexels-photo-931186.jpeg?auto=compress&cs=tinysrgb&w=1200', images = '["https://images.pexels.com/photos/931186/pexels-photo-931186.jpeg?auto=compress&cs=tinysrgb&w=1200"]' WHERE id = 9;
UPDATE products SET image = 'https://images.pexels.com/photos/931187/pexels-photo-931187.jpeg?auto=compress&cs=tinysrgb&w=1200', images = '["https://images.pexels.com/photos/931187/pexels-photo-931187.jpeg?auto=compress&cs=tinysrgb&w=1200"]' WHERE id = 10;
UPDATE products SET image = 'https://images.pexels.com/photos/931188/pexels-photo-931188.jpeg?auto=compress&cs=tinysrgb&w=1200', images = '["https://images.pexels.com/photos/931188/pexels-photo-931188.jpeg?auto=compress&cs=tinysrgb&w=1200"]' WHERE id = 11;
UPDATE products SET image = 'https://images.pexels.com/photos/931189/pexels-photo-931189.jpeg?auto=compress&cs=tinysrgb&w=1200', images = '["https://images.pexels.com/photos/931189/pexels-photo-931189.jpeg?auto=compress&cs=tinysrgb&w=1200"]' WHERE id = 12;

-- 3.8) Coupons
INSERT INTO coupons (
    id, code, description, discount_type, discount_value, min_order_value, max_discount, usage_limit, used_count, start_date, end_date, is_active, created_at, updated_at
) VALUES
(1, 'WELCOME10', '10 percent off for new customers', 'percent', 10, 300000, 100000, 500, 0, NOW(), DATE_ADD(NOW(), INTERVAL 180 DAY), TRUE, NOW(), NOW()),
(2, 'FLOWER15', '15 percent off selected orders', 'percent', 15, 500000, 150000, 200, 0, NOW(), DATE_ADD(NOW(), INTERVAL 120 DAY), TRUE, NOW(), NOW()),
(3, 'SAVE50000', 'Fixed discount for large orders', 'fixed', 50000, 400000, NULL, 300, 0, NOW(), DATE_ADD(NOW(), INTERVAL 90 DAY), TRUE, NOW(), NOW());
