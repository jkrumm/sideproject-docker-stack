# sideproject-docker-stack
Docker Compose stack that runs my sideprojects and their infrastructure dependencies.

## Services
- MariaDB
- InfluxDB
- Telegraf
- Grafana
- Watchtower
- Yacht
- Infisical

Later on I will add more services like:
- Uptime Kuma
- Nginx (For own static sites)
- [Simple Logging Service](https://github.com/jkrumm/simple-logging-service)
- Redis
- Keep

There will also come a read replica for MariaDB

## VPS
- [Hetzner ARM CAX21](https://www.hetzner.com/cloud)
- [Guide I used to secure VPS](https://maximorlov.com/4-essential-steps-to-securing-a-vps/)