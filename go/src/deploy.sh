#!/bin/bash

SERVER=""
REMOTE_PATH="~/transferred"  
FRONTEND_IMAGE="frontend:latest" #Currently must match what is in the compose file you are using
BACKEND_IMAGE="backend:latest" #Currently must match what is in the compose file you are using

# #Cleanup Docker 
# # Issues with running this... also should use use docker ps and images -a to verify none left... maybe next time I work on this script, for now just run on server with manual ssh
echo "🧹 Cleaning Docker (containers and images) on server"
ssh -A $SERVER "bash ~/docker_cleanup.sh"

# Cleanup transferred folder if it exists & create fresh one
echo "🧹 Cleaning up old files on server... and creating new empty dirs"
ssh -A $SERVER "rm -rf $REMOTE_PATH && mkdir -p $REMOTE_PATH/backend"

# Build images
echo "🚀 Building Docker images..."
docker build -f ./frontend/Dockerfile --build-arg VITE_API_URL=http://localhost:4500 -t $FRONTEND_IMAGE ./frontend
docker build -f ./backend/Dockerfile -t $BACKEND_IMAGE ./backend

# Save images to tar files
echo "💾 Saving Docker images..."
docker save -o frontend.tar $FRONTEND_IMAGE
docker save -o backend.tar $BACKEND_IMAGE

# Transfer images, yaml/yml, and env vars
echo "📤 Transferring files to server..."
scp \
    compose_deploy.yaml \
    traefik.yml \
    prometheus.yml \
    ./backend/.env_prod \
    docker_cleanup.sh \
    frontend.tar \
    backend.tar \
    "$SERVER:$REMOTE_PATH/"

# Rename compose_deploy so we dont have to use the -f flag for down/up
ssh -A $SERVER "mv $REMOTE_PATH/compose_deploy.yaml $REMOTE_PATH/compose.yaml"

ssh -A $SERVER "docker network create traefik-network"

# Load Docker images on the server before running compose
echo "🐳 Loading Docker images on server..."
ssh -A $SERVER << EOF
  docker load -i $REMOTE_PATH/frontend.tar
  docker load -i $REMOTE_PATH/backend.tar
  docker compose -f $REMOTE_PATH/compose.yaml up -d
EOF

# Optional Cleanup on Server
# echo "🧹 Cleaning up tar files on server..."
# ssh -A $SERVER "rm -rf $REMOTE_PATH/frontend.tar $REMOTE_PATH/backend.tar"

# Cleanup Local Tar Files
echo "🧹 Back up local tar files if none exist from today"
backup_tars ./images/frontend.tar  ~/backup/pk_projName/
backup_tars backend.tar ~/backup/talktop.us/pk_projName/

echo "✅ Deployment complete!"
