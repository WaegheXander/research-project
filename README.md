# Research Project

Welcome to the research project on network topology, resilience, and fault tolerance, with a focus on server deployment and monitoring using Zabbix. This section provides additional guidance on setting up, deploying, and managing your network components.

## Content Table

- [Getting started](#getting-started)
  - [Clone the project](#clone-the-project)
  - [Project Structure](#project-structure)
- [Project setup](#project-setup)
  - [Requirements](#requirements)
  - [Server Deploy](#server-deploy)
  - [Optional](#optional)
- [Agent Deploy](#agent-deploy)
  - [Quickdeploy](#quickdeploy)
  - [Manual](#manual)
- [Troubleshoot](#troubleshoot)

## Getting started

### Clone the project

Clone the project repository to your local machine using the following command:

```bash
git clone https://github.com/WaegheXander/research-project.git
```

After cloning, navigate to the project directory:

```cd
cd research-project/
```

### Project Structure

Explore the project structure

```css
+---Code
|   +---Agent
|   |       .env_example
|   |       docker-compose.yml
|   |
|   \---Server
|       |   docker-compose.yml
|       |   .env_example
+---Quickdeploy
|       agent.ps1
|       agent.sh
```

## Project setup

### Requirements

Ensure the following prerequisites are installed on your machine:

- [Docker](https://docs.docker.com/engine/install/)
- [Docker-compose](https://docs.docker.com/engine/install/)
- [Git](https://git-scm.com/downloads)
- Internet 🙂
- 1 Braincel 🧠

### Server Deploy

**_note:_**

> [!IMPORTANT]
> An agent is already present on the server, so you don't need to create an additional agent on the same machine.

To deploy the server u need to change your directory to `Code/Server/`

```bash
cd Code/Server/
```

Before your start the server u need to change the `.env` variable. Currently the file is named `.env_example`

1 **Change the file** `.env_example` **to** `.env`

```bash
# Windows
move .env_example .env

# Linux
mv .env_example .env
```

2 **Replace the** `.env` **variable to what u want them to be**

```bash
MYSQL_DATABASE=# DB_NAME
MYSQL_USER=# DB_USERNAME
MYSQL_PASSWORD=# DB_PASSWORD
MYSQL_ROOT_PASSWORD=# DB ROOT PASSWORD
```

Save the file & exit. Now u can start the server by running this command:

```bash
docker-compose up -d
```

> if u don't want it to be running in the background remove the -d. EX: If u want to debug

To stop the server without losing any data, run this command:

```bash
docker-compose down
```

To stop the server an remove all stored data, run this command

```bash
docker-compose down -v
```

U can use the `docker ps` command to see is the containers are running.

It should be something like this

```plaintext
CONTAINER ID   IMAGE                                             COMMAND                  CREATED        STATUS                 PORTS                                            NAMES
e412cdbbe03b   zabbix/zabbix-web-nginx-mysql:alpine-6.4-latest   "docker-entrypoint.sh"   45 hours ago   Up 8 hours             8443/tcp, 0.0.0.0:80->8080/tcp                   zabbix-web-nginx-mysql
6e1d677632ae   zabbix/zabbix-server-mysql:alpine-6.4-latest      "/sbin/tini -- /usr/…"   45 hours ago   Up 8 hours             0.0.0.0:162->162/udp, 0.0.0.0:10051->10051/tcp   zabbix-server
c47c17744a12   zabbix/zabbix-java-gateway:alpine-6.4-latest      "docker-entrypoint.s…"   45 hours ago   Up 8 hours             0.0.0.0:10052->10052/tcp                         zabbix-java-gateway
6992e343fcaa   zabbix/zabbix-agent:alpine-6.4-latest             "/sbin/tini -- /usr/…"   45 hours ago   Up 8 hours             10050/tcp                                        zabbix-agent
f8304e6c02e3   mysql:8.0                                         "docker-entrypoint.s…"   45 hours ago   Up 8 hours (healthy)   3306/tcp, 33060/tcp                              mysql-server
```

To see if everything works go to any webbrowser and type the url: [http://localhost/](http://localhost/)

### [Optional]

1 **Using an other port for the web interface**

if u're server port 80 is already in use u can simply modify the port in the `docker-compose.yml` file under the server `zabbix-web-nginx-mysql`

```dockerfile
# code ...
  - ZBX_SERVER_HOST=zabbix-server
  - DB_SERVER_HOST=mysql-server
networks:
  - zabbix-net
ports:
  - "80:8080"
  # change port 80 to whatever port is available
restart: always
depends_on:
  - mysql-server
# code ...
```

Don't forget when u now want to see the web interface u need to give the port in the url
`http://localhost:<port>/`

2 **Using an other port for snmp traps**

I u would like to use an other port for the snmp traps change the port at the service `zabbix-server`

```dockerfile
# code ...
networks:
      - zabbix-net
    ports:
      - "10051:10051"
      - "162:162/udp"
      # change the first port 162 to whatever u like
    expose:
      - 10051
    restart: always
    depends_on:
# code ...
```

#### Finally

After u did this u need to restart the docker containers:

```bash
docker-compose down
docker-compose up
```

#### Credentials

To default credentials are

> Username: Admin\
> Password: zabbix

## Agent Deploy

There are 2 option to deploy an agent [Quickdeploy](#quickdeploy) & [Manual](#manual)

### Quickdeploy

For the quick deploy u need to change your directory to `quickdeploy/`.
In this directory u will find 2 scripts

If u are on windows run the `agent.ps1` script

```bash
./agent.ps1
```

If u are on a linux system run the `agent.sh` script:

```bash
./agent.sh
# or
sh agent.sh
```

Just fill in the parameter u get asked and the script does the rest.

U can use the `docker ps` command to see is the agents is running.

### Manual

To deploy the agent u need to change your directory to `Code/Agent/`

```bash
cd Code/Agent/
```

Before your start the aggent u need to change the `.env` variable. Currently the file is named `.env_example`

1 **Change the file to** `.env`

```bash
# Windows
move .env_example .env

# Linux
mv .env_example .env
```

2 **Replace the** `.env` **variable to what u want them to be**

```bash
SERVER_IP= # The ip of your zabbix server
```

Save the file & exit. Now u can start the server by running this command:

```bash
docker-compose up -d
```

> If u don't want it to be running in the background remove the -d. EX: If u want to debug

To stop the server without losing any data just run this command:

```bash
docker-compose down
```

To stop the server an remove all stored data, run this command

```bash
docker-compose down -v
```

U can use the `docker ps` command to see is the containers are running.

It should be something like this

```plaintext
CONTAINER ID   IMAGE                                   COMMAND                  CREATED       STATUS          PORTS                                           NAMES
24bf9a562c15   zabbix/zabbix-agent:alpine-6.4-latest   "/sbin/tini -- /usr/…"   7 hours ago   Up 45 minutes   0.0.0.0:10050->10050/tcp, :::10050->10050/tcp   myraspberrypi
```

## Troubleshoot

### Firewall setting

Check the firewall settings on the server machine to ensure that the required ports for Zabbix are open. 10051 & 162 & 80(or the port u configured)

**Windows**

```ps1
Test-NetConnection -ComputerName localhost -Port 80
Test-NetConnection -ComputerName localhost -Port 10051
```

Output:

```plaintext
ComputerName     : localhost
RemoteAddress    : ::1
RemotePort       : 10051
InterfaceAlias   : Loopback Pseudo-Interface 1
SourceAddress    : ::1
TcpTestSucceeded : True
```

If the `TcpTestSucceeded : Flase` that means the port is no open from the outside go to firewall setting an add a new inbound for the port(s) that are not open yet

**Linux**

UFW systems

```bash
sudo ufw status
```

Output

```plaintext
To                         Action      From
--                         ------      ----
22                         ALLOW       Anywhere
10051                      ALLOW       Anywhere
80                         ALLOW       Anywhere
162                        ALLOW       Anywhere
22 (v6)                    ALLOW       Anywhere (v6)
10051 (v6)                 ALLOW       Anywhere (v6)
80 (v6)                    ALLOW       Anywhere (v6)
162 (v6)                   ALLOW       Anywhere (v6)
```

If u don't see a port open u can use this command to add the port

```bash
sudo ufw allow <port>
```

### Host file

> [!NOTE]
> this is for agents only

Check if u can pint the server

```bash
ping <zabbix-server>
```

If u can't ping to the server u might want to add the host to the hosts file

> [!NOTE]
> U need to be administrator to do this

**Windows**

`C:\Windows\System32\drivers\etc`
here u can add the host like:

```plaintext
<server ip>   zabbix-server
```

**Linux**

`/etc/hosts`
here u can add the host like:

```plaintext
<server ip>   zabbix-server
```

### Port availability

If u get an error that the port is already in use, u can reconfigure the port u want to use see: [Optional](#optional)
