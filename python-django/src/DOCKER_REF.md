#### Docker

##### Build, Transfer, Run a Single Docker Container

**Normally we use docker buold_and_deploy.sh... but this just gives us an idea of the steps**

```bash
docker build
-t <image-name>:<tag> #-t name and tag for the image
. # . : The build context is the directory whose files Docker can access during the build.

#if you want to see the images created, run
docker images
```

###### Run Locally

```bash
Run
docker run -d \     # -d Runs the container in detached mode.
-p 8080:80     \    # -p maps the ports <machinePort>:<containerPort>
--name <container-name> <image-name>:<tag>

docker ps # Verify it is running

# Debugging
docker logs <container-name> #Check the logs
docker inspect <container-name> | grep -i "port" # inspect port mappings

# Cleanup
docker stop <container-name>
docker rm <container-name>
```

###### Run on Server

```bash
# Now we need to create the .tar file
docker save -o ./dist/whatever.tar  <image-name>:<tag>

# Transfer image
scp whatever.tar anotherArchive.tar $SERVER:$REMOTE_PATH

# Then on server
docker load < /path/to/destination/backend.tar
docker run -d --name backend-container -p 8080:8080 backend:init

```

##### Providing Environment vars

Either manually with -e or pass a .env file

```bash
docker run \ -e <key>=<value> \  # pass environment variable, m use one -e per env var

# FOR THIS PROJECT WE ACTUALLY LOAD OUR ENV VIA BASH, SO WE WILL NEED TO PULL THE ACTUAL VALUES INTO A FILE AFTER SETTING
source ~/env_setup/prod_backend.sh #load env vars from source of truth
env | grep -E 'DB_HOST|DB_PORT|DB_USER|DB_PASS|DB_NAME|BREVO_API_KEY' > .env_prod # can be named anything
docker run --env-file .env_prod

```

- Script to generate .env_prod `./generate_dot_env_prod.sh`
- General Reminder: the Env file must live in a place that the docker build context has access to

#### to stop and remove all containers and images

```bash
docker rm $(docker ps -aq)
docker rmi $(docker images -q)
```
