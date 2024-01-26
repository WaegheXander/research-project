#!/bin/bash

# Check if Docker is installed
if [ ! -d "/usr/bin/docker" ]; then
    echo "Docker is not installed. Please install Docker and run the script again."
    echo "https://docs.docker.com/engine/install/"
    exit 1
fi

# Check if Docker service is running
if ! systemctl is-active --quiet docker; then
    echo "Docker service is not running. Please start the Docker service and run the script again."
    exit 1
fi

# Get docker-compose.yml
curl -o docker-compose.yml https://raw.githubusercontent.com/WaegheXander/research-project/main/Code/Server/docker-compose.yml

# Ask for MYSQL_DATABASE=
read -p "Enter MYSQL_DATABASE: " MYSQL_DATABASE
# MYSQL_USER=
read -p "Enter MYSQL_USER: " MYSQL_USER
# MYSQL_PASSWORD=
read -p "Enter MYSQL_PASSWORD: " MYSQL_PASSWORD
# MYSQL_ROOT_PASSWORD=
read -p "Enter MYSQL_ROOT_PASSWORD: " MYSQL_ROOT_PASSWORD

# Put the variables in a .env file
cat <<EOF > .env
MYSQL_DATABASE=$MYSQL_DATABASE
MYSQL_USER=$MYSQL_USER
MYSQL_PASSWORD=$MYSQL_PASSWORD
MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD
EOF

# Start docker-compose
docker-compose up -d
