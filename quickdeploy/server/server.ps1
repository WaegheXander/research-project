# Check if Docker is installed
if (-not (Test-Path "C:\Program Files\Docker\Docker\")) {
    Write-Host "Docker is not installed. Please install Docker and run the script again."
    Write-Host "https://docs.docker.com/engine/install/"
    exit

}

# Check if Docker service is running
if (-not (Get-Service 'com.docker.service' -ErrorAction SilentlyContinue)) {
    Write-Host "Docker service is not running. Please start the Docker service and run the script again."
    exit
}

# Get docker-compose.yml
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/WaegheXander/research-project/main/Code/Server/docker-compose.yml" -OutFile "docker-compose.yml"

# ask for MYSQL_DATABASE=
$MYSQL_DATABASE = Read-Host -Prompt "Enter MYSQL_DATABASE: "
# MYSQL_USER=
$MYSQL_USER = Read-Host -Prompt "Enter MYSQL_USER: "
# MYSQL_PASSWORD=
$MYSQL_PASSWORD = Read-Host -Prompt "Enter MYSQL_PASSWORD: "
# MYSQL_ROOT_PASSWORD=
$MYSQL_ROOT_PASSWORD = Read-Host -Prompt "Enter MYSQL_ROOT_PASSWORD: "

# put the variable in a .env file
@"
MYSQL_DATABASE=$MYSQL_DATABASE
MYSQL_USER=$MYSQL_USER
MYSQL_PASSWORD=$MYSQL_PASSWORD
MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD
"@ | Out-File -FilePath .env

try {
    # Start docker-compose
    docker-compose up -d
}
catch {
    <#Do this if a terminating exception happens#>
    Write-Error("Error: $_")
}


