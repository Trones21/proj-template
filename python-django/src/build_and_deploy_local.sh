# This will build the containers and run them locally
# Connect to local postgres 

# NOTE:  Ensure that /etc/hosts has an entry for 127.0.0.1 frontend.local
# sudo nano/etc/hosts 

#Ensure backend picks up the local env vars 
source ~/env_setup/pk_projName/local_backend.sh


FRONTEND_IMAGE="frontend:latest"
BACKEND_IMAGE="backend:latest"

# Build images
docker build -f ./frontend/Dockerfile --build-arg VITE_API_URL=http://localhost:4500 -t $FRONTEND_IMAGE ./frontend
docker build -f ./backend/Dockerfile -t $BACKEND_IMAGE ./backend

# Save images
#  not really necessary -- the only reason i do that in the manual deploy is to transfer them over 

docker compose -f ./compose_pre_built.yaml up -d
echo "docker compose -f ./compose_pre_built.yaml up -d"

## This is what it would look like if you wanted to run all of them manually, but you run nto difficulties unless you do a full teardown of all images and containers each time 
## its good to have it as a reference though
# # Frontend container
# docker run -d \
#   -p 9000:80 \
#   --name frontend_local \
#   -l "traefik.enable=true" \
#   -l "traefik.http.routers.frontend.rule=Host(\`frontend.local\`)" \
#   -l "traefik.http.services.frontend.loadbalancer.server.port=80" \
#   $FRONTEND_IMAGE

# # Backend container
# docker run -d \
#   -p 4500:8080 \
#   --name backend_local \
#   -l "traefik.enable=true" \
#   -l "traefik.http.routers.backend.rule=PathPrefix(\`/api\`)" \
#   -l "traefik.http.services.backend.loadbalancer.server.port=8080" \
#   $BACKEND_IMAGE
# docker run -d -p 4500:8080 --name backend_local -l "traefik.enable=true" -l "traefik.http.routers.backend.rule=PathPrefix(\`/api\`)" -l "traefik.http.services.backend.loadbalancer.server.port=8080" backend:local_test

# docker run -d \
#   --name traefik \
#   -p 80:80 \
#   -p 443:443 \
#   -p 8080:8080 \
#   -v /var/run/docker.sock:/var/run/docker.sock \
#   -v $(pwd)/traefik.yml:/etc/traefik/traefik.yml \
#   traefik:v2.10
