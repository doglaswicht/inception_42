*This project has been created as part of the 42 curriculum by dleite-b*

# Inception

## Description
Inception is a containerized web stack built with Docker and Docker Compose. The project provides a secure and modular WordPress deployment using three isolated services:
- `nginx` as the HTTPS reverse proxy/web server (TLS enabled on port `443`)
- `wordpress` running PHP-FPM and WP-CLI
- `mariadb` as the relational database

The main goal is to run each component in its own container, connect them through a dedicated Docker network, and persist application/database data through volumes.

## Project Architecture

### Services and Sources Included
- [`srcs/docker-compose.yml`](inception42/srcs/docker-compose.yml): orchestrates services, network, volumes, and secrets.
- [`srcs/requirements/nginx/Dockerfile`](inception42/srcs/requirements/nginx/Dockerfile): builds NGINX image.
- [`srcs/requirements/nginx/conf/default.conf`](/inception42/srcs/requirements/nginx/conf/default.conf): TLS virtual host and PHP forwarding to `wordpress:9000`.
- [`srcs/requirements/nginx/tools/setup.sh`](/inception42/srcs/requirements/nginx/tools/setup.sh): generates self-signed certificate and starts NGINX.
- [`srcs/requirements/wordpress/Dockerfile`](/inception42/srcs/requirements/wordpress/Dockerfile): installs PHP-FPM, MariaDB client, and WP-CLI.
- [`srcs/requirements/wordpress/tools/setup_wordpress.sh`](/inception42/srcs/requirements/wordpress/tools/setup_wordpress.sh): waits for DB, installs/configures WordPress, creates users.
- [`srcs/requirements/mariadb/Dockerfile`](/inception42/srcs/requirements/mariadb/Dockerfile): installs MariaDB server.
- [`srcs/requirements/mariadb/tools/setup_mariadb.sh`](/inception42/srcs/requirements/mariadb/tools/setup_mariadb.sh): initializes database and grants privileges.
- [`Makefile`](/inception42/Makefile): lifecycle commands (`up`, `down`, `clean`, etc.).

### Main Design Choices
- Dedicated container per role (web, app, database).
- Internal communication through one custom bridge network (`inception`).
- Passwords managed with Docker secrets (`/run/secrets/...`) instead of plain env values.
- Persistent data mounted from host path (`/home/dleite-b/data/*`) into containers.
- Entry-point setup scripts to make first boot automated and repeatable.

### Required Technical Comparison

#### Virtual Machines vs Docker
- Virtual Machines virtualize full operating systems and consume more resources.
- Docker containers share the host kernel, start faster, and are lighter.
- In this project Docker improves reproducibility and simplifies service isolation.

#### Secrets vs Environment Variables
- Environment variables are practical for non-sensitive config (`DOMAIN_NAME`, usernames, titles).
- Secrets are safer for sensitive values (DB and WordPress passwords), mounted as files with limited exposure.
- This project uses both: `.env` for non-secret config and `secrets/*.txt` for passwords.

#### Docker Network vs Host Network
- Host networking removes network isolation and can create port conflicts.
- Bridge networking isolates containers and provides service-name DNS (`mariadb`, `wordpress`, `nginx`).
- This project uses a custom bridge network for safer inter-service communication.

#### Docker Volumes vs Bind Mounts
- Docker named volumes are managed by Docker and are portable.
- Bind mounts map exact host paths and are easy to inspect/backup manually.
- This stack uses local driver volumes with bind options to store data under `/home/dleite-b/data`.

## Instructions

### 1. Prerequisites
- Linux environment with Docker Engine and Docker Compose plugin.
- `make` installed.
- Add your 42 domain to `/etc/hosts`:

```bash
127.0.0.1 dleite-b.42.fr
```

### 2. Configuration
- Edit [`srcs/.env`](inception42/srcs/.env) with your domain and WordPress metadata.
- Fill password files:
  - [`secrets/db_password.txt`](/inception42/secrets/db_password.txt)
  - [`secrets/db_root_password.txt`](/inception42/secrets/db_root_password.txt)
  - [`secrets/wp_admin_password.txt`](/inception42/secrets/wp_admin_password.txt)
  - [`secrets/wp_user_password.txt`](/inception42/secrets/wp_user_password.txt)

### 3. Build and Run
From repository root:

```bash
make up
```

Useful lifecycle commands:

```bash
make down     # stop containers
make logs     # show compose logs
make clean    # stop and remove containers + volumes
make fclean   # clean + remove /home/$USER/data/*
make re       # full rebuild
```

### 4. Access
- Website: `https://dleite-b.42.fr`
- WordPress admin panel: `https://dleite-b.42.fr/wp-admin`

## Resources
- Docker documentation: https://docs.docker.com/
- Docker Compose specification: https://docs.docker.com/compose/
- NGINX documentation: https://nginx.org/en/docs/
- MariaDB documentation: https://mariadb.com/kb/en/documentation/
- WordPress + WP-CLI documentation:
  - https://wordpress.org/documentation/
  - https://developer.wordpress.org/cli/commands/

### AI Usage Disclosure
AI was used in this repository for documentation support (drafting, restructuring, and compliance checks for README/USER_DOC/DEV_DOC). Runtime configuration and service orchestration logic were validated against the existing project files before finalizing the docs.
