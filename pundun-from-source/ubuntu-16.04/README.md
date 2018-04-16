To build docker image and run a container

```sh
$ docker build -t pundunlabs/pundun-v1.0.8:ubuntu-16.04 .
$ docker run -d -P pundunlabs/pundun-v1.0.8:ubuntu-16.04
```

To get image from dockerhub and start multiple containers.

```sh
$ docker pull pundunlabs/pundun-v1.0.8
$ docker-compose up -d
```

Setup cluster of the two nodes that are definedi n docker-compose.yml file.

> Use tab to find exact pundun name at cluster pull

```sh
$ ssh admin@localhost -p18884
pundun> cluster add_host host0
ok
pundun> cluster pull punduna17449@host1
ok
pundun> cluster show
Cluster: cl01
Node		DC  Rack    Version
pundun4862b4@host0  dc01    rack01  1
punduna17449@host1  dc01    rack01  1

```

Edit docker-compose.yml file and add a local service to use pundun database.
This approach works when services are deployed on same host.
