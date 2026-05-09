-- Migration: Create shipping related tables
-- Run this SQL on your database to add shipping support

CREATE TABLE IF NOT EXISTS delivery_zone (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(128) NOT NULL,
  max_km DOUBLE NOT NULL,
  active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS shipping_fee_rule (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(128) NOT NULL,
  base_fee DECIMAL(10,2) NOT NULL DEFAULT 0.0,
  per_km_fee DECIMAL(10,2) NOT NULL DEFAULT 0.0,
  free_over_amount DECIMAL(10,2) DEFAULT NULL,
  peak_start_hour INT DEFAULT NULL,
  peak_end_hour INT DEFAULT NULL,
  peak_surcharge DECIMAL(10,2) DEFAULT 0.0,
  active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS shipping_address (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id BIGINT NULL,
  formatted_address VARCHAR(512) NOT NULL,
  latitude DOUBLE NOT NULL,
  longitude DOUBLE NOT NULL,
  place_id VARCHAR(256) NOT NULL,
  note VARCHAR(512),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Delivery history: track shipping lookups and results for audit and analytics
CREATE TABLE IF NOT EXISTS delivery_history (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  place_id VARCHAR(256) NULL,
  formatted_address VARCHAR(512) NULL,
  latitude DOUBLE NULL,
  longitude DOUBLE NULL,
  distance_km DOUBLE NULL,
  fee DECIMAL(10,2) NULL,
  ghn_fee DECIMAL(10,2) NULL,
  deliverable BOOLEAN NULL,
  shipping_status VARCHAR(32) NULL,
  address_status VARCHAR(32) NULL,
  reason VARCHAR(255) NULL,
  client_ip VARCHAR(64) NULL,
  user_agent VARCHAR(512) NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes to optimize lookups
CREATE INDEX IF NOT EXISTS idx_shipping_address_placeid ON shipping_address(place_id);
CREATE INDEX IF NOT EXISTS idx_delivery_history_placeid ON delivery_history(place_id);
CREATE INDEX IF NOT EXISTS idx_delivery_history_created_at ON delivery_history(created_at);
CREATE INDEX IF NOT EXISTS idx_delivery_history_status ON delivery_history(shipping_status);
