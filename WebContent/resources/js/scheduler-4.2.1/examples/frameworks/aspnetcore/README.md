# Scheduler ASP.NET Core demo

This demo shows Scheduler component working with backend on ASP.NET Core with MySQL as a database.

## Setup

There are few ways to start the application:

1. [Manual installation](#manual-installation)
2. [Using Docker](#using-docker) (recommended)
3. [Use Docker for MySQL and platform-native .NET Core](#Docker-+-platform-native-.NET)

<a name="manual"></a>
## Manual installation

### Prerequisites
1. MySQL server
2. .NET Core 3.1
3. ASP.NET Core 3.1
4. NodeJS 10+

### Setup MySQL server

1. Create new database called `bryntum_scheduler`
    
    ```
    CREATE DATABASE IF NOT EXISTS `bryntum_scheduler`;
    ```

2. Create new user

    ```
    CREATE USER 'USERNAME'@'%' IDENTIFIED BY 'PASSWORD';
    GRANT ALL ON `bryntum_scheduler`.* TO 'USERNAME'@'%';
    ```

3. Setup tables with initial data

    ```
    aspnetcore$ mysql -uUSERNAME -pPASSWORD bryntum_scheduler < ./sql/setup.sql
    ```

If setup was successful you should see this output from mysql

```
# mysql -ubryntum -pbryntum bryntum_scheduler
mysql> show tables;
+-----------------------------+
| Tables_in_bryntum_scheduler |
+-----------------------------+
| events                      |
| options                     |
| resources                   |
+-----------------------------+
3 rows in set (0.00 sec)
```

### Build JS application

JS application uses Bryntum private NPM repo, so you should login there first to install the package. See [NPM Packages
Guide](https://bryntum.com/docs/scheduler/#guides/packages.md) for detailed information on the sign-up/login process.

```
aspnetcore$ (cd BryntumSchedulerDemo/wwwroot/app && npm i && npm run build)
```

### Building .NET application

Use IDE (Visual Studio 2019, VS Code + extenstions, etc) to open solution. Alternatively, you can use CLI:

1. Install NuGet packages
    ```
    aspnetcore$ cd BryntumSchedulerDemo
    BryntumSchedulerDemo$ dotnet restore
    ```
2. Change MySQL connection settings at `BryntumSchedulerDemo/appsettings.json`

3. Run app
    ```
    BryntumSchedulerDemo$ dotnet run
    info: Microsoft.Hosting.Lifetime[0]
          Now listening on: http://localhost:5000
    info: Microsoft.Hosting.Lifetime[0]
          Application started. Press Ctrl+C to shut down.
    info: Microsoft.Hosting.Lifetime[0]
          Hosting environment: Development
    info: Microsoft.Hosting.Lifetime[0]
          Content root path: ...Scheduler\examples\aspnetcore\BryntumSchedulerDemo
    ```

Now you can open application at http://localhost:5000

<a name="docker"></a>
## Using Docker

### Prerequisites

1. [Docker](https://docs.docker.com/install/)
2. NodeJS 10+

### Install Docker

Refer to the docker docs to learn how to install Docker:
https://docs.docker.com/install/

If you are using Linux, make sure to follow post-installation steps described in this guide:
https://docs.docker.com/install/linux/linux-postinstall/

### Configure

There is a `docker-compose.yml` config in the application root folder which specifies environment required to run the
application. Environment is just two containers:

1. [MySQL](https://hub.docker.com/_/mysql) version 8.0. 

    Container will have MySQL dabase with a required tables created, running on default port, exposed to localhost:33061.

2. [ASP.NET Core Runtime](https://hub.docker.com/_/microsoft-dotnet-core-aspnet/) version 3.1.

    Container will build and run ASP.NET Core application, exposed to localhost:8080.

### Obtain Bryntum private NPM repo token

JS application requires `@bryntum/scheduler` package which is available in a private NPM repo. To allow docker image
to install this package you should log into private NPM repo from the container. Docker guides recommend to use auth
token. App container accepts NPM token as a build argument. To obtain a token:

1. Log into private NPM repo from the local machine as described in
[Npm Packages Guide](https://bryntum.com/docs/scheduler/#guides/packages.md)

2. See auth token:
    ```
    $cat ~/.npmrc
    registry=http://registry.npmjs.org/
    @bryntum:registry=https://npm.bryntum.com
    //npm.bryntum.com/:_authToken=...
    ```
3. Copy auth token from `.npmrc` which is located in your home directory to the docker-compose.yml:
    ```
    bryntum_scheduler_aspnetcore:
            build: .
                args:
                    NPM_TOKEN: ...
    ```

### Start

To start application with docker it is enough to call:

    aspnetcore$ docker-compose up

Now wait until mysql container is up and listening to connection, you will see this message in console

```
/usr/sbin/mysqld: ready for connections. Version: '8.0.19'
  socket: '/var/run/mysqld/mysqld.sock'  port: 3306  MySQL Community Server - GPL.
  ```

meaning app is ready to use. Navigate to http://localhost:8080/ and see.

## Docker + platform-native .NET

This is convenient way to develop application in IDE without having to install and setup MySQL database.

### Prerequisites

1. [Docker](https://docs.docker.com/install/)
2. NodeJS 10+
3. .NET Core 3.1
4. ASP.NET Core 3.1

### Setup

1. Start MySQL container

    Run this to only start MySQL container

        docker-compose up -d db

    MySQL will be listening on `localhost:33061`

2. Build JS/.NET Application

    Build JS and .NET applications as described in the [Manual installation](#dotner) section

