#!/bin/bash

set -e

echo "Upserting database and users..."

if [ -z "$MYSQL_ROOT_PASSWORD" ]; then
  echo "MYSQL_ROOT_PASSWORD is not set. Exiting..."
  exit 1
fi

if [ -z "$DB_READ_PW" ]; then
  echo "DB_READ_PW is not set. Exiting..."
  exit 1
fi

if [ -z "$DB_FPP_PW" ]; then
  echo "DB_FPP_PW is not set. Exiting..."
  exit 1
fi

mariadb -uroot -p"$MYSQL_ROOT_PASSWORD" <<-EOSQL
CREATE USER IF NOT EXISTS 'read'@'%' IDENTIFIED BY '${DB_READ_PW}';
ALTER USER 'read'@'%' IDENTIFIED BY '${DB_READ_PW}';
GRANT SELECT, SHOW VIEW, TRIGGER, LOCK TABLES, EVENT, RELOAD, PROCESS ON *.* TO 'read'@'%';

CREATE DATABASE IF NOT EXISTS \`free-planning-poker\` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;

CREATE USER IF NOT EXISTS 'fpp'@'%' IDENTIFIED BY '${DB_FPP_PW}';
ALTER USER 'fpp'@'%' IDENTIFIED BY '${DB_FPP_PW}';
GRANT SELECT, SHOW VIEW, TRIGGER, LOCK TABLES, EVENT, INSERT, UPDATE, DELETE, CREATE ON \`free-planning-poker\`.* TO 'fpp'@'%';

CREATE USER IF NOT EXISTS 'healthcheck'@'%' IDENTIFIED BY '${DB_HEALTHCHECK_PW}';
ALTER USER 'healthcheck'@'%' IDENTIFIED BY '${DB_HEALTHCHECK_PW}';
GRANT SELECT, PROCESS ON *.* TO 'healthcheck'@'%';

FLUSH PRIVILEGES;
EOSQL

echo "Database and users upserted."