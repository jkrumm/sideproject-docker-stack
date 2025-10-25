# sideproject-docker-stack

Docker Compose stack that runs my side projects and their infrastructure dependencies.

Doppler is used to manage secrets.

Cloudflare Tunnel is used to make the applications accessible.

Todo:
- [ ] SSL for MariaDB

## Services

Infrastructure:

- MariaDB
- Caddy

Projects:

- FFP Server (Bun Websocket Server)
- FPP Analytics (Flask API)
- Snow Finder (Deno API + React)
- Bun Email Api (Send ReactEmail using Resend)
- Plausible
- Photos (Caddy hosts static files)

<br />

Later there will probably be added more services like:

- Redis
- Watchtower

## VPS

- Hetzner ARM CAX21
- [Guide I used to secure VPS](https://maximorlov.com/4-essential-steps-to-securing-a-vps/)

## Local Development

1. Install Doppler CLI
2. Request access to the Doppler Dev project `sideproject-docker-stack`
3. Set up the Doppler project by running `doppler setup`
4. Set up the external pausible_proxy network `docker network create plausible_proxy`
5. Run `doppler run -- docker compose up -d`

## MariaDB Dump

You need to install mysql@8.4 or mysql-client@8.4 on MacOS. Because native authentication plugin was removed from mysql 9.0
Run the command line below to uninstall mysql@9.0.1

```shell
brew uninstall mysql
```

Run the command lines below to install mysql@8.4

```shell
brew install mysql@8.4
ln -s /opt/homebrew/opt/mysql@8.4 /opt/homebrew/opt/mysql
```

If you need to have mysql first in your PATH, run:

```shell
echo 'export PATH="/opt/homebrew/opt/mysql/bin:$PATH"' >> ~/.zshrc
```

```shell
/opt/homebrew/opt/mysql/bin/mysqldump \
--result-file=/Users/jkrumm/SDS_PROD_ROOT-2024_10_26_12_48_56-dump.sql \
--skip-lock-tables \
--skip-add-locks \
--no-tablespaces \
--create-options \
--column-statistics=0 \
--add-drop-table \
--user=root \
--host=5.75.178.196 \
--port=3306 \
-p \
free-planning-poker \
fpp_estimations fpp_events fpp_feature_flags fpp_page_views fpp_rooms fpp_users fpp_votes
```

### Backup MariaDB

To trigger a backup of the MariaDB database the container needs to be running.

```shell
./mariadb_backup/trigger-backup.sh
```

Backups will then be stored in the `mariadb_backups/backups` directory.

### Download MariaDB Backup

Modify and run the following command to download the backup called `backup` from the `mariadb_backups/backups` directory:

```shell
scp -r root@{ip}:/home/jkrumm/sideproject-docker-stack/mariadb_backup/backups /Users/jkrumm/Downloads
```
or on my Mac:
```shell
scp -r root@{ip}:/home/jkrumm/sideproject-docker-stack/mariadb_backup/backups /Users/johannes.krumm/Downloads
```

### Restore MariaDB

Run the following command to restore the backup called `restore` in the `mariadb_backups/restore` directory:

```shell
./mariadb_backups/restore.sh
```

## Other Notes

### Rebuild fpp-analytics or ffp-server

Just run:

```shell
./fpp_analytics/rebuild-fpp_analytics.sh fpp-analytics
```

Steps explained:

1. **Stop the Container**: The script stops the `fpp-analytics` container.
2. **Remove the Container**: Any existing `fpp-analytics` container is removed.
3. **Remove the Image**: The associated Docker image is identified and removed.
4. **Prune Build Cache**: Docker's build cache is pruned to avoid using any cached layers.
5. **Rebuild the Image**: The `fpp-analytics` image is rebuilt from scratch with no cache.
6. **Start the Container**: The freshly built `fpp-analytics` container is started.
