#!/bin/bash

echo "Running backup.sh"
docker exec -it mariadb bash -c "./backup.sh"
echo "backup.sh completed"