# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

## Ruby version
- Ruby 2.3.1p112 (2016-04-26 revision 54768)

## System dependencies
- imagemagick 8:6.8.9.9-7ubuntu4
- redis server 3.2.6
- PostgreSQL 9.6.1

## Configuration
### Install imagemagick
```sh
$ sudo apt-get update
$ sudo apt-get install imagemagick
```
### Install redis server

Install the Build and Test Dependencies
```sh
$ sudo apt-get update
$ sudo apt-get install build-essential tcl
```

Download, Compile, and Install Redis

```sh
$ cd /tmp
$ curl -O http://download.redis.io/redis-stable.tar.gz
$ tar xzvf redis-stable.tar.gz
$ cd redis-stable
$ make
$ make test
$ sudo make install
```

Configure Redis
```sh
$ sudo mkdir /etc/redis
$ sudo cp /tmp/redis-stable/redis.conf /etc/redis
$ sudo nano /etc/redis/redis.conf
```

```
. . .
supervised systemd
. . .
dir /var/lib/redis
. . .
```

Create a Redis systemd Unit File

```
$ sudo nano /etc/systemd/system/redis.service
```

```
[Unit]
Description=Redis In-Memory Data Store
After=network.target

[Service]
User=redis
Group=redis
ExecStart=/usr/local/bin/redis-server /etc/redis/redis.conf
ExecStop=/usr/local/bin/redis-cli shutdown
Restart=always

[Install]
WantedBy=multi-user.target
```

Create the Redis User, Group and Directories

```
$ sudo adduser --system --group --no-create-home redis
$ sudo mkdir /var/lib/redis
$ sudo chown redis:redis /var/lib/redis
$ sudo chmod 770 /var/lib/redis
```

Start and Test Redis

```
$ sudo systemctl start redis
$ sudo systemctl status redis
```

Enable Redis to Start at Boot

```
$ sudo systemctl enable redis
```

### Setting Up PostgreSQL

For PostgreSQL, we're going to add a new repository to easily install a recent version of Postgres.
```
$ sudo sh -c "echo 'deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main' > /etc/apt/sources.list.d/pgdg.list"
$ wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add -
$ sudo apt-get update
$ sudo apt-get install postgresql-common
$ sudo apt-get install postgresql-9.5 libpq-dev
```

The postgres installation doesn't setup a user for you, so you'll need to follow these steps to create a user with permission to create databases. Feel free to replace jhon with your username.

```
$ sudo -u postgres createuser chris -s
```

If you would like to set a password for the user, you can do the following
```
$ sudo -u postgres psql
$ postgres=# \password jhon
```

Change X to your postgres version
```
$ sudo nano /etc/postgresql/9.X/main/pg_hba.conf
```

replace

```
local   all             postgres                                peer
```
to
```
local   all             postgres                                md5
```

Note that changes to pg_hba.conf do not take effect immediately, you must restart or at least reload PostgreSQL to get it to reread pg_hba.conf
```
$ sudo service postgresql restart
```

## Install Application

```
$ cd ~/home
$ cd foodcourt
$ bundle install
```

## Database creation
Setup database configuration
```
sudo nano ~/home/foodcourt/config/database.yml
```

```
default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>

development:
  <<: *default
  database: foodcourt
  username: jhon
  password: 12345678
```

Database initialization
```
$ rails db:create
$ rails db:migrate
```

Load seed data
```
$ rails db:seed
```

## Login Postgres
```
$ sudo su postgres
```

## Create User Postgres
```
$ createuser rpls --pwprompt
```

## Create Database via Postgres
```
$ CREATE DATABASE foodcourt rpls
```

## Backup Database
```
pg_dump DATABASENAME > BACKUP_FILE.sql
```

## Restore Database
```
cat DUMP_FILE.sql | psql DATABASE_NAME
```

## Run Application
```
$ rails s
```

## Services (job queues, cgit remote rename origin upstreame servers, search engines, etc.)
- Web Push Notification  [https://onesignal.com]
- Active Job


## Deployment instructions

* ...
