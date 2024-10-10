#!/bin/bash

set -e

echo "Running MariaDB backup"

if [ -z "$DB_READ_PW" ]; then
  echo "DB_READ_PW is not set. Exiting..."
  exit 1
fi

# delete the backup if for this day already exists
rm -rf /backups/backup_$(date +%Y-%m-%d)

BACKUP_DIR=/backups/backup_$(date +%Y-%m-%d)

mkdir -p "$BACKUP_DIR"

/usr/bin/mariadb-backup --backup --target-dir="$BACKUP_DIR" --user=read --password="$DB_READ_PW" --host=mariadb

/usr/bin/mariadb-backup --prepare --target-dir="$BACKUP_DIR"