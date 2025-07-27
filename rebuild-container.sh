#!/bin/bash

# Check if a container name was provided as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <fpp-server|fpp-analytics|snow-finder|bun-email-api>"
  exit 1
fi

containerName="$1"

# Validate container name
if [ "$containerName" != "fpp-server" ] && [ "$containerName" != "fpp-analytics" ] && [ "$containerName" != "snow-finder" ] && [ "$containerName" != "bun-email-api" ]; then
  echo "Invalid container name. Only 'fpp-server', 'fpp-analytics', 'snow-finder', or 'bun-email-api' are allowed."
  exit 1
fi

# Stop the container
echo "Stopping container ${containerName} if running..."
doppler run -- docker compose stop $containerName

# Remove the container
echo "Removing container ${containerName}..."
doppler run -- docker compose rm -f $containerName

# Define the full image name
fullImageName="sideproject-docker-stack-${containerName}"

# Get the image ID for the container
image=$(docker images -q ${fullImageName})

# Remove the image if it exists
if [ -n "$image" ]; then
  echo "Removing image associated with ${fullImageName}..."
  docker rmi -f $image
else
  echo "No image found for ${fullImageName}."
fi

# Remove volumes associated with the container explicitly
case "$containerName" in
  "fpp-analytics")
    volumeName="sideproject-docker-stack_fpp_analytics_data"
    ;;
  "fpp-server")
    volumeName="sideproject-docker-stack_fpp_server_data"
    ;;
  "snow-finder")
    volumeName="sideproject-docker-stack_snow_finder_data"
    ;;
  "bun-email-api")
    volumeName="sideproject-docker-stack_bun_email_api_data"
    ;;
esac

if docker volume inspect $volumeName > /dev/null 2>&1; then
  echo "Removing volume ${volumeName}..."
  docker volume rm $volumeName
else
  echo "No volume found for ${volumeName}."
fi

# Remove all unused volumes, networks, images (both dangling and unreferenced), and optionally, stopped containers.
echo "Cleaning up dangling resources..."
docker system prune -f

# Rebuild the container without cache
echo "Rebuilding container ${containerName}..."
doppler run -- docker compose build --no-cache $containerName

# Bring the container up in detached mode
echo "Starting container ${containerName}..."
doppler run -- docker compose up -d $containerName

echo "Done!"