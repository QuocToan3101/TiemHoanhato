-- Cart schema migration: from legacy `cart` table to `carts` + `cart_items`
-- Run this on existing database before deploying new cart code.

START TRANSACTION;

CREATE TABLE IF NOT EXISTS carts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_user_cart (user_id),
    INDEX idx_carts_user_id (user_id),
    CONSTRAINT fk_carts_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS cart_items (
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
    CONSTRAINT fk_cart_items_cart FOREIGN KEY (cart_id) REFERENCES carts(id) ON DELETE CASCADE,
    CONSTRAINT fk_cart_items_product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Migrate existing user carts if legacy table exists.
INSERT INTO carts (user_id, is_active)
SELECT DISTINCT c.user_id, TRUE
FROM cart c
LEFT JOIN carts nc ON nc.user_id = c.user_id
WHERE nc.id IS NULL;

INSERT INTO cart_items (cart_id, product_id, quantity, price)
SELECT nc.id, c.product_id, c.quantity,
       CASE
           WHEN p.sale_price IS NOT NULL AND p.sale_price > 0 THEN p.sale_price
           ELSE p.price
       END AS item_price
FROM cart c
JOIN carts nc ON nc.user_id = c.user_id
JOIN products p ON p.id = c.product_id
LEFT JOIN cart_items ci ON ci.cart_id = nc.id AND ci.product_id = c.product_id
WHERE ci.id IS NULL;

COMMIT;
