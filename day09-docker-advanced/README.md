# Day 09: Docker Volumes, Networking & Docker Compose

## What I did today
Went deeper into Docker beyond single containers - learned how to persist data with volumes, how containers discover and talk to each other over a custom network, how to configure containers with environment variables, and finally combined all three into a single Docker Compose setup running a web server and a MySQL database together.

## Concepts and Commands Learned

### Volumes - Data Persistence
Without a volume, all data inside a container is lost when the container is deleted. Volumes store data outside the container, on the host, so it survives container restarts or deletion.
```bash
docker volume create volumename
docker run -v volumename:/path/in/container image
```
**Real use:** essential for any database container - losing a container should never mean losing the data.

### Networking - Container-to-Container Communication
```bash
docker network create networkname
docker run -d --name x --network networkname image
```
**Key concept:** containers reach each other by **name**, not IP. Docker runs its own internal DNS - when I ran `ping container1` from another container on the same custom network, Docker resolved that name to its internal IP automatically.
64 bytes from container1.mynetwork (172.18.0.2)
### Environment Variables - Runtime Configuration
```bash
docker run -e VARNAME=value image
```
Used this to spin up a MySQL container without touching the image itself:
```bash
docker run -d --name mydb \
  -e MYSQL_ROOT_PASSWORD=mypassword123 \
  -e MYSQL_DATABASE=testdb \
  mysql:latest
```
Verified the database was created using `docker exec`, which runs a command inside an already-running container (different from `docker run`, which creates a new one).

### Docker Compose - Multi-Container Setup
Instead of writing multiple long `docker run` commands, defined the entire setup in one YAML file:
```yaml
services:
  webapp:
    image: nginx:latest
    ports:
      - "8080:80"
    networks:
      - myappnetwork
  database:
    image: mysql:latest
    environment:
      MYSQL_ROOT_PASSWORD: mypassword123
    volumes:
      - dbdata:/var/lib/mysql
    networks:
      - myappnetwork
networks:
  myappnetwork:
volumes:
  dbdata:
```
```bash
docker compose up -d     # start everything
docker compose ps        # check status
docker compose down      # stop and remove everything
```
Verified both the nginx welcome page (localhost:8080) and the MySQL database were up and connected on the same custom network.

## Where I got stuck
Took a self-quiz after this session and got tripped up on two things: first, I initially said containers reach each other "by IP" instead of by name - even though I had just tested this with `ping` using a container name. Had to go back and separate two ideas: what I specify (the name) versus what Docker resolves internally (the IP). Second, I blanked on what the `networks:` key does inside a Compose file, even though I'd written it minutes earlier - a sign I was typing the file without fully parsing each line as I went.

## Files in this folder
- `docker-compose.yml` - defines a web server + MySQL database, connected via a custom network, with persistent storage for the database

## Interview Question Prep

**Q: Why do you need volumes for a database container specifically?**
A: Without a volume, all data is lost if the container is deleted or crashes. A volume stores the data on the host, outside the container's lifecycle, so it persists regardless of what happens to the container.

**Q: How do containers communicate with each other by name?**
A: On a custom Docker network, Docker provides internal DNS resolution - a container can reach another by its name, and Docker resolves that name to the container's internal IP automatically.

**Q: What's the advantage of Docker Compose over multiple docker run commands?**
A: The whole multi-container setup - containers, networks, volumes, and environment variables - lives in one version-controlled YAML file. Anyone on the team can reproduce the exact same environment with a single command instead of remembering a long sequence of manual commands.

**Q: Difference between docker run and docker exec?**
A: `docker run` creates and starts a new container. `docker exec` runs a command inside a container that's already running.
