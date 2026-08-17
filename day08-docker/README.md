# Day 08: Docker Fundamentals

## What I did today
Installed Docker Desktop with WSL integration, learned the core difference between containers and VMs, and worked through the full container lifecycle — from pulling an image to writing my own Dockerfile and building a custom image that served a webpage I wrote myself.

## Concepts and Commands Learned

### Container vs VM
| VM | Container |
|----|-----------|
| Runs a full OS (heavy, GBs) | Runs only app + dependencies (light, MBs) |
| Boots in minutes | Starts in seconds |
| Has its own kernel | Shares the host OS kernel |

**Analogy:** A VM is like building a separate house for every application. A container is like apartments in the same building — sharing the same foundation but running independently.

### Basic Commands
```bash
docker --version          # check Docker is installed
docker run hello-world    # test that Docker is working correctly
docker ps                 # list running containers
docker ps -a               # list all containers, including stopped ones
docker images              # list downloaded images
```

### Running Containers
```bash
docker run -it ubuntu bash        # interactive mode - drops you inside the container
docker run -d --name x nginx      # detached/background mode
docker pull nginx                 # download an image without running it
```

### Managing Containers
```bash
docker logs containername   # view container logs
docker stop containername   # stop a running container
docker rm containername     # delete a stopped container
docker rmi imagename        # delete an image
```

### Writing a Dockerfile
Built a custom image on top of nginx that serves a webpage I wrote:
```dockerfile
FROM nginx:latest
COPY index.html /usr/share/nginx/html/index.html
```
```bash
docker build -t my-custom-nginx .          # build the image
docker run -d -p 8080:80 --name mywebsite my-custom-nginx  # run + map port
```
Verified it worked by opening `http://localhost:8080` in the browser and seeing my own HTML content served from inside the container.

## Where I got stuck
Understanding port mapping (`-p 8080:80`) took a moment — realized it means "my machine's port 8080 forwards to the container's port 80," not that the container itself runs on 8080. Also had to install Docker Desktop and enable WSL integration manually before any of the commands would work.

## Files in this folder
- `Dockerfile` — builds a custom nginx image with my own HTML page
- `index.html` — the custom webpage served by the container

## Interview Question Prep

**Q: What is the difference between a container and a VM?**
A: A VM runs a full operating system, making it heavy and slow to start. A container shares the host OS kernel and only packages the application and its dependencies, making it lightweight and fast to start.

**Q: What is a Dockerfile?**
A: A set of instructions for building a custom Docker image — typically starting with a base image (`FROM`) and adding files or configuration (`COPY`, etc.) on top of it.

**Q: How do you run a container in the background?**
A: `docker run -d --name containername imagename`

**Q: What does the -p flag do in docker run?**
A: Maps a port on the host machine to a port inside the container, e.g. `-p 8080:80` forwards host port 8080 to the container's port 80.

**Q: Difference between docker ps and docker ps -a?**
A: `docker ps` shows only currently running containers. `docker ps -a` shows all containers, including ones that have stopped.
