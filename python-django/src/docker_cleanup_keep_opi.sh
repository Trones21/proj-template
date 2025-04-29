#!/bin/bash

# opi = Other peoples images (notice that we are only removing the frontend and backend images)

# Stop all running containers
echo "Stopping all running containers..."
docker stop $(docker ps -q)

# Remove all containers (stopped and running)
echo "Removing all containers..."
docker rm $(docker ps -aq)

# Remove all images (forcefully, to avoid conflicts)
echo "Removing all images..."
docker rmi frontend:latest
docker rmi backend:latest

# Remove dangling volumes (optional, but cleans up unused volumes)
echo "Removing dangling volumes..."
docker volume prune -f

# Remove unused networks (optional)
echo "Removing unused networks..."
docker network prune -f

echo "Docker cleanup completed."