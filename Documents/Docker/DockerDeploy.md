# Deploy api to docker in Centos 7 (dotnet core 3.1)

### Install docker

Install the yum-utils package

```
$ sudo yum install -y yum-utils

$ sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
```

Install the latest version of Docker Engine

```
$ sudo yum install docker-ce docker-ce-cli containerd.io
```

Start docker

```
$ sudo systemctl start docker
```

Enable docker service

```
$ sudo systemctl enable docker
```

### Install dotnet core 3.1

Command

```
$ sudo rpm -Uvh https://packages.microsoft.com/config/centos/7/packages-microsoft-prod.rpm

$ sudo yum install dotnet-sdk-3.1
```

Verify

```
$ dotnet --info
```

### Config dockerfile:

Add new file named Dockerfile to project (without extension)

Edit Dockerfile
```
FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build-env
COPY . /app
WORKDIR /app

RUN dotnet restore
RUN dotnet build

EXPOSE [Port Number]/tcp
ENV ASPNETCORE_URLS http://*:[Port Number]
ENV ASPNETCORE_ENVIRONMENT docker

ENTRYPOINT dotnet run
```

Copy all project file to a new directory in centos

### Build docker images:

Command

```
$ docker build -t [appname] .
```

Verify

```
$ docker images
```

### Deploy services:

Command

```
$ docker run -d --restart unless-stopped -it -p [IP]:[Incoming Port]:[Exposed Port] --name=[container name] [image name]
// Exposed Port is a port number that is configured in Dockerfile
// restart option: start container automatically unless be stopped manually
// Declare IP to make sure docker listen from IPv4
```

Verify

```
$ docker ps
```

### Some docker commands:

List all containers

```
$ docker container ps -a
```

Start/Stop container

```
$ docker start/stop container_id/Names
```

Remove container

```
$ docker rm container_id/container_name
```

Remove images

```
$ docker rmi image_id/image_name
```

Exec command of service in docker

```
$ docker exec container_name [command]
```

Save docker images to file

```
$ docker save -o [path]/[image_name].tar image_name
```

Load image file to docker

```
$ docker load -i <path to copied image file>
```
