# Lab 7: Creating a Simple Jenkins Declarative Pipeline with Maven on Docker Agent Part 2 and Configuring Network Routing with Socat

In this lab, you will expand your Jenkins Pipeline by adding stages to build a Docker image and deploy it. This will allow Jenkins to compile a project, package it into a Docker container, and run it, demonstrating the ability to automate deployment tasks as part of the CI/CD process.

By the end of this lab, you will:
1. Update your existing Jenkins Pipeline script to add stages for building and running a Docker image.
2. Use `socat` to route network traffic to the Docker container.
3. Access the application on [https://localhost:9000](https://localhost:9000).

---

## Table of Contents

1. **Introduction**
2. **Step-by-Step Instructions**
   - Adding Stages to the Pipeline Script
   - Configuring Network Routing with Socat
   - Verifying the Application Deployment
3. **Console Output Verification**
4. **Conclusion**

---

## Step-by-Step Instructions

### Step 1: Updating the Pipeline Script

Extend your previous pipeline by adding new stages to build and run the Docker image.

1. **Navigate** to the configuration page of your Jenkins project.
2. **Modify the Pipeline Script** to include the following code, adding the `Build Docker Image` and `Run Docker Image` stages:

    ```groovy
    pipeline {
        agent none
        stages {
            stage('Maven Compile') {
                agent {
                    label 'Maven-Labels'  // Assumes Maven-Labels agent template is configured and available
                }
                steps {
                    git 'https://github.com/r00txtr/VulnerableJavaWebApplication.git'
                    sh 'mvn compile'
                }
            }
            stage('Build Docker Image') {
                agent {
                    docker {
                        image 'docker:latest'  // Base docker image; docker:dind isn't necessary here
                        args '--privileged -u root -v /var/run/docker.sock:/var/run/docker.sock'
                    }
                }
                steps {
                    sh 'docker build -t java-vulnerable-application:0.1 .'
                }
            }
            stage('Run Docker Image') {
                agent {
                    docker {
                        image 'docker:latest'  // Using a docker image without dind for container control
                        args '--privileged -u root -v /var/run/docker.sock:/var/run/docker.sock'
                    }
                }
                steps {
                    // Clean up any existing container with the same name
                    sh 'docker rm -f vulnerable-java-application || true' 
                    sh 'docker run --name vulnerable-java-application -p 9000:9000 -d java-vulnerable-application:0.1'
                }
            }
        }
    }

    ```

3. **Save** the pipeline script.

### Step 2: Configuring Network Routing with Socat

1. **Run the following Socat command** on the Jenkins server to route traffic to the Docker container:

    ```bash
    docker run -d -p 9000:9000 --network=jenkins --name socat alpine/socat TCP-LISTEN:9000,fork TCP:172.21.0.3:9000
    ```

2. **Update the IP address** (`172.21.0.3`) with the actual IP of your container network. To get the IP, use the following command:

    ```bash
    docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' jenkins-docker
    ```

3. Verify the Socat container is up and correctly routing traffic by listing the running containers:

    ```bash
    docker ps
    ```

### Step 3: Verifying the Application Deployment

1. **Access the application** by visiting [https://localhost:9000](https://localhost:9000) in a browser.
2. **Confirm the application** loads successfully, indicating that both the Jenkins pipeline and Socat traffic routing are functional.

---

## Console Output Verification

In **Console Output**, expect logs confirming each stage's success:

```plaintext
Successfully built java-vulnerable-application:0.1
Successfully tagged java-vulnerable-application:0.1
```

These lines indicate:
- Docker image was built successfully.
- The container ran without issues and is accessible on port 9000.

---

## Conclusion

In **Lab 7**, you extended your Jenkins Pipeline to build and deploy a Docker image. By using `socat` for network routing, you configured external access to the deployed application, demonstrating a vital step in automating deployment within a CI/CD pipeline. 

Congratulations on completing **Lab 7: Creating a Simple Jenkins Declarative Pipeline with Maven on Docker Agent Part 2**!