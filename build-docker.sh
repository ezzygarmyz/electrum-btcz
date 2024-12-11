#!/bin/bash

IMAGE_NAME="electrumz-app"
CONTAINER_NAME="electrum-running-app"
DIST_DIR="./dist"


if ! command -v docker &> /dev/null; then
    echo "Docker is not installed."
fi

echo "Checking if dist directory exists..."
if [ -d "$DIST_DIR" ]; then
    echo "Removing existing dist directory..."
    sudo rm -rf "$DIST_DIR"
fi


echo "Building Docker image..."
sudo docker build -t $IMAGE_NAME .

if [ $? -ne 0 ]; then
    echo "ERROR: Docker build failed."
    exit 1
fi

echo "Creating Docker container..."
sudo docker create --name $CONTAINER_NAME $IMAGE_NAME

if [ $? -ne 0 ]; then
    echo "ERROR: Docker container creation failed."
    exit 1
fi

echo "Copying dist directory from the container..."
sudo docker cp $CONTAINER_NAME:/app/dist $DIST_DIR

if [ $? -ne 0 ]; then
    echo "ERROR: Failed to copy dist directory."
    exit 1
fi


echo "Removing Docker container..."
sudo docker rm $CONTAINER_NAME

echo "Build and copy process completed successfully!"
