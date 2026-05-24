*This project has been created as part of the 42 curriculum by ttas.*

# Inception

## Description

Inception is a system administration project from the 42 curriculum. The goal is to set up a small
infrastructure composed of multiple services running in Docker containers, orchestrated with
Docker Compose inside a virtual machine (or WSL2).

The stack includes:
- **NGINX** — the sole entrypoint, handling HTTPS on port 443 with TLSv1.2/1.3
- **WordPress + php-fpm** — the web application, running without NGINX
- **MariaDB** — the database backend for WordPress

### Design Choices

#### Virtual Machines vs Docker
A Virtual Machine emulates an entire operating system with its own kernel, making it heavy
and slow to start. Docker containers share the host kernel and only isolate the user space,
making them lightweight, fast to start, and easy to reproduce. However, VMs provide stronger
isolation. For this project, Docker is used to run each service in its own isolated container
while keeping resource usage low.

#### Secrets vs Environment Variables
Environment variables are convenient but visible to any process inside the container and can
accidentally end up in logs or version control. Docker secrets store sensitive data as files
mounted at `/run/secrets/`, accessible only to the container that needs them. For this project,
credentials are stored in a `.env` file (gitignored) and passed as environment variables, with
the secrets folder kept out of the repository.

#### Docker Network vs Host Network
`network: host` removes container network isolation — the container shares the host's network
stack directly, which is a security risk and forbidden by the subject. A Docker bridge network
(`networkInception`) is used instead, giving containers their own isolated network where they
communicate by service name (DNS), and only port 443 is exposed to the outside.

#### Docker Volumes vs Bind Mounts
Bind mounts link a host directory directly into the container — simple but fragile and
host-dependent. Docker named volumes are managed by Docker, more portable, and
survive container restarts and rebuilds. This project uses named volumes for the WordPress
files and the MariaDB database, with data stored under `/home/ttas/data/` on the host.

## Instructions

### Prerequisites
- Docker and Docker Compose installed
- WSL2 (or a Linux VM)
- Add `127.0.0.1 ttas.42.fr` to your `/etc/hosts`

### Run the project
```bash
make
```

### Stop the project
```bash
make down
```

### Full cleanup
```bash
make clean
```

### Rebuild from scratch
```bash
make re
```

## Resources

### Documentation
- [Docker official docs](https://docs.docker.com/)
- [Docker Compose reference](https://docs.docker.com/compose/compose-file/)
- [NGINX docs](https://nginx.org/en/docs/)
- [MariaDB docs](https://mariadb.com/kb/en/)
- [WordPress CLI (wp-cli)](https://wp-cli.org/)
- [php-fpm configuration](https://www.php.net/manual/en/install.fpm.configuration.php)
- [PID 1 and Docker best practices](https://cloud.google.com/architecture/best-practices-for-building-containers)
- [Docker secrets](https://docs.docker.com/engine/swarm/secrets/)

### AI Usage
AI was used during this project for:
- Explaining concepts such as PID 1, php-fpm socket vs TCP, and TLS configuration
- Reviewing docker-compose.yml structure and catching configuration mistakes
- Drafting this documentation

All AI-generated content was reviewed, tested, and understood before being included in the project.