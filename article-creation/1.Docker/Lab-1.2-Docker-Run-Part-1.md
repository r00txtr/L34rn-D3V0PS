# Lab 1.2: Docker Run - Part 1

In this lab, we will learn how to search, run, and manage Docker containers. We will work with two popular images, Redis and Nginx, from DockerHub. We will walk through starting containers, managing them, and interacting with them using Docker commands.

This guide assumes you have Docker installed and are running these commands on a specific node, `pod-[username]-node01`. If you have not installed Docker yet, please refer to [Lab 1.1: Installing Docker](previous lab).

---

## Table of Contents

1. **Introduction**
2. **Working with Redis Docker Image**
    1. Search Redis Image
    2. Run Redis Container
    3. Manage Running Redis Container
3. **Working with Nginx Docker Image**
    1. Search Nginx Image
    2. Run Nginx Container and Expose Ports
    3. Manage Running Nginx Container
4. **Verification**

---

## Introduction

In this lab, we will cover two Docker use cases:

1. Running a **Redis** container: Redis is an in-memory data structure store, often used as a database, cache, and message broker.
2. Running an **Nginx** container: Nginx is a popular web server often used for reverse proxying, caching, and load balancing.

We will first search for these images, run them, expose ports for Nginx, and finally verify everything is working.

---

## Working with Redis Docker Image

### 1. Search Redis Image

You can search for the Redis image from both **DockerHub** (the default Docker image registry). Let’s explore how to do this.

#### 1.1 Search Redis from DockerHub

To search for Redis images on DockerHub, use:

```bash
docker search redis
```

This will return a list of Redis images available from DockerHub. Look for official and popular images.

---

### 2. Running Redis Container

Let’s now run a Redis container from the DockerHub registry.

#### 2.1 Basic Redis Run Command

```bash
docker run redis:latest
```

This command runs a Redis container interactively. To exit, use `CTRL + C`.

#### 2.2 Running Redis in the Background (Detached Mode)

If you don’t want the Redis container to block the terminal, run it in the background using the `-d` flag:

```bash
docker run -d redis:latest
```

This allows the container to run in "detached" mode, meaning it runs in the background.

#### 2.3 Giving the Container a Name

You can name your Redis container for easier management:

```bash
docker run -d --name redis1 redis:latest
```

This command assigns the name `redis1` to the container.

---

### 3. Managing Running Redis Container

Once your Redis container is running, you can manage and inspect it using various Docker commands.

#### 3.1 Display Running Containers

To see all running containers:

```bash
docker ps
```

or

```bash
docker container ls
```

#### 3.2 Display All Containers (Active or Inactive)

To list all containers, whether active or stopped:

```bash
docker ps -a
```

or

```bash
docker container ls -a
```

#### 3.3 Display Detailed Container Information

You can inspect a container to get detailed information like network settings, volume mounts, and configuration using:

```bash
docker inspect redis1
```

#### 3.4 Display Container Logs

To view logs generated by the Redis container:

```bash
docker logs redis1
```

This displays the logs related to the Redis container.

#### 3.5 Monitor Resource Usage

To monitor live resource usage (CPU, memory, etc.) of the container:

```bash
docker stats redis1
```

#### 3.6 Display Running Processes Inside Container

To see the processes running inside the Redis container:

```bash
docker top redis1
```

#### 3.7 Stop the Redis Container

To stop the container gracefully:

```bash
docker stop redis1
```

---

## Working with Nginx Docker Image

### 1. Search Nginx Image

Just like Redis, we can search for the Nginx image from both DockerHub.

#### 1.1 Search Nginx from DockerHub

```bash
docker search nginx
```

This returns a list of Nginx images available from DockerHub.

---

### 2. Running Nginx Container and Exposing Ports

#### 2.1 Running Nginx with Port Exposure

To run an Nginx container and expose it to the host on port 80, use:

```bash
docker run -d --name nginx1 -p 80:80 nginx:latest
```

This command:

- Runs the Nginx container in detached mode (`-d`).
- Exposes container’s port `80` to the host’s port `80`.
- Names the container `nginx1`.

#### 2.2 Inspect Nginx Container

To view the details of the running Nginx container:

```bash
docker inspect nginx1
```

#### 2.3 Run Nginx with Declared Container Port

You can also run Nginx by explicitly defining only the container’s port:

```bash
docker run -d --name nginx2 -p 80 nginx:latest
```

This runs the container `nginx2` and binds the container's port `80`.

#### 2.4 Test Browsing to Nginx

To verify that Nginx is running and accessible, use:

```bash
curl localhost:$(docker port nginx2 80 | cut -d : -f 2)
```

This command checks if the Nginx service is accessible locally.

---

### 3. Managing Running Nginx Containers

#### 3.1 Display Active and Inactive Containers

To list all active or inactive containers:

```bash
docker ps -a
```

#### 3.2 Display Downloaded Docker Images

To see all downloaded Docker images:

```bash
docker images
```

---

## Verification

To ensure everything is working correctly, perform the following checks:

1. **Access Nginx with curl**:
   - You should be able to access the Nginx containers `nginx1` and `nginx2` using `curl` and verify they are serving responses correctly.

2. **Redis Container Running**:
   - Ensure that the Redis container (`redis1`) is up and running by checking it with `docker ps` or inspecting logs with `docker logs redis1`.

---

That’s it for **Lab 1.2: Docker Run - Part 1**. You have learned how to search for images, run containers, expose ports, and manage your containers using Docker commands. These skills form the foundation for working with containers in various environments.

Happy Dockering!
