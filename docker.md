# Docker Commands

## Start MariaDB Backend

```bash
docker run -d \
  --name backend \
  -e MARIADB_USER=ashish \
  -e MARIADB_PASSWORD=admin \
  -e MARIADB_DATABASE=backend-database \
  -e MARIADB_ROOT_PASSWORD=admin \
  --network webapp-network \
  mariadb:latest
```

## Start WordPress Frontend

```bash
docker container run -d \
  -p 9000:80 \
  --name frontend \
  -e WORDPRESS_DB_HOST=backend \
  -e WORDPRESS_DB_USER=ashish \
  -e WORDPRESS_DB_PASSWORD=admin \
  -e WORDPRESS_DB_NAME=backend-database \
  --network webapp-network \
  wordpress:latest
```

## Start Mysql_db

```bash
docker run -d -e MYSQL_ALLOW_EMPTY_PASSWORD=yes \
--mount source=mysql_db,target=/var/lib/mysql \
--name mysql mysql:latest
```
