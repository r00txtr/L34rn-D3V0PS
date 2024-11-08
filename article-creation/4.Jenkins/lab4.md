# Lab 4: Configuring Docker Build Agent Templates in Jenkins

In this lab, you'll set up and configure Docker Build Agent templates within Jenkins. Docker Build Agents allow Jenkins to use customized Docker container images as build agents, tailored to specific project requirements. You'll explore various settings for configuring these agents, including specifying Docker images, container capacity, labels, and connection methods.

By the end of this lab, you will:

1. Configure Docker Build Agent templates in Jenkins.
2. Set specific labels, container settings, and connection methods.
3. Ensure the Docker Build Agents are configured to run Maven builds and are ready for CI/CD operations.

---

## Table of Contents

1. **Introduction**
2. **Overview**
3. **Step-by-Step Instructions**
    1. Managing Jenkins Nodes and Clouds
    2. Configuring Docker Agent Templates
4. **Verification**
5. **Conclusion**

---

## Introduction

This lab focuses on configuring Docker Build Agent templates in Jenkins. By using Docker containers as build agents, Jenkins can streamline and isolate build processes, particularly in CI/CD workflows that require specific environments. Here, you'll set up Docker agent templates with Maven configuration to build Java applications.

---

## Overview of Lab 4: Docker Build Agent Template Configuration

In this lab, you’ll configure Docker Build Agent templates within Jenkins, focusing on creating a template optimized for Maven builds. Key settings will include setting agent labels, defining Docker image settings, and configuring container properties like capacity, idle timeout, and connection methods.

### Why Use Docker Build Agent Templates?

Using Docker Build Agent templates allows you to:

1. **Automate Resource Allocation**: Automatically spin up agents with pre-defined environments when builds are triggered.
2. **Isolate Build Environments**: Use containerized agents to avoid conflicts across different projects.
3. **Enhance Scalability**: Templates simplify the addition of multiple agents as project demands increase.

---

## Step-by-Step Instructions

### Step 1: Manage Jenkins Nodes and Clouds

1. From the **Jenkins Dashboard**, select **Manage Jenkins**.
2. Click on **Manage Nodes and Clouds**.
3. Under Clouds, find and select your existing Docker Cloud configuration, labeled as **Docker-Build-Agent** (or create a new cloud configuration if needed).

---

### Step 2: Configuring Docker Agent Templates

Within the Docker Cloud configuration, you will create a new Docker Agent Template optimized for Maven builds:

Notes: If you new, just fill the Labels, Name and Docker Image, Instance Capacity, Usage: Only build jobs with label expressions matching this node, and save.

1. **Add a New Docker Agent Template**:
   - Click on **Add Docker Template**.

2. **Configure Template Settings**:
   - **Labels**: Set specific labels for identifying this template. For example:
     - **Labels**: `maven-agent`
     - **Maven Labels**: Useful for filtering jobs specific to Maven builds.

   - **Enabled**: Ensure the template is marked as enabled to be used by Jenkins.

3. **Name and Docker Image**:
   - **Name**: Set a descriptive name, such as **Maven-Build-Agent**.
   - **Docker Image**: Specify the Docker image to use for this agent:
     - For Maven, use: `maven:3.9.9-eclipse-temurin-11`

4. **Registry Authentication**: If the Docker image requires authentication to pull, configure the necessary registry credentials here.

5. **Container Settings**:
   - **Instance Capacity**: Set the maximum number of agents Jenkins can spin up for this template. For instance:
     - **Instance Capacity**: `2`
   - **Remote File System Root**: Specify the path inside the container where Jenkins files will be stored (e.g., `/home/jenkins`).

6. **Usage**:
   - Select **Only build jobs with label expressions matching this node** to restrict the agent's usage to jobs requiring this specific configuration.

7. **Idle Timeout**:
   - Set the idle timeout for the agent container:
     - **Idle Timeout**: `10` minutes (auto-terminates if idle).

8. **Connect Method**:
   - Choose **Attach Docker container** as the connection method.
   - **Prerequisites**:
     - The Docker image must have Java installed.
     - The Docker image’s `CMD` should either be empty or set to wait indefinitely (e.g., `/bin/bash`).
     - The Jenkins agent code will be copied into the container and run using Java within it.

   **Example**: You may refer to Docker images like `jenkins/agent` or `jenkinsci/docker-agent` for guidance.

9. **Additional Configuration**:
   - **User**: Define the user under which Jenkins should run.
   - **Java Executable**: Path to the Java executable within the container (if needed).
   - **JVM Arguments**: Configure additional JVM arguments as required.

10. **EntryPoint Cmd**: Leave this field as default unless specific commands are needed.

11. **Stop Timeout**:
    - Set the stop timeout to specify how long Jenkins waits for the agent to shut down gracefully:
      - **Stop Timeout**: `10` seconds.

12. **Volume Settings**:
    - **Remove Volumes**: Enable this to automatically remove volumes after the agent stops.

13. **Pull Strategy**:
    - **Pull all images every time**: Ensure that Jenkins pulls the latest image version for each build.
    - **Pull Timeout**: Set a pull timeout:
      - **Pull Timeout**: `300` seconds.

14. **Node Properties**:
    - Add any required node properties under **Add Node Property** as needed for your setup.

15. **Save**: Once all configurations are complete, click **Save** to apply your settings.

---

## Verification

To verify your Docker Agent configuration:

1. Go to **Manage Nodes and Clouds** in Jenkins.
2. Confirm the presence of the **Maven-Build-Agent** configuration under Docker Cloud.
3. Run a test job with label `maven-agent` to confirm that Jenkins successfully provisions the Docker container and completes the build.

---

## Conclusion

In **Lab 4**, you configured Docker Build Agent templates within Jenkins, using a Maven Docker image to support Java builds. This configuration enhances Jenkins' ability to provision and manage build agents dynamically, optimizing resource allocation and supporting a flexible CI/CD pipeline.

Congratulations on completing **Lab 4: Configuring Docker Build Agent Templates in Jenkins**! You now have a tailored Docker agent setup ready to handle your build jobs efficiently.
