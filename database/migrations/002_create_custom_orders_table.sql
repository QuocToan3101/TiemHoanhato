-- Migration: Create custom_orders table for the custom bouquet ordering flow
-- Run this SQL on your database to support custom orders

CREATE TABLE IF NOT EXISTS custom_orders (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL,
  flower_type VARCHAR(128) NOT NULL,
  main_flower VARCHAR(128) NOT NULL,
  support_flower VARCHAR(128) NOT NULL,
  quantity VARCHAR(64) NOT NULL,
  wrap_paper VARCHAR(128) NOT NULL,
  color_tone VARCHAR(64) NOT NULL,
  accessories VARCHAR(512),
  occasion VARCHAR(128) NOT NULL,
  budget DECIMAL(15,2) NOT NULL,
  estimated_price DECIMAL(15,2) NOT NULL,
  customer_note TEXT,
  status VARCHAR(32) DEFAULT 'pending', -- pending, confirmed, processing, completed, cancelled
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
