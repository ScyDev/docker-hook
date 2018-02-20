# docker-hook

[![Docker Automated build](https://img.shields.io/docker/automated/stixes/docker-hook.svg)](https://hub.docker.com/r/stixes/docker-hook/)
[![Docker build status](https://img.shields.io/docker/build/stixes/docker-hook.svg)](https://hub.docker.com/r/stixes/docker-hook/)
[![Docker Pulls](https://img.shields.io/docker/pulls/stixes/docker-hook.svg)](https://hub.docker.com/r/stixes/docker-hook/)
[![Docker stars](https://img.shields.io/docker/stars/stixes/docker-hook.svg)](https://hub.docker.com/r/stixes/docker-hook)


This is a Docker wrapping for [`docker-hook`](https://github.com/schickling/docker-hook). This wraps the
very simple webhook with tools that enables updating and deploying a Docker based server.

`docker-hook` listens to incoming HTTP requests and triggers your specified command.

## Features

* Simple usage
* Authentification support
* Built-in tools for updating docker services

## Setup

### Example:

Generate a token, and keep it secret

```sh
$ uuidgen
f14c64f3-1df9-4b98-988a-b58d6289cfcc
```

Start the docker-hook container

```sh
$ docker run -d -e MYENV=stuff -e CMD="sh update.sh" -e TOKEN=f14c64f3-1df9-4b98-988a-b58d6289cfcc -v /var/run/docker.sock:/var/run/docker.sock:ro -v ./scripts/:/root -p 8555:8555 stixes/docker-hook
```

This will generate a token, which is used for authentification, and set the trigger to run `sh update.sh`. Since the update runs in a container context, the docker socket is also mapped in. This allows `update.sh` to use `docker` and `docker-compose` commands for updating containers on the host. The MYENV environment variable is exposed to the script, and can be used to propagate configurations. The hook is exposed on port 8555 and can be called using curl:

```sh
$ curl -x POST http://you.domain.com:7555/f14c64f3-1df9-4b98-988a-b58d6289cfcc
```

### Docker-compose example:

#### docker-compose.yml

This composefile runs the `myapp` image, and the updating hook. The hook needs the 
docker-compose file mapped in, in order to use docker-compose. For security reasons, 
all mappings should be read-only.

```yaml
version: '3'
services:
  myapp:
    image: myimage:latest
    ports:
      - 80:80
  
  appupdater:
    image: stixes/docker-hook:latest
    ports:
      - 8555:8555
    environment:
      CMD: sh /update.sh
      TOKEN: f14c64f3-1df9-4b98-988a-b58d6289cfcc
    workdir: /
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - ./update.sh:/update.sh:ro
      - ./docker-compose.yml:/docker-compose.yml:ro
```

#### update.sh

This file is run in the container context, but has docker tools available.

```sh
#!/bin/sh
docker-compose pull && \
docker-compose up -d myapp
```

## How it works

`docker-hook` is written in plain Python and does have **no further dependencies**. It uses `BaseHTTPRequestHandler` to listen for incoming HTTP requests from Docker Hub and then executes the provided [command](#command) if the [authentification](#auth-token) was successful.



## License

[MIT License](http://opensource.org/licenses/MIT)
