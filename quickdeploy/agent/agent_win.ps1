# Check if Docker is installed
if (-not (Test-Path "C:\Program Files\Docker\Docker\")) {
    Write-Host "Docker is not installed. Please install Docker and run the script again."
    exit

}

# Check if Docker service is running
if (-not (Get-Service 'com.docker.service' -ErrorAction SilentlyContinue)) {
    Write-Host "Docker service is not running. Please start the Docker service and run the script again."
    Write-Host "https://docs.docker.com/engine/install/"
    exit
}

# Prompt user for Zabbix Server IP and Zabbix Agent hostname
$zabbixServerIP = Read-Host -Prompt "Enter Zabbix Server IP"
$agentHostname = Read-Host -Prompt "Enter Zabbix Agent hostname"

# Define variables
$containerName = "zabbix-agent"
$imageName = "zabbix/zabbix-agent2"
$networkName = "zabbix-net"

# Check if container with the same name is already running
if (docker ps -a --format '{{.Names}}' | Where-Object { $_ -eq $containerName }) {
    Write-Host "A container with the name $containerName already exists. Please choose a different name or remove the existing container."
    exit
}

# Check if network already exists
if (-not (docker network ls --format '{{.Name}}' | Where-Object { $_ -eq $networkName })) {
    # Create a Docker network
    docker network create --driver bridge $networkName
}

# Run the Zabbix Agent container
docker run -d `
    --name $containerName `
    --hostname $agentHostname `
    --env ZBX_HOSTNAME=zabbix-server `
    --publish 10050:10050 `
    --restart always `
    --add-host "zabbix-server:$zabbixServerIP" `
    --network $networkName `
    $imageName
