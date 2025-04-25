# Go Project Generator

A minimal yet powerful project generator for Go backends.  
It scaffolds a complete backend, request flow clients for API testing, and basic deployment scripts — so you can start building immediately.

No unnecessary bloat. No weird dependencies. Just a clean foundation.

---

## Usage

1. Make sure the generator script (`create_project.sh`) is executable:

   ```bash
   chmod +x create_project.sh
   ```

2. Run the generator:

   ```bash
   ./create_project.sh -n <your_project_name>
   ```

3. After running, your project will be created under:
   ```
   ~/Documents/git_repos/<your_project_name>/
   ```
   and environment setup files will be placed under:
   ```
   ~/env_setup/<your_project_name>/
   ```

---

## What's Included

### Project Structure

- **backend/** — Go backend starter with:

  - `cmd/app/` — Main application entry (`main.go`)
  - `internal/` — Modularized structure:
    - `handlers/` — Route handlers for endpoints (e.g., user onboarding)
    - `helpers/` — Common helper utilities
    - `middleware/` — CORS, logging, recovery, and auth middleware
    - `services/brevo/` — Email integration (Brevo / Sendinblue)
    - `repositories/` — Placeholder for database operations
  - `db/`
    - SQLC config (`sqlc.yaml`)
    - Database migrations (`migrations/`)
    - Queries (`queries/`)
    - Fixtures for loading necessary static data
    - DB utility scripts (reset, backup, recreate)
  - `configs/` — App configuration files
  - Go module files (`go.mod`, `go.sum`), Dockerfile, and supporting files

- **request_flows/** — Lightweight Go client for:

  - Simulating API requests
  - Performing smoke tests and validation flows
  - Utilities for authentication and JSON handling
  - A basic example flow included

- **\_top_level_docs/** — Docs starter:

  - `USEFUL.md` — General project tips and links
  - Blank `README.md` for your project-specific notes

- **\_images/** — Placeholder for architecture diagrams or visual assets

- **frontend/** — Placeholder (you'll manually create a frontend app, e.g., Quasar)

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

✅ Navigate to your project folder:

```bash
cd ~/Documents/git_repos/<your_project_name>
```

✅ Set up your environment variables:

```bash
cd ~/env_setup/<your_project_name>
# Edit local_backend.sh and prod_backend.sh as needed
```

✅ Update `deploy.sh`:

- Set your SSH login credentials for deployment.

✅ (Optional) Set up the frontend:

- Use [Quasar CLI](https://quasar.dev/start/installation) or your preferred frontend stack.

✅ Install Go dependencies:

```bash
cd backend
go mod tidy
```

✅ (Optional) Install request flow dependencies:

```bash
cd ../request_flows
go mod tidy
```

✅ Start developing! 🚀
