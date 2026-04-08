# DEV_DOC

## 1. Environment Setup From Scratch

### Prerequisites
- Linux host (or VM) with Docker Engine installed.
- Docker Compose plugin (`docker compose`).
- `make`.
- Permission to run Docker commands.

### Hostname Mapping
Add your 42 domain to `/etc/hosts`:

```bash
127.0.0.1 dleite-b.42.fr
```

### Required Configuration Files
- Environment file: [`srcs/.env`](/inception42/srcs/.env)
- Secret files:
  - [`secrets/db_password.txt`](/inception42/secrets/db_password.txt)
  - [`secrets/db_root_password.txt`](/inception42/secrets/db_root_password.txt)
  - [`secrets/wp_admin_password.txt`](/inception42/secrets/wp_admin_password.txt)
  - [`secrets/wp_user_password.txt`](/inception42/secrets/wp_user_password.txt)

### Notes About Paths
Current compose volume bind paths are hardcoded to:
- `/home/dleite-b/data/mariadb`
- `/home/dleite-b/data/wordpress`

The `Makefile` initializes `/home/$USER/data/...`. If your username is not `dleite-b`, either:
- Update [`srcs/docker-compose.yml`](/inception42/srcs/docker-compose.yml) volume `device` paths, or
- Keep host paths aligned manually.

## 2. Build and Launch
From repository root:

```bash
make up
```

What this does:
- Creates data directories (`make init`).
- Builds the three images.
- Starts containers in detached mode.

Stop stack:

```bash
make down
```

Rebuild from clean state:

```bash
make re
```

## 3. Container and Volume Management Commands

### Compose Operations
```bash
docker compose -f srcs/docker-compose.yml ps
docker compose -f srcs/docker-compose.yml logs -f
docker compose -f srcs/docker-compose.yml up -d --build
docker compose -f srcs/docker-compose.yml down
```

### Enter Running Containers
```bash
docker exec -it mariadb bash
docker exec -it wordpress bash
docker exec -it nginx bash
```

### Cleanup Commands
```bash
make clean   # compose down -v
make fclean  # clean + remove /home/$USER/data/mariadb and /home/$USER/data/wordpress
```

## 4. Data Storage and Persistence

### Persistent Data Locations
- MariaDB data: host bind path `/home/dleite-b/data/mariadb` -> container `/var/lib/mysql`
- WordPress files: host bind path `/home/dleite-b/data/wordpress` -> container `/var/www/html`

### Why Data Persists
Even if containers are removed, data remains on host bind paths. Data is lost only when those host directories are deleted (for example with `make fclean` if path matches your user directory).

## 5. Service Initialization Flow
- `mariadb`:
  - Reads DB secrets from `/run/secrets/*`.
  - Initializes DB files if first startup.
  - Creates database and WordPress DB user.
- `wordpress`:
  - Waits for MariaDB.
  - Downloads and configures WordPress with WP-CLI if not already installed.
  - Creates admin and regular user.
  - Starts PHP-FPM on port `9000`.
- `nginx`:
  - Generates self-signed certificate.
  - Serves HTTPS and forwards `.php` requests to `wordpress:9000`.
