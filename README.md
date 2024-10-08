# sideproject-docker-stack
Docker Compose stack that runs my side projects and their infrastructure dependencies.

Doppler is used to manage secrets.

Todo:
- [ ] Backup the MariaDB database
- [ ] SSL for MariaDB
- [ ] Setup GitHub Actions to deploy the stack
- [ ] Retention policy for InfluxDB

Nice to have:
- [ ] Read replica for MariaDB

## Services
Infrastructure:
- MariaDB
- InfluxDB
- Telegraf
- Grafana

Projects:
- FFP Server (Bun Websocket Server)
- FPP Analytics (Flask API)

<br />

Later there will probably be added more services like:
- Uptime Kuma
- Caddy
- [Simple Logging Service](https://github.com/jkrumm/simple-logging-service)
- Redis
- Keep
- Watchtower

## VPS
- Hetzner ARM CAX21
- [Guide I used to secure VPS](https://maximorlov.com/4-essential-steps-to-securing-a-vps/)

## Local Development
1. Install Doppler CLI
2. Request access to the Doppler Dev project `sideproject-docker-stack`
3. Set up the Doppler project by running `doppler setup`
4. Run `doppler run -- docker-compose up -d`

## Other Notes
### Rebuild fpp-analytics or ffp-server
Just run:
``` shell
./fpp_analytics/rebuild-fpp_analytics.sh fpp-analytics
```
Steps explained:
1. **Stop the Container**: The script stops the `fpp-analytics` container.
2. **Remove the Container**: Any existing `fpp-analytics` container is removed.
3. **Remove the Image**: The associated Docker image is identified and removed.
4. **Prune Build Cache**: Docker's build cache is pruned to avoid using any cached layers.
5. **Rebuild the Image**: The `fpp-analytics` image is rebuilt from scratch with no cache.
6. **Start the Container**: The freshly built `fpp-analytics` container is started.

### Backup MariaDB
To trigger a backup of the MariaDB database the container needs to be running.
``` shell
./mariadb_backups/trigger-backup.sh
```
Backups will then be stored in the `mariadb_backups/backups` directory.

### Restore MariaDB
To restore a MariaDB backup the container needs to be running.
``` shell
./mariadb_backups/restore.sh
```
Then automatically the backup called `restore` in the `mariadb_backups/restore`directory will be restored.