# Lab 7.1: Configuring Docker Logging Driver

In this lab, we will learn how to configure a logging driver for Docker containers and manage logs efficiently. By setting up a custom logging driver, you can control how Docker stores and rotates logs for containers, ensuring that logs don't grow too large and consume too much disk space. You will configure Docker to use the **json-file** logging driver with log rotation settings.

By the end of this lab, you will:
1. Configure the Docker daemon to use a logging driver with size and file limits.
2. Restart the Docker service to apply the changes.
3. Run a container with the configured logging driver.
4. Verify that logs are being generated and stored correctly.

---

## Table of Contents
1. **Introduction**
2. **Step-by-Step Instructions**
    1. Configuring the Docker Logging Driver
    2. Running a Container with Logging
    3. Verifying the Logs
3. **Verification**
4. **Conclusion**

---


## Introduction

In Docker, logs generated by containers are managed by **logging drivers**. By default, Docker uses the `json-file` logging driver, which stores logs in JSON format. However, this driver can be configured to limit the log file size and the number of log files that Docker retains, which helps manage disk space.

In this lab, we will:
1. Configure the Docker daemon to use the `json-file` logging driver with log rotation settings.
2. Run a container using the logging driver.
3. Verify that logs are stored in the correct location and that they respect the size and rotation limits.

We will execute these steps on `pod-[username]-node01`. Replace `[username]` with your actual username where needed.

---

## Step-by-Step Instructions

### Step 1: Configuring the Docker Logging Driver

We will configure Docker to use the **json-file** logging driver and set options to limit the size of log files and the number of files retained.

#### 1.1 Create or Edit the `daemon.json` File

To configure the logging driver globally for Docker, edit the `daemon.json` file, which is the configuration file for the Docker daemon.

1. Open the `daemon.json` file using `vim`:

   ```bash
   sudo vim /etc/docker/daemon.json
   ```

2. Add the following configuration to set the logging driver and log options:

   ```json
   {
     "log-driver": "json-file",
     "log-opts": {
       "max-size": "10m",
       "max-file": "100"
     }
   }
   ```

   Explanation:
   - `"log-driver": "json-file"`: Specifies that Docker will use the `json-file` driver to store logs in JSON format.
   - `"max-size": "10m"`: Limits each log file to a maximum size of 10 megabytes.
   - `"max-file": "100"`: Specifies that Docker will retain up to 100 log files before overwriting the oldest ones.

#### 1.2 Restart the Docker Daemon

After modifying the `daemon.json` file, you need to restart the Docker daemon to apply the changes.

1. Reload the daemon configuration:

   ```bash
   sudo systemctl daemon-reload
   ```

2. Restart the Docker service:

   ```bash
   sudo systemctl restart docker
   ```

---

### Step 2: Running a Container with Logging

Now that the logging driver is configured, let's run a container and verify that the logs are being written according to the configuration.

1. Run the following command to start a container that prints "hello world" and uses the `json-file` logging driver with a maximum log size of 10MB:

   ```bash
   docker run --log-driver json-file --log-opt max-size=10m alpine echo hello world
   ```

This command runs an Alpine container and prints "hello world" to the logs.

---

### Step 3: Verifying the Logs

Docker stores logs in the `/var/lib/docker/containers` directory. We will verify that the logs are stored in this directory and that they are formatted as JSON.

#### 3.1 Check the Logs in the Docker Directory

1. First, identify the container ID by running:

   ```bash
   docker ps -a
   ```

   The output will display the container ID and its status. Copy the container ID for the Alpine container.

2. Use the container ID to view the logs stored in JSON format. Run the following command to inspect the log file:

   ```bash
   sudo cat /var/lib/docker/containers/$(docker ps --no-trunc -a | grep 'alpine' | awk '{print $1}')/$(docker ps --no-trunc -a | grep 'alpine' | awk '{print $1}')-json.log | jq .
   ```

   **OR**, if you have the container ID, you can replace it in the following command:

   ```bash
   sudo cat /var/lib/docker/containers/CONTAINER_ID/CONTAINER_ID-json.log | jq .
   ```

   This command outputs the logs from the container in JSON format, allowing you to see the log data along with metadata such as timestamps.

---

## Verification

To ensure that the lab was completed successfully, verify the following:

1. The Docker daemon is using the **json-file** logging driver with the configured options (`max-size=10m` and `max-file=100`).
2. Logs for the container are stored in `/var/lib/docker/containers/[CONTAINER_ID]/[CONTAINER_ID]-json.log`.
3. You can view the logs in JSON format, and they include the output from the Alpine container (`"hello world"`).

---

## Conclusion

In this lab, you learned how to:
1. Configure Docker to use the **json-file** logging driver with log rotation settings.
2. Run a Docker container with specific logging options.
3. Verify that the logs are stored correctly and are being rotated based on the size and file limits.

Configuring logging drivers is an essential part of managing Docker containers, as it helps you control disk space usage and ensure that logs are handled efficiently.

### Example Output of Logs:

The logs for the Alpine container should look something like this when viewed in JSON format:

```json
{
  "log": "hello world\n",
  "stream": "stdout",
  "time": "2024-09-30T12:34:56.789012345Z"
}
```

Congratulations on completing **Lab 7.1: Configuring Docker Logging Driver**! You now have a better understanding of how to manage logs in Docker using logging drivers.

Happy Dockering!