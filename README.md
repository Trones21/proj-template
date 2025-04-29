# Project Templates

A collection of project templates for different languages and frameworks.  
Functionality and structure will vary depending on the template — see the `README.md` inside each template folder (e.g., `go/`, `python-django/`) for specific details.

All templates are built from scratch using patterns that have worked well for me in real-world projects.  
Feel free to use, adapt, and extend them — enjoy! 🚀

# Quick comparison

| Aspect              | Go Version                      | Django Version           |
| :------------------ | :------------------------------ | :----------------------- |
| Language            | Go                              | Python                   |
| Entrypoint          | Compiled binary (`pk_projName`) | `manage.py` (CLI runner) |
| DB Handling         | SQLC + raw                      | Django ORM + migrations  |
| e2e API Test Runner | \*noCRUD (python)               | \*noCRUD (python)        |
| Build style         | Binary compilation              | Source + pip install     |
| Runtime             | Debian + single binary          | Debian + Python runtime  |

---

[noCRUD](https://github.com/Trones21/noCRUD/tree/main/python)

## Basic Structure

I keep the same basic structure for all my applications

```txt
+---------------------+
|  Reverse Proxy      | (Container 1: Traefik)
|   - / -> Frontend   |
|   - /api -> Backend |
+---------------------+
        |           |
+----------------+   +----------------+
| Frontend        |   | Backend        |
| Quasar Files    |   | Go/Django      |
| Running on Nginx|   |                |
+----------------+   +----------------+

```

### Do After Generation (and backend setup found in backend readme.md)

- Create a frontend with the [quasar CLI](https://quasar.dev/start/quasar-cli/)
  - Install the CLI: npm i -g @quasar/cli
  - `cd` to `/frontend`
  - `npm init quasar@latest`
    - use . to keep it directly in the frontend
- Test local containers with build_and_deploy_local.sh

### Deployment (Prod)

Current process is build the containers locally (with prod settings) and copy to server

- Remember to backup RDS and migrate(update db schema)!! This is integrated into deployment

#### Step 1 - On Dev Machine

**This is all in deploy.sh/build_and_deploy.sh.. but here is the general process. Look to the frontend and backend readmes for deep guidance on their containers.**

```bash
docker-compose build

docker save -o frontend.tar frontend:latest
docker save -o backend.tar backend:latest

scp frontend.tar backend.tar user@server:/deploypath/
scp docker-compose.yml user@server:/deploypath/
```

#### Step 2 - On Server

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
