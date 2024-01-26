# Check if Docker is installed
if (-not (Test-Path "C:\Program Files\Docker\Docker\")) {
    Write-Host "Docker is not installed. Please install Docker and run the script again."
    exit

}

# Check if Docker service is running
if (-not (Get-Service 'com.docker.service' -ErrorAction SilentlyContinue)) {
    Write-Host "Docker service is not running. Please start the Docker service and run the script again."
    exit
}

Invoke-WebRequest -Uri "https://github.com/WaegheXander/research-project/blob/main/Code/Agent/docker-compose.yml" -OutFile "docker-compose.yml"

# ask for server ip
$SERVER_IP = Read-Host -Prompt "Enter SERVER_IP: "

@"
SERVER_IP=$SERVER_IP
"@ | Out-File -FilePath .env

try {
    # Start docker-compose
    docker-compose up -d
}
catch {
    <#Do this if a terminating exception happens#>
    Write-Error("Error: $_")
}