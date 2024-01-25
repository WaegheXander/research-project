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