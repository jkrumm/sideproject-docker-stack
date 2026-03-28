#!/bin/bash
# Daily MariaDB backup for FPP + Uptime Kuma push heartbeat
# Cron: 0 3 * * * /home/jkrumm/sideproject-docker-stack/mariadb_backup/run-backup.sh

set -e

LOG=/home/jkrumm/fpp-mariadb-backup.log
PUSH_URL=$(doppler secrets get FPP_DB_BACKUP_PUSH_URL --plain -p sideproject-docker-stack -c prod 2>/dev/null)

echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] Starting backup" >> "$LOG"

docker exec mariadb bash ./backup.sh >> "$LOG" 2>&1

echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] Backup complete. Pinging Uptime Kuma." >> "$LOG"

if [ -n "$PUSH_URL" ]; then
  curl -fsS "$PUSH_URL" > /dev/null
fi
