#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "===================================================="
echo "🚀 Starting Local SonarQube + Postgres Setup Script"
echo "===================================================="

# 1. Apply required Arch Linux kernel settings for Elasticsearch
echo "🔧 Configuring system memory map limits (vm.max_map_count)..."
sudo sysctl -w vm.max_map_count=262144
echo "vm.max_map_count=262144" | sudo tee /etc/sysctl.d/99-sonarqube.conf >/dev/null

# 2. Create local persistent directories
echo "📂 Creating persistent directories in ~/sonarqube..."
BASE_DIR="$HOME/sonarqube"
mkdir -p "$BASE_DIR/sonar_data" \
  "$BASE_DIR/sonar_extensions" \
  "$BASE_DIR/sonar_logs" \
  "$BASE_DIR/postgres_data"

# Move to the target directory
cd "$BASE_DIR"

# 3. Generate the docker-compose.yml file dynamically
echo "📝 Generating docker-compose.yml file..."
cat <<'EOF' >docker-compose.yml
version: '3.8'

services:
  db:
    image: postgres:15-alpine
    container_name: sonar_postgres
    restart: always
    environment:
      - POSTGRES_USER=sonar
      - POSTGRES_PASSWORD=sonar_secure_pass
      - POSTGRES_DB=sonar
    volumes:
      - ./postgres_data:/var/lib/postgresql/data
    networks:
      - sonar_network
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U sonar"]
      interval: 5s
      timeout: 5s
      retries: 5

  sonarqube:
    image: sonarqube:lts-community
    container_name: sonar_app
    restart: always
    depends_on:
      db:
        condition: service_healthy
    ports:
      - "9000:9000"
    environment:
      - SONAR_JDBC_USERNAME=sonar
      - SONAR_JDBC_PASSWORD=sonar_secure_pass
      - SONAR_JDBC_URL=jdbc:postgresql://db:5432/sonar
      - SONAR_WEB_JAVAADDITIONALOPTS=-Xms512m -Xmx1024m -XX:+UseG1GC
      - SONAR_SEARCH_JAVAADDITIONALOPTS=-Xms512m -Xmx1024m -XX:+UseG1GC
    volumes:
      - ./sonar_data:/opt/sonarqube/data
      - ./sonar_extensions:/opt/sonarqube/extensions
      - ./sonar_logs:/opt/sonarqube/logs
    networks:
      - sonar_network

networks:
  sonar_network:
    driver: bridge
EOF

# 4. Start the infrastructure
echo "🐳 Pulling images and spinning up docker containers..."
docker compose up -d

echo "===================================================="
echo "✅ Setup Complete!"
echo "===================================================="
echo "▶️ SonarQube is booting up in the background (takes ~1 minute)."
echo "▶️ URL: http://localhost:9000"
echo "▶️ Default Credentials: admin / admin"
echo "===================================================="
echo "📊 Showing initialization logs (Press Ctrl+C to stop viewing logs safely):"
echo "===================================================="

# Automatically stream the application logs
docker compose logs -f sonarqube
