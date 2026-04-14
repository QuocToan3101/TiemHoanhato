#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

retry_apt() {
  local attempts=20
  local wait_seconds=15
  local count=1

  while true; do
    if "$@"; then
      return 0
    fi

    if [ "$count" -ge "$attempts" ]; then
      echo "APT command failed after ${attempts} attempts: $*"
      return 1
    fi

    echo "APT is busy or failed (attempt ${count}/${attempts}). Retrying in ${wait_seconds}s..."
    sleep "$wait_seconds"
    count=$((count + 1))
  done
}

if ! command -v mysql >/dev/null 2>&1; then
  retry_apt apt-get update
  retry_apt apt-get install -y mysql-server
fi

systemctl enable mysql || true
systemctl start mysql || true

mysql -e "CREATE DATABASE IF NOT EXISTS flowerStore CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
mysql -e "CREATE USER IF NOT EXISTS 'FlowerStore'@'localhost' IDENTIFIED BY '12345';"
mysql -e "ALTER USER 'FlowerStore'@'localhost' IDENTIFIED BY '12345';"
mysql -e "GRANT ALL PRIVILEGES ON flowerStore.* TO 'FlowerStore'@'localhost'; FLUSH PRIVILEGES;"

mysql flowerStore < /tmp/database.sql

mysql -e "SELECT COUNT(*) AS tables_count FROM information_schema.tables WHERE table_schema='flowerStore';"
