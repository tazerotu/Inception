# Developer Documentation — Inception

## Prerequisites

- Docker Engine (or Docker Desktop with WSL2 integration enabled)
- Make
- WSL2 or a Linux VM
- Git

Add the domain to your hosts file:
```bash
echo "127.0.0.1 ttas.42.fr" | sudo tee -a /etc/hosts
```

## Project structure
.
├── Makefile
├── README.md
├── USER_DOC.md
├── DEV_DOC.md
├── secrets/
│   ├── db_password.txt
│   └── db_root_password.txt
└── srcs/
├── .env
├── docker-compose.yml
└── requirements/
├── MariaDB/
│   ├── Dockerfile
│   └── entrypoint.sh
├── WordPress/
│   ├── Dockerfile
│   └── entrypoint.sh
└── NGINX/
├── Dockerfile
├── nginx.conf
└── entrypoint.sh

## Configuration files

### `.env` (never commit this)
Located at `srcs/.env`. Contains all environment variables used by the containers.
Copy the template below and fill in your values:

```env
USERNAME=ttas
DOMAIN_NAME=ttas.42.fr

SQL_DATABASE=wordpress
SQL_USER=ttas_db
SQL_PASSWORD=
SQL_ROOT_PASSWORD=

WORDPRESS_URL=ttas.42.fr
WORDPRESS_ADMIN_USER=ttas
WORDPRESS_ADMIN_PASS=
WORDPRESS_ADMIN_EMAIL=ttas@student.42.fr
WORDPRESS_USER=ttas_user
WORDPRESS_USER_PASS=
WORDPRESS_USER_EMAIL=ttas_user@student.42.fr
```

### `secrets/`
Plain text files containing sensitive values, one value per file.
These are gitignored. Create them manually:

```bash
echo "yourdbpassword" > secrets/db_password.txt
echo "yourrootpassword" > secrets/db_root_password.txt
```

## Building and launching

```bash
# Build images and start all containers
make

# Equivalent manual command
mkdir -p /home/ttas/data/db_data
mkdir -p /home/ttas/data/wp_data
docker compose -f srcs/docker-compose.yml up -d --build
```

## Useful container management commands

```bash
# View running containers
docker ps

# View logs (live)
docker logs -f nginx
docker logs -f wordpress
docker logs -f mariadb

# Open a shell inside a container
docker exec -it nginx bash
docker exec -it wordpress bash
docker exec -it mariadb bash

# Restart a single service
docker compose -f srcs/docker-compose.yml restart nginx

# Stop all containers
make down

# Full reset (removes containers, images, volumes, and data)
make clean
```

## Data persistence

| Volume     | Mount in container    | Host path                        |
|------------|-----------------------|----------------------------------|
| `db_data`  | `/var/lib/mysql`      | `/home/ttas/data/db_data`    |
| `wp_data`  | `/var/www/html`       | `/home/ttas/data/wp_data`    |

Data persists across `docker compose down` and rebuilds as long as `make clean`
is not run. The `make clean` target removes the host data directories entirely.

## Rebuilding from scratch

```bash
make re
```

This runs `make clean` followed by `make all`, giving you a completely fresh environment.

## Common issues

**Containers not starting — permission denied on Docker socket**
```bash
sudo usermod -aG docker $USER
newgrp docker
```

**WordPress not connecting to MariaDB**
MariaDB takes a few seconds to initialize on first boot. The WordPress entrypoint
script waits for it with a `mysqladmin ping` loop. If it times out, check MariaDB
logs: `docker logs mariadb`

**Browser shows certificate warning**
Expected — the TLS certificate is self-signed. Click through the warning in your browser.

**Port 443 already in use**
```bash
sudo lsof -i :443
# kill the conflicting process, then make again
```