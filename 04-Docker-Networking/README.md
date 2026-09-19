# Exercise 4: Docker Networking with Multiple Containers

## Objective
Create a user defined **bridge network** in Docker and run three containers on it (Flask API, MySQL and Redis). Verify that the containers can find and talk to each other using their **container names**, without hardcoding IP addresses.

---

## Scenario
A web application normally needs an API server, a database and a cache. In production these run as separate containers. They must be able to reach each other on a private network, while only the API port is published to the host.

```
          host:5001
              |
   +----------|-------------------------------+
   |   my-bridge-net (user defined bridge)    |
   |                                           |
   |   [flask] <---> [mysql]                   |
   |      \                                    |
   |       '-----> [redis]                     |
   +-------------------------------------------+
```

---

## Concepts Used
| Network type | Description |
|---|---|
| **bridge (default)** | Containers get an IP but cannot resolve each other by name |
| **user defined bridge** | Built-in DNS, containers resolve each other by container name; better isolation |
| **host** | Container shares the host network stack |
| **none** | No networking |

---

## Files
| File | Purpose |
|---|---|
| `app.py` | Flask REST API with `GET /about`, runs on port 5001 |
| `requirements.txt` | Flask==2.0.1 |
| `Dockerfile` | Builds the API image from `python:3.9-slim`, exposes 5001 |

---

## Steps

### Task 1: Create a bridge network
```bash
docker network create my-bridge-net
```

### Task 2: Verify the network
```bash
docker network ls
```
```
NETWORK ID     NAME            DRIVER    SCOPE
3c1f0a8d2b6e   bridge          bridge    local
9a7e2d41c0f3   my-bridge-net   bridge    local
```

### Task 3: Inspect the network
```bash
docker network inspect my-bridge-net
```
Shows the subnet (for example `172.18.0.0/16`), gateway and, after Task 4, the containers attached with their IPs.

### Task 4: Build the API image and launch the containers
```bash
docker build -t flask-api .

docker run -d --name mysql --net=my-bridge-net -e MYSQL_ROOT_PASSWORD=root mysql:latest
docker run -d --name redis --net=my-bridge-net redis:latest
docker run -d --name flask --net=my-bridge-net -p 5001:5001 flask-api

docker ps
```

### Task 5: Test the API from the host
```bash
curl http://localhost:5001/about
```
```json
{"description": "This is a simple REST API built with Flask.", "name": "Simple REST API", "version": "1.0"}
```

### Task 6: Test container to container communication
```bash
docker exec -it flask bash
apt-get update && apt-get install -y iputils-ping
ping -c 3 mysql
ping -c 3 redis
exit
```
```
PING mysql (172.18.0.2) 56(84) bytes of data.
64 bytes from mysql.my-bridge-net (172.18.0.2): icmp_seq=1 ttl=64 time=0.09 ms
```
The names `mysql` and `redis` resolve to their container IPs through Docker's embedded DNS.

### Task 7: Check which containers are on the network
```bash
docker network inspect my-bridge-net --format '{{range .Containers}}{{.Name}} {{.IPv4Address}}{{"\n"}}{{end}}'
```

---

## Observations
- On a user defined bridge, containers reach each other by name. On the default bridge this does not work.
- Only the Flask port (5001) is published to the host. MySQL and Redis stay private inside the network.
- The Flask app must listen on `0.0.0.0` so it is reachable from outside the container.

---

## Cleanup
```bash
docker stop mysql redis flask && docker rm mysql redis flask
docker network rm my-bridge-net
```
