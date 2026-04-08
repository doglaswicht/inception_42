# USER_DOC

## What This Stack Provides
This project provides a complete WordPress website stack with three services:
- `nginx`: HTTPS entrypoint on port `443`.
- `wordpress`: PHP-FPM application serving WordPress.
- `mariadb`: database used by WordPress.

## Start and Stop the Project
From the repository root:

```bash
make up
```

To stop:

```bash
make down
```

Useful additional commands:

```bash
make logs   # show service logs
make clean  # stop and remove containers + volumes
```

## Access the Website and Admin Panel
1. Ensure your host mapping exists in `/etc/hosts`:

```bash
127.0.0.1 dleite-b.42.fr
```

2. Open:
- Website: `https://dleite-b.42.fr`
- Admin panel: `https://dleite-b.42.fr/wp-admin`

## Where Credentials Are Stored
Credentials are split between `.env` (non-sensitive) and Docker secrets (passwords):
- Non-sensitive config: [`srcs/.env`](/home/dleite-b/42/rank05/inception42/srcs/.env)
- Password files:
  - [`secrets/db_password.txt`](/inception42/secrets/db_password.txt)
  - [`secrets/db_root_password.txt`](/inception42/secrets/db_root_password.txt)
  - [`secrets/wp_admin_password.txt`](/inception42/secrets/wp_admin_password.txt)
  - [`secrets/wp_user_password.txt`](/inception42/secrets/wp_user_password.txt)

Inside containers, secret passwords are mounted at `/run/secrets/*`.

## How to Check Services Are Running
Use Docker Compose status:

```bash
docker compose -f srcs/docker-compose.yml ps
```

Expected: `mariadb`, `wordpress`, and `nginx` should be `Up`.

Check logs:

```bash
make logs
```

Quick functional checks:
- Website opens on `https://dleite-b.42.fr`
- WordPress login page opens on `/wp-admin`
