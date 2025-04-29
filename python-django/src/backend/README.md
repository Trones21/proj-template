### Project Structure

- **backend/** — Django backend starter with:

  - `manage.py` — Django CLI entry point
  - `api`
    - `migrations/` — Database migrations
    - `fixtures/` - Fixtures (also can be used by test runner)
    - `models/` — Models (Single file per entity - Model, Serializer, Viewset)
  - `your_project/` — Django project settings and configuration
    - `static/` — Static file directory
  - `requirements.txt` — Python dependencies list
  - Dockerfile and supporting scripts
  - `README.md` - BAckend specific readme

- **request_flows/** — [noCRUD](https://github.com/Trones21/noCRUD/tree/main/python) - Lightweight Python client for:

  - Simulating API requests
  - Performing smoke tests and validation flows
  - Utilities for authentication and JSON handling

- **\_top_level_docs/** — Docs starter:

  - `USEFUL.md` — General project tips and links
  - `DOCKER_REF.md` - Normally we use docker build_and_deploy.sh... but this just gives us an idea of the steps

- **\_images/** — Placeholder for architecture diagrams or visual assets

- **frontend/** — Placeholder (you'll manually create a frontend app, e.g., Quasar or React)

### Deployment and Environment Management

- Local build and deploy scripts:
  - `build_and_deploy_local.sh`
  - `compose_local.yaml`
- Production deploy scripts:
  - `deploy.sh`
  - `compose_deploy.yaml`
- Environment setup:
  - `~/env_setup/<your_project_name>/local_backend.sh`
  - `~/env_setup/<your_project_name>/prod_backend.sh`

### Other Utilities

- `sandbox.sh` — Quick testing script
- `backup_image.sh` — Docker image backup
- `docker_cleanup.sh` and `docker_cleanup_keep_opi.sh` — Cleanup helpers
- `.dockerignore`, `.gitignore`, and configuration examples for Traefik and Prometheus (under `no-modification-before-copy/`)

---

## To-Do After Generation

Open Your Project Folder:

```bash
cd ~/Documents/git_repos/<your_project_name>
# or whatever you passed to the -d flag
```

✅ Set up your environment variables:

```bash
nano ~/env_setup/<your_project_name>/local_backend.sh
# When ready to deploy, update prod_backend.sh
```

✅ Apply environment variables

```bash
source ~/env_setup/<your_project_name>/local_backend.sh
```

✅ Install Python dependencies:

```bash
cd backend
pip install -r requirements.txt
```

**Tip: If requirements.txt doesnt exist, you can always use `pipreqs`: `pip install pipreqs` then `pipreqs ./`(when pwd is root of project)**

### Local DB Setup

Install request flow dependencies (since the create_db script lives there):

```bash
cd ../request_flows
pip install -r requirements.txt
```

[Install Postgres (if not already installed)](https://www.postgresql.org/download/linux/ubuntu/)

✅ Create the database

```bash
python ~/path-to-project/request_flows/create_db.py
```

✅ Make and apply Django migrations:

```bash
python manage.py makemigrations
python manage.py migrate
```

✅ Create a Django superuser:

```bash
python manage.py createsuperuser
```

✅ Run the Server 🚀

```bash
python manage.py runserver
```

### Optional/Later:

Update `deploy.sh`:

- Set your SSH login credentials for deployment.

Set up the frontend:

- Use [Quasar CLI](https://quasar.dev/start/installation) or your preferred frontend stack.

---

## Basic Structure

I keep the same basic structure for all my applications. Note that Quasar is not currently setup by this script

```txt
+---------------------+
|  Reverse Proxy      | (Container 1: Traefik)
|   - / -> Frontend   |
|   - /api -> Backend |
+---------------------+
        |           |
+----------------+   +----------------+
| Frontend        |   | Backend        |
| Quasar Files    |   | Django         |
| Running on Nginx|   |                |
+----------------+   +----------------+

```

### Deployment

Current process is build the containers locally (with prod settings) and copy to server

- Remember to backup RDS and migrate(update db schema)!! This is integrated into deployment

This is all in deploy.sh/build_and_deploy.sh.. but here is the general process. Look to the frontend and backend readmes for deep guidance on their containers.

#### On Dev Machine

```bash
docker-compose build

docker save -o frontend.tar frontend:latest
docker save -o backend.tar backend:latest

scp frontend.tar backend.tar user@server:/deploypath/
scp docker-compose.yml user@server:/deploypath/
```

#### On Server

```bash
docker load < /deploypath/frontend.tar
docker load < /deploypath/backend.tar
# Note: Ensure docker-compose.yml has the correct reference to the containers

#check to see the images
docker images

# Start the containers!
docker-compose up -d #detached (run in background, return control to terminal)
```

#### All about the uris...

Traefik as the Reverse Proxy:

1. Traefik handles the routing and allows you to create clean, logical paths (e.g., /api for backend routes).
   It decouples your frontend from needing to know the backend's exact service URLs.
   Backend Routes Stay Clean:

2. The backend (Go app) can maintain simple routes like /someEndpoint without being aware of the reverse proxy.

- This avoids hardcoding /api into your backend code, which might be environment-specific.

3. Frontend Knows the Mapped Path:

- The frontend only needs to call /api/someEndpoint because it’s interacting with Traefik’s routes.

4. Flexibility for Future Changes:

- If I ever need to change the path mapping (e.g., /api to /backend), you only update Traefik’s config without touching the frontend or backend code.
