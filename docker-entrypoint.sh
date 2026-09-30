#!/bin/bash
set -e

echo "=== CIVentral Backend Container Starting ==="

# Check if DB_HOST is set and setup_all.sql exists
if [ -n "$DB_HOST" ] && [ -f "/var/www/html/database/setup_all.sql" ]; then
    DB_PORT="${DB_PORT:-3306}"
    DB_USER="${DB_USER:-root}"
    echo "[INFO] Waiting for MySQL database at ${DB_HOST}:${DB_PORT}..."

    # Use mysqladmin ping to wait until MySQL is accessible (up to 30 attempts, 60s max)
    RETRIES=30
    until mysqladmin ping -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" ${DB_PASSWORD:+-p"$DB_PASSWORD"} --silent || [ $RETRIES -eq 0 ]; do
        echo "[INFO] Waiting for MySQL to be ready ($RETRIES retries left)..."
        sleep 2
        RETRIES=$((RETRIES-1))
    done

    if [ $RETRIES -gt 0 ]; then
        echo "[OK] MySQL is reachable. Running auto-migration (setup_all.sql)..."
        mysql -h "$DB_HOST" -P "${DB_PORT:-3306}" -u "$DB_USER" -p"$DB_PASSWORD" < /var/www/html/database/setup_all.sql
        echo "[OK] Database auto-migration completed successfully."
    else
        echo "[WARN] MySQL connection timed out. Skipping entrypoint auto-migration."
    fi
else
    echo "[INFO] DB_HOST not specified or setup_all.sql missing. Skipping auto-migration."
fi

echo "=== Starting Apache Web Server ==="
exec apache2-foreground
