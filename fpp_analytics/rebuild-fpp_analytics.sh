#!/bin/bash
# Ensure the script exits on any error
set -e

# Check if container name is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <container_name>"
    exit 1
fi

CONTAINER_NAME=$1

# Function to safely remove a Docker container
remove_container_if_exists() {
    if docker ps -a --format '{{.Names}}' | grep -w -q $CONTAINER_NAME; then
        echo "Removing container $CONTAINER_NAME..."
        docker rm -f $CONTAINER_NAME
    else
        echo "Container $CONTAINER_NAME does not exist, skipping..."
    fi
}

# Function to safely remove a Docker image
remove_image_if_exists() {
    if [ -n "$(docker images -q $1)" ]; then
        echo "Removing image $1..."
        docker rmi -f $1
    else
        echo "Image $1 does not exist, skipping..."
    fi
}

# Step 1: Stop the specified container
echo "Stopping $CONTAINER_NAME container..."
docker-compose stop $CONTAINER_NAME

# Step 2: Remove the specified container if it exists
echo "Deleting $CONTAINER_NAME container..."
remove_container_if_exists

# Step 3: Identify and remove the image associated with the specified container
IMAGE_NAME=$(docker-compose config | grep -A 2 "$CONTAINER_NAME:" | grep 'image:' | awk '{print $2}')
if [ -n "$IMAGE_NAME" ]; then
    remove_image_if_exists "$IMAGE_NAME"
else
    echo "No explicit image name found in docker-compose.yml for $CONTAINER_NAME, checking for build context."
    BUILD_CONTEXT=$(docker-compose config | grep -A 2 "$CONTAINER_NAME:" | grep 'context:' | awk '{print $2}')
    if [ -n "$BUILD_CONTEXT" ]; then
        # Manually find and remove all images with the right context
        for DIGEST in $(docker images --filter=reference="${BUILD_CONTEXT}:*" --format "{{.ID}}"); do
            docker rmi -f $DIGEST
        done
    fi
fi

# Step 4: Prune build cache
echo "Pruning build cache..."
docker builder prune -f

# Step 5: Rebuild the specified container image without using cache
echo "Rebuilding $CONTAINER_NAME image..."
docker-compose build --no-cache $CONTAINER_NAME

# Step 6: Start the specified container
echo "Starting $CONTAINER_NAME container..."
doppler run -- docker-compose up -d $CONTAINER_NAME

echo "Done!"