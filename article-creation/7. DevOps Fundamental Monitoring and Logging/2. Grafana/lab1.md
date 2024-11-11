# Lab 1: Install and Configure Grafana for Beginners

## Introduction

This lab will guide you through the installation and initial configuration of **Grafana**, a powerful open-source platform for monitoring and observability. By the end of this lab, you will have a Grafana instance running, connected to a Prometheus data source. This setup is ideal for monitoring metrics in a clear and organized way.

## Prerequisites

- Basic familiarity with Linux command line
- A server or virtual machine running Ubuntu or a similar Linux distribution
- Internet connection for downloading Grafana

## Step-by-Step Instructions

### Step 1: Install Grafana

#### Method 1: Manual Installation from Tarball

1. **Switch to superuser**:

    ```bash
    sudo su -
    ```

2. **Navigate to the `/opt` directory**:

    ```bash
    cd /opt
    ```

3. **Download the Grafana tarball**:

    ```bash
    wget https://dl.grafana.com/oss/release/grafana-11.3.0.linux-amd64.tar.gz
    ```

4. **Extract the tarball**:

    ```bash
    tar -zxvf grafana-11.3.0.linux-amd64.tar.gz
    ```

5. **Navigate to the extracted Grafana directory**:

    ```bash
    cd /opt/grafana-11.3.0.linux-amd64
    ```

6. **Start Grafana**:

    ```bash
    ./bin/grafana-server web
    ```

    **Note**: At this point, Grafana should be running, but only in your current session. Press `Ctrl + C` to stop it if needed.

### Step 2: Access Grafana Web Interface

- Open your browser and go to:

    ```
    http://<YOUR_SERVER_IP>:3000/login
    ```

- **Important**: The default login credentials are:
  - **Username**: `admin`
  - **Password**: `admin`

- Upon first login, you will be prompted to change the password for security reasons.

### Step 3: Set Up Grafana as a Service

1. **Create a systemd service file**:

    ```bash
    vim /etc/systemd/system/grafana.service
    ```

2. **Add the following configuration**:

    ```ini
    [Unit]
    Description=Grafana

    [Service]
    User=root
    ExecStart=/opt/grafana-11.3.0/bin/grafana-server -homepath /opt/grafana-11.3.0/ web

    [Install]
    WantedBy=default.target
    ```

3. **Reload the systemd daemon**:

    ```bash
    sudo systemctl daemon-reload
    ```

4. **Enable and start the Grafana service**:

    ```bash
    sudo systemctl enable --now grafana.service
    ```

5. **Check Grafana's status**:

    ```bash
    sudo systemctl status grafana.service
    ```

6. **Review service logs (optional)**:

    ```bash
    sudo journalctl -u grafana
    ```

#### Method 2: Install via APT Repository

1. **Install prerequisite packages**:

    ```bash
    sudo apt-get install -y apt-transport-https software-properties-common wget
    ```

2. **Import the GPG key**:

    ```bash
    sudo mkdir -p /etc/apt/keyrings/
    wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null
    ```

3. **Add the repository**:
    - For stable releases:

        ```bash
        echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
        ```

4. **Update the package list**:

    ```bash
    sudo apt-get update
    ```

5. **Install Grafana OSS**:

    ```bash
    sudo apt-get install grafana
    ```

6. **Start and enable Grafana**:

    ```bash
    sudo systemctl enable --now grafana
    ```

### Step 4: Add a Prometheus Data Source to Grafana

1. **Log in to Grafana**.
2. **Navigate to**: `Connections > Data Source > Add new data source`.
3. **Choose** `Prometheus` as the data source type.
4. **Configure the following**:
    - **Name**: `Prometheus-server`
    - **URL**: `http://<PROMETHEUS_SERVER_IP>:9090`
5. **Save & Test** to verify the connection.

### Step 5: Verification

- **Check Grafana**:
  - Open Grafana in your browser to ensure it's up and running.
- **Verify Prometheus connection**:
  - Confirm the **"Successfully queried the Prometheus API"** message.
  - Ensure `Prometheus-server` appears in the **Data Sources** list.

## Conclusion

Congratulations! You have successfully installed Grafana, set it up as a service, and connected it to a Prometheus data source. This foundational setup will help you monitor and visualize your metrics effectively.

Feel free to experiment with Grafana's various visualization options to get the most out of your monitoring experience.
