#!/bin/bash

# Check if Docker is installed
if [ ! -d "/usr/bin/docker" ]; then
    echo "Docker is not installed. Please install Docker and run the script again."
    exit 1
fi

# Check if Docker service is running
if ! systemctl is-active --quiet docker; then
    echo "Docker service is not running. Please start the Docker service and run the script again."
    exit 1
fi

# Get docker-compose.yml
curl -o docker-compose.yml https://github.com/WaegheXander/research-project/raw/main/Code/Agent/docker-compose.yml

# Ask for server IP
read -p "Enter SERVER_IP: " SERVER_IP

# Put the variable in a .env file
cat <<EOF > .env
SERVER_IP=$SERVER_IP
EOF

# Start docker-compose
docker-compose up -d
