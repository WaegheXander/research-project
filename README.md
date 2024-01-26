# Research Project
Welcome to the research project on network topology, resilience, and fault tolerance, with a focus on server deployment and monitoring using Zabbix. This section provides additional guidance on setting up, deploying, and managing your network components.

# Getting started
## Clone the project
Clone the project repository to your local machine using the following command:
To begin clone the project:
```bash
git clone https://github.com/WaegheXander/research-project.git
```

After cloning, navigate to the project directory:
```cd
cd research-project/
```
## Project Structure
```css
+---Code
|   +---Agent
|   |       .env_example
|   |       docker-compose.yml
|   |
|   \---Server
|       |   docker-compose.yml
|       |   .env_example
+---quickdeploy
|       agent.ps1
|       agent.sh
```

# Project setup
## requirments
Ensure the following prerequisites are installed on your machine:
- Docker
- Docker-compose
- Git

## server Deploy
To deploy the server u need to change your directory to `Code/Server/`
```bash
cd Code/Server/
```

Before your start the server u need to change the `.env` variable. Currently the file is named `.env_example`<br>
1. change the file to `.env`
```bash
# Windows
move .env_example .env

# Linux
mv .env_example .env
```
2. replace the .env variable to what u want them to be
```bash
MYSQL_DATABASE=# DB_NAME
MYSQL_USER=# DB_USERNAME
MYSQL_PASSWORD=# DB_PASSWORD
MYSQL_ROOT_PASSWORD=# DB ROOT PASSWORD
```
Save the file & exit<br>
Now u can start the server by running this command:
```bash
docker-compose up -d

# if u don't want it to be running in the background remove the -d
```

To stop the server without losing any data just run this command:
``` bash
docker-compose down
```

If u want a clean reset (all data is lost) run this command
``` bash
docker-compose down -v
```

U can use the `docker ps` command to see is the containers are running.

To see if everythin works go to any webbrowser and got to `http://localhost`

### [Optional]
if u're server port 80 is already in use u can simply modify the port in the `docker-compose.yml` file under the server `zabbix-server`
```dockerfile
    # code ...
      - ZBX_SERVER_HOST=zabbix-server
      - DB_SERVER_HOST=mysql-server
    networks:
      - zabbix-net
    ports:
      - "80:8080" # change port 80 to whatever port is available
    restart: always
    depends_on:
      - mysql-server
    # code ...
```

After u did this u need to restart the docker containers:
```bash
docker-compose down
docker-compose up
```

Don't forget when u now want to see the web interface u need to give the port in the url
`http://localhost:<port>`

### ! disclamer !
> An agent is already present on the server, so you don't need to create an additional agent on the same machine.


## Agent Deploy
There are 2 option to deploy an agent `Quickdeploy` & `Manual`
### Quickdeploy
For the quick deploy u need to change your directory to `quickdeploy/`.
In this directory u will find 2 scripts<br>

If u are on windows run the `agent.ps1` script
```bash
./agent.ps1
```
If u are on a linux system run the `agent.sh` script:
```bash
./agent.sh
#or
sh agent.sh
```
<br>
Just fill in the parameter u get asked and the script does the rest.

U can use the `docker ps` command to see is the agents is running.

### Manual
To deploy the agent u need to change your directory to `Code/Agent/`
```bash
cd Code/Agent/
```

Before your start the aggent u need to change the `.env` variable. Currently the file is named `.env_example`<br>
1. change the file to `.env`
```bash
# Windows
move .env_example .env

# Linux
mv .env_example .env
```
2. replace the .env variable to what u want them to be
```bash
SERVER_IP= #the ip of your zabbix server
```
Save the file & exit<br>
Now u can start the server by running this command:
```bash
docker-compose up -d

# if u don't want it to be running in the background remove the -d
```

To stop the server without losing any data just run this command:
``` bash
docker-compose down
```

If u want a clean reset (all data is lost) run this command
``` bash
docker-compose down -v
```

U can use the `docker ps` command to see is the containers are running.