#!/bin/bash

echo "Running init-maria-db.sh"
docker exec -it mariadb bash -c "/docker-entrypoint-initdb.d/init-maria-db.sh"
echo "init-maria-db.sh completed"