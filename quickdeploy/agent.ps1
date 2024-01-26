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

# Check if Git is installed
if (-not (Test-Path "C:\Program Files\Git\bin\git.exe")) {
    Write-Host "Git is not installed. Please install Git and run the script again."
    exit
}

# Clone the GitHub repository
git clone https://github.com/WaegheXander/research-project.git

# Navigate to the Agent directory
cd .\research-project\Code\Agent

# Ask for server IP
$SERVER_IP = Read-Host -Prompt "Enter SERVER_IP"
$NAME = Read-Host -Prompt "Enter NAME [no spaces]"

# Create .env file with SERVER_IP
@"
SERVER_IP=$SERVER_IP
NAME=$NAME
"@ | Out-File -FilePath ".env" -Encoding ASCII

try {
    # Start docker-compose
    docker-compose up -d
}
catch {
    <# Do this if a terminating exception happens #>
    Write-Error("Error: $_")
}
