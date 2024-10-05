#!/bin/bash

echo "Running mariadb-backup.sh"
echo "DB_READ_PW: $DB_READ_PW"

/backup_dir="/tmp/mysql_backup"
mkdir -p ${backup_dir}

# Perform the backup
#backup_file="${backup_dir}/all-databases-$(date +\%F).sql"
#mysqldump -u read -p$DB_READ_PW --all-databases > ${backup_file}