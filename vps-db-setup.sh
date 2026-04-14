#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

if ! command -v mysql >/dev/null 2>&1; then
  apt-get update
  apt-get install -y mysql-server
fi

systemctl enable mysql || true
systemctl start mysql || true

mysql -e "CREATE DATABASE IF NOT EXISTS flowerStore CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
mysql -e "CREATE USER IF NOT EXISTS 'FlowerStore'@'localhost' IDENTIFIED BY '12345';"
mysql -e "ALTER USER 'FlowerStore'@'localhost' IDENTIFIED BY '12345';"
mysql -e "GRANT ALL PRIVILEGES ON flowerStore.* TO 'FlowerStore'@'localhost'; FLUSH PRIVILEGES;"

mysql flowerStore < /tmp/database.sql

mysql -e "SELECT COUNT(*) AS tables_count FROM information_schema.tables WHERE table_schema='flowerStore';"
