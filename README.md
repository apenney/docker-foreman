$ docker run --name postgres -e POSTGRES_PASSWORD=foreman -d postgres:9.4
$ docker run --name foreman --link postgres:pg -e VHOST_NAME=foreman.internal.ntoggle.com foreman
