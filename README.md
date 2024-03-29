# sideproject-docker-stack
Docker Compose stack that runs my side projects and their infrastructure dependencies.

Doppler is used to manage secrets.

## Services
- MariaDB
- InfluxDB
- Telegraf
- Grafana

Later on I will probably add more services like:
- Uptime Kuma
- Nginx (For own static sites)
- [Simple Logging Service](https://github.com/jkrumm/simple-logging-service)
- Redis
- Keep
- Watchtower

There will also come a read replica for MariaDB

## VPS
- Hetzner ARM CAX21
- [Guide I used to secure VPS](https://maximorlov.com/4-essential-steps-to-securing-a-vps/)