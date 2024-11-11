# Lab 3: Load Balancing with HAProxy and Monitoring with Grafana

## Introduction

In this lab, you will create a load balancer using **HAProxy** and monitor its performance using **Grafana**. This step-by-step guide will help you set up a Docker network, configure Nginx containers as backend servers, and create a Grafana dashboard to visualize HAProxy metrics.

## Prerequisites

- Basic knowledge of Docker and command-line usage
- Prometheus and Grafana installed and configured

## Step-by-Step Instructions

### Step 1: Create a Docker Network

Create a Docker network to allow communication between containers.

1. Run the following command to create a bridge network named `web_network`:

    ```bash
    docker network create web_network
    ```

### Step 2: Create Nginx Containers

Create two Nginx containers connected to the `web_network` with different ports.

1. **Create `nginx-01`**:

    ```bash
    docker run -d --name nginx-01 --network web_network -p 81:80 nginx
    ```

2. **Create `nginx-02`**:

    ```bash
    docker run -d --name nginx-02 --network web_network -p 82:80 nginx
    ```

### Step 3: Configure HAProxy Load Balancer

Create an **HAProxy** configuration file for load balancing the Nginx containers.

1. Create the directory `challenge01`:

    ```bash
    mkdir -p /home/student/challenge01
    ```

2. Create the HAProxy configuration file `haproxy.cfg`:

    ```bash
    vim /home/student/challenge01/haproxy.cfg
    ```

3. Add the following configuration:

    ```cfg
    global
        log stdout format raw local0

    defaults
        log global
        mode http
        option httplog
        timeout connect 5000ms
        timeout client 50000ms
        timeout server 50000ms

    frontend status
        bind *:8404
        stats enable
        stats uri /metrics
        stats refresh 10s

    frontend frontend_server
        bind *:8081
        default_backend backend_server

    backend backend_server
        balance roundrobin
        server nginx1 nginx-01:80 check
        server nginx2 nginx-02:80 check
    ```

### Step 4: Create an HAProxy Container

Create an HAProxy container using the configuration stored in `challenge01`.

1. Run the following command to create the HAProxy container:

    ```bash
    docker run -d --name haproxy-server --network web_network -v /home/student/challenge01/haproxy.cfg:/usr/local/etc/haproxy/haproxy.cfg:ro -p 8081:8081 -p 8404:8404 haproxy:latest
    ```

### Step 5: Add HAProxy Metrics to Prometheus

Configure Prometheus to scrape metrics from the HAProxy endpoint.

1. Edit the Prometheus configuration file (`prometheus.yml`):

    ```yaml
    - job_name: 'haproxy-[username]'
      static_configs:
        - targets: ['<YOUR_SERVER_IP>:8404']
    ```

2. Restart Prometheus to apply the changes:

    ```bash
    sudo systemctl restart prometheus
    ```

### Step 6: Create a Grafana Dashboard

Create panels in Grafana to visualize HAProxy metrics.

1. **Access Grafana** and create a new dashboard named **haproxy-server**.
2. **Add the following panels**:

    - **Uptime Panel**:
        - **Query**: `time() - process_start_time_seconds{job="haproxy-[username]"}`
        - **Visualization**: Stat
        - **Title**: `Uptime`

    - **Frontend Status Panel**:
        - **Query**: `haproxy_frontend_status{job="haproxy-[username]"}`
        - **Visualization**: Stat
        - **Title**: `Frontend Status`

    - **Backend Status Panel**:
        - **Query**: `haproxy_backend_status{job="haproxy-[username]"}`
        - **Visualization**: Stat
        - **Title**: `Backend Status`

    - **Total Backend Servers Panel**:
        - **Query**: `count(haproxy_backend_server_status{job="haproxy-[username]"})`
        - **Visualization**: Gauge
        - **Title**: `Total Backend Servers`

    - **Backend Server Status Panel**:
        - **Query**: `haproxy_backend_server_status{job="haproxy-[username]"}`
        - **Visualization**: Table
        - **Title**: `Backend Server Status`

    - **Total Frontend Requests Panel**:
        - **Query**: `haproxy_frontend_http_requests_total{job="haproxy-[username]"}`
        - **Visualization**: Time Series
        - **Title**: `Total Frontend Requests`

    - **Total Frontend Responses Panel**:
        - **Query**: `haproxy_frontend_http_responses_total{job="haproxy-[username]"}`
        - **Visualization**: Time Series
        - **Title**: `Total Frontend Responses`

    - **Connections & Sessions Panel**:
        - **Query**: `haproxy_current_sessions{job="haproxy-[username]"}`
        - **Visualization**: Stat
        - **Title**: `Connections & Sessions`

    - **Total HTTP Requests & Responses[1m] Panel**:
        - **Query 1**: `increase(haproxy_frontend_http_requests_total{job="haproxy-[username]"}[1m])`
        - **Query 2**: `increase(haproxy_frontend_http_responses_total{job="haproxy-[username]"}[1m])`
        - **Visualization**: Bar Gauge
        - **Title**: `Total HTTP Requests & Responses[1m]`

3. Save the dashboard with the name **haproxy-server**.

### Step 7: Verification

- **Access endpoints**:
  - Verify that `http://<YOUR_SERVER_IP>:8081` and `http://<YOUR_SERVER_IP>:8404/metrics` are accessible.
- **Prometheus target**:
  - Confirm `http://<YOUR_SERVER_IP>:8404` is listed in Prometheus targets with the name `haproxy-[username]`.
- **Grafana dashboard**:
  - Ensure all panels match the descriptions provided.

## Conclusion

You have successfully set up a load balancer using **HAProxy**, configured **Nginx** containers, and created a **Grafana** dashboard to monitor metrics. This setup will help you gain insights into your load balancer's performance and backend server status.

---

Feel free to include examples and screenshots for better visualization and understanding!
