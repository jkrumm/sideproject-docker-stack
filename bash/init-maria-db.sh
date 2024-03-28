#!/bin/bash

set -e

echo "Waiting for mariadb to be ready..."

#/wait-for-it.sh mariadb:3306 --timeout=0 --strict --

echo "Upserting database and users..."

mariadb -uroot -p"$MYSQL_ROOT_PASSWORD" <<-EOSQL
CREATE USER IF NOT EXISTS 'db-read'@'%' IDENTIFIED BY '${DB_READ_PW}';
GRANT SELECT ON *.* TO 'db-read'@'%';

CREATE DATABASE IF NOT EXISTS \`free-planning-poker\` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;

CREATE USER IF NOT EXISTS 'fpp-read'@'%' IDENTIFIED BY '${DB_FPP_READ_PW}';
GRANT SELECT ON \`free-planning-poker\`.* TO 'fpp-read'@'%';

CREATE USER IF NOT EXISTS 'fpp-write'@'%' IDENTIFIED BY '${DB_FPP_WRITE_PW}';
GRANT SELECT, INSERT, UPDATE, DELETE ON \`free-planning-poker\`.* TO 'fpp-write'@'%';
FLUSH PRIVILEGES;
EOSQL

echo "Database and users upserted."