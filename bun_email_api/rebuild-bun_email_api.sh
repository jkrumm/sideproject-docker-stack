#!/bin/bash

# Step 1: Stop bun-email-api container
echo "Stopping bun-email-api container..."
docker-compose stop bun-email-api

# Step 2: Delete bun-email-api container
echo "Deleting bun-email-api container..."
docker rm bun-email-api

# Step 3: Delete sideproject-docker-stack-bun-email-api image
echo "Deleting sideproject-docker-stack-bun-email-api image..."
docker rmi sideproject-docker-stack-bun-email-api

# Step 4: Prune build cache
echo "Pruning build cache..."
docker builder prune -f

# Step 5: Start bun-email-api container
echo "Starting bun-email-api container..."
doppler run -- docker-compose up -d bun-email-api

echo "Done!"