#!/bin/bash

set -e

echo "Running MariaDB restore"

# Change to the directory where the script is located
cd "$(dirname "$0")"

echo "Stopping existing containers"
doppler run -- docker compose down

RESTORE_DIR=$(pwd)/restore/restore

if [ ! -d $RESTORE_DIR ]; then
  echo "Backup directory $RESTORE_DIR does not exist. Exiting..."
  exit 1
fi

echo "Emptying the database"
docker run --rm -v sideproject-docker-stack_mariadb_data:/var/lib/mysql alpine sh -c "rm -rf /var/lib/mysql/*"

echo "Restoring the database"
docker run --rm -v sideproject-docker-stack_mariadb_data:/var/lib/mysql -v "$RESTORE_DIR":/restore alpine sh -c "cp -r /restore/* /var/lib/mysql/"

# Uncomment this line if you encounter permission issues
#docker run --rm -v sideproject-docker-stack_mariadb_data:/var/lib/mysql alpine sh -c "chown -R 999:999 /var/lib/mysql"

echo "Deleting the restore directory to prevent accidental reuse"
rm -rf "$RESTORE_DIR"

echo "Starting containers"
doppler run -- docker compose up -d

echo "MariaDB restore completed"