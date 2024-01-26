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

# Check if Git is installed
if [ ! -x "$(command -v git)" ]; then
    echo "Git is not installed. Please install Git and run the script again."
    exit 1
fi

# Clone the GitHub repository
git clone git@github.com:WaegheXander/research-project.git

# Navigate to the Agent directory
cd ./research-project/Code/Agent || exit

# Ask for server IP and NAME
read -p "Enter SERVER_IP: " SERVER_IP
read -p "Enter NAME [no spaces]: " NAME

# Create .env file with SERVER_IP and NAME
cat <<EOF > .env
SERVER_IP=$SERVER_IP
NAME=$NAME
EOF

# Start docker-compose
docker-compose up -d
