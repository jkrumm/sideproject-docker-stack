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
### Rebuild fpp-analytics
Just run:
``` shell
./fpp_analytics/rebuild-fpp_analytics.sh
```
Steps explained:
1. Stop the fpp-analytics container by running `docker-compose stop fpp-analytics`
2. Delete the container by running `docker rm fpp-analytics`
3. Delete the fpp-analytics image by running `docker rmi sideproject-docker-stack-fpp-analytics`
4. Prune build cache by running `docker builder prune -f`
5. Start the fpp-analytics container by running `doppler run -- docker-compose up -d fpp-analytics`