# User Documentation — Inception

## What services are provided

This stack runs three services:

| Service   | Role                                      | Port         |
|-----------|-------------------------------------------|--------------|
| NGINX     | HTTPS reverse proxy / entrypoint          | 443 (public) |
| WordPress | CMS web application (php-fpm)             | 9000 (internal) |
| MariaDB   | MySQL-compatible database                 | 3306 (internal) |

Only port 443 is accessible from outside. WordPress and MariaDB are internal to the
Docker network and cannot be reached directly from the host.

## Starting the project

```bash
make
```

This will:
1. Create the data directories under `/home/tazerotu/data/`
2. Build all Docker images from their Dockerfiles
3. Start all containers in detached mode

## Stopping the project

```bash
# Stop containers but keep volumes and images
make down

# Stop and remove everything (containers, images, volumes, data)
make clean
```

## Accessing the website

Once the stack is running, open your browser and go to:
https://tazerotu.42.fr

> Your browser will warn about the self-signed certificate — this is expected.
> Click "Advanced" → "Proceed" to continue.

## Accessing the WordPress administration panel
https://tazerotu.42.fr/wp-admin

Log in with the admin credentials defined in your `.env` file:
- **Username**: `WORDPRESS_ADMIN_USER`
- **Password**: `WORDPRESS_ADMIN_PASS`

## Locating and managing credentials

All credentials are stored in the `.env` file located at `srcs/.env`.
This file is gitignored and must never be committed.

| Variable               | Description                  |
|------------------------|------------------------------|
| `SQL_DATABASE`         | WordPress database name       |
| `SQL_USER`             | Database user for WordPress   |
| `SQL_PASSWORD`         | Database user password        |
| `SQL_ROOT_PASSWORD`    | MariaDB root password         |
| `WORDPRESS_ADMIN_USER` | WordPress admin username      |
| `WORDPRESS_ADMIN_PASS` | WordPress admin password      |
| `WORDPRESS_USER`       | WordPress subscriber username |
| `WORDPRESS_USER_PASS`  | WordPress subscriber password |

## Checking that services are running correctly

```bash
# Check all containers are up
docker ps

# Check logs for a specific service
docker logs nginx
docker logs wordpress
docker logs mariadb

# Check a container is healthy
docker inspect --format='{{.State.Status}}' nginx
```

All three containers should show status `running`. If a container keeps restarting,
check its logs for errors.