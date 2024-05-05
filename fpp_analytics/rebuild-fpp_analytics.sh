#!/bin/bash

# Step 1: Stop fpp-analytics container
echo "Stopping fpp-analytics container..."
docker-compose stop fpp-analytics

# Step 2: Delete fpp-analytics container
echo "Deleting fpp-analytics container..."
docker rm fpp-analytics

# Step 3: Delete sideproject-docker-stack-fpp-analytics image
echo "Deleting sideproject-docker-stack-fpp-analytics image..."
docker rmi sideproject-docker-stack-fpp-analytics

# Step 4: Prune build cache
echo "Pruning build cache..."
docker builder prune -f

# Step 5: Start fpp-analytics container
echo "Starting fpp-analytics container..."
doppler run -- docker-compose up -d fpp-analytics

echo "Done!"