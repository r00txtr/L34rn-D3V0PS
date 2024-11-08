# Lab 1: Install Jenkins with Docker

In this lab, you will learn how to install **Jenkins** on an Ubuntu machine. Jenkins is an open-source automation server that facilitates continuous integration and delivery (CI/CD), making it easier to build, test, and deploy software projects. By setting up Jenkins with Docker, you can streamline containerized CI/CD workflows.

By the end of this lab, you will:

1. Install Docker and create a bridge network for Jenkins.
2. Run a Docker-in-Docker (dind) container for Jenkins.
3. Configure and start a custom Jenkins Docker image.
4. Unlock Jenkins and access its setup wizard.

---

## Table of Contents

1. **Introduction**
2. **Step-by-Step Instructions**
   1. Installing Docker on Ubuntu
   2. Creating a Docker Bridge Network for Jenkins
   3. Running a Docker-in-Docker (dind) Container
   4. Building a Custom Jenkins Image
   5. Running Jenkins with the Custom Image
3. **Verification**
4. **Conclusion**

---

## Introduction

In this lab, you’ll set up Jenkins in a Docker environment, using Docker-in-Docker (dind) to run Docker commands within Jenkins containers. This setup allows Jenkins agents to use Docker seamlessly.

We’ll accomplish the following:

1. Install Docker and create a Docker network.
2. Configure a Docker-in-Docker container for Jenkins.
3. Build and run a Jenkins Docker image with Docker CLI.
4. Access Jenkins through a web interface to complete the initial setup.

---

## Step-by-Step Instructions

### Step 1: Installing Docker on Ubuntu

First, install Docker on your Ubuntu machine. Docker enables you to run containers, which will be used to host Jenkins and Jenkins agents.

#### 1.1 Update the Package Index

Run the following commands to update the system and install required packages:

```bash
sudo apt-get update
sudo apt-get install -y ca-certificates curl
```

#### 1.2 Add Docker’s Official GPG Key and Repository

Set up Docker’s repository for Ubuntu:

```bash
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

#### 1.3 Install Docker

Install Docker and its associated plugins:

```bash
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-compose
```

#### 1.4 Add User to Docker Group

Allow your user to run Docker commands without `sudo`:

```bash
sudo groupadd docker
sudo usermod -aG docker $USER
sudo chmod 666 /var/run/docker.sock
```

#### 1.5 Verify Docker Installation

Run a test container to verify Docker is installed correctly:

```bash
docker run hello-world
```

---

### Step 2: Creating a Docker Bridge Network for Jenkins

Create a dedicated bridge network for Jenkins using the following command:

```bash
docker network create jenkins
```

---

### Step 3: Running a Docker-in-Docker (dind) Container

In this step, you’ll set up a Docker-in-Docker container. This container enables Jenkins agents to execute Docker commands.

#### 3.1 Run the Docker-in-Docker Container

Run the following command to start a `docker:dind` / `docker:latest` container:

```bash
docker run \
  --name jenkins-docker \
  --restart=on-failure \
  --detach \
  --privileged \
  --network jenkins \
  --network-alias docker \
  --env DOCKER_TLS_CERTDIR=/certs \
  --volume jenkins-docker-certs:/certs/client \
  --volume jenkins-data:/var/jenkins_home \
  --publish 2376:2376 \
  docker:dind \
  --storage-driver overlay2
```

Explanation of Flags:

- `--privileged`: Enables Docker-in-Docker functionality.
- `--network jenkins`: Connects to the Jenkins network.
- `--network-alias docker`: Makes the container accessible as "docker" within the network.
- `--env DOCKER_TLS_CERTDIR=/certs`: Enables TLS for security.
- `--publish 2376:2376`: Exposes the Docker daemon port.
  
---

### Step 4: Building a Custom Jenkins Image

Create a Dockerfile to customize Jenkins with Docker CLI capabilities.

#### 4.1 Create a Dockerfile

Create a Dockerfile with the following content:

```dockerfile
FROM jenkins/jenkins:2.479.1-jdk17
USER root

# Add DNS nameservers to /etc/resolv.conf
RUN echo "nameserver 8.8.8.8" >> /etc/resolv.conf && \
    echo "nameserver 1.1.1.1" >> /etc/resolv.conf

RUN apt-get update && apt-get install -y lsb-release
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg
RUN echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -y docker-ce-cli

USER jenkins
RUN jenkins-plugin-cli --plugins "blueocean docker-workflow"

```

#### 4.2 Build the Docker Image

Run this command to build your custom Jenkins image:

```bash
docker build -t myjenkins-blueocean:2.479.1-1 .
```

---

### Step 5: Running Jenkins with the Custom Image

Run the customized Jenkins container using the following command:

```bash
docker run \
  --name jenkins-blueocean \
  --restart=on-failure \
  --detach \
  --network jenkins \
  --dns 8.8.8.8 --dns 1.1.1.1 \
  --env DOCKER_HOST=tcp://docker:2376 \
  --env DOCKER_CERT_PATH=/certs/client \
  --env DOCKER_TLS_VERIFY=1 \
  --publish 8080:8080 \
  --publish 50000:50000 \
  --volume jenkins-data:/var/jenkins_home \
  --volume jenkins-docker-certs:/certs/client:ro \
  myjenkins-blueocean:2.479.1-1
```

Explanation:

- `--restart=on-failure`: Restarts the container automatically if it stops.
- `--network jenkins`: Connects to the Jenkins network.
- `--publish 8080:8080`: Exposes Jenkins UI on port 8080.
- `--publish 50000:50000`: Enables agent communication on port 50000.

---

## Verification

To verify that the lab was completed successfully, check the following:

1. **Docker Installation**: Run `docker run hello-world` to confirm Docker is functioning.
2. **Docker Network**: List Docker networks to confirm the "jenkins" network was created.
3. **Docker-in-Docker**: Verify `docker ps` shows the running `jenkins-docker` container.
4. **Jenkins Access**: Access Jenkins by navigating to `http://localhost:8080` in a browser.

---

## Conclusion

In this lab, you successfully installed Jenkins in a Docker environment and set up a Docker-in-Docker configuration for Jenkins agents to execute Docker commands. This setup allows for robust CI/CD workflows in containerized environments.

Proceed to complete the Jenkins setup wizard and start building automation jobs!
