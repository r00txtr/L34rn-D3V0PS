# Lab 2: Installing and Configuring Prometheus Server

In this lab, you’ll learn how to set up **Prometheus**, a popular open-source monitoring and alerting toolkit, on a Linux server. This step-by-step guide will help you install, configure, and start Prometheus for system monitoring, complete with beginner-friendly explanations and examples.

By the end of this lab, you will:

- Install and configure Prometheus
- Run Prometheus as a service
- Access Prometheus metrics and dashboard
- Use Prometheus expressions for monitoring

---

## Prerequisites
Before starting, ensure you have:

- A Linux server with `sudo` access
- Basic knowledge of the Linux command line

---

## Step-by-Step Guide

### 1. Switch to the `root` User
Run the following command to switch to the `root` user:

```bash
sudo su -
```

### 2. Navigate to the `/opt` Directory
Navigate to the `/opt` directory, a common location for optional software.

```bash
cd /opt
```

### 3. Download Prometheus
Use `wget` to download the Prometheus tarball from the official GitHub repository:

```bash
wget https://github.com/prometheus/prometheus/releases/download/v2.55.1/prometheus-2.55.1.linux-amd64.tar.gz
```

### 4. Extract the Prometheus Tarball
Extract the tarball using the `tar` command with appropriate parameters:

```bash
tar xvfz prometheus-2.55.1.linux-amd64.tar.gz
```

**Explanation of Parameters:**

- **`x` (extract)**: Extracts files from the archive.
- **`v` (verbose)**: Displays the extraction progress.
- **`f` (file)**: Specifies the tar file to operate on.
- **`z` (zip)**: Indicates the file is compressed with gzip.

### 5. Navigate to the Prometheus Directory
Move into the extracted Prometheus directory:

```bash
cd prometheus-2.55.1.linux-amd64/
```

### 6. Configure Prometheus
Create a configuration file for Prometheus:

```bash
vim config.yml
```

**Add the following configuration:**

```yaml
global:
  scrape_interval:     10s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'prometheus-server'
    static_configs:
    - targets: ['172.16.7.10:9090']

  - job_name: 'node-server'
    scrape_interval: 5s
    static_configs:
    - targets: ['172.16.7.10:9100','172.16.7.20:9100']
```

### 7. Verify the Configuration
Run the following command to verify the configuration file:

```bash
./promtool check config config.yml
```

### 8. Run Prometheus Manually
Check available options and run Prometheus:

```bash
./prometheus --help
./prometheus --version
./prometheus --config.file=/opt/prometheus-2.55.1.linux-amd64/config.yml
```

### 9. Test Prometheus Access
Use `curl` to access Prometheus metrics and dashboard:

```bash
curl http://172.16.7.10:9090/metrics
curl http://172.16.7.10:9090/
curl http://172.16.7.10:9090/targets
```

**Access in a browser:**

- **Metrics**: [http://10.10.10.11:9090/metrics](http://10.10.10.11:9090/metrics)
- **Graph**: [http://10.10.10.11:9090/](http://10.10.10.11:9090/)
- **Targets**: [http://10.10.10.11:9090/targets](http://10.10.10.11:9090/targets)

### 10. Set Up Prometheus as a Service
Create a service file for Prometheus:

```bash
vim /etc/systemd/system/prometheus_server.service
```

**Add the following content:**

```ini
[Unit]
Description=Prometheus Server

[Service]
User=root
ExecStart=/opt/prometheus-2.55.1.linux-amd64/prometheus --config.file=/opt/prometheus-2.55.1.linux-amd64/config.yml --web.external-url=http://0.0.0.0:9090/

[Install]
WantedBy=default.target
```

### 11. Enable and Start the Prometheus Service
Reload systemd, enable, and start the Prometheus service:

```bash
systemctl daemon-reload
systemctl enable prometheus_server.service
systemctl start prometheus_server.service
```

### 12. Check Service Status
Verify that Prometheus is running properly:

```bash
systemctl status prometheus_server.service
```

### 13. View Logs
Use the following command for log troubleshooting:

```bash
journalctl -u prometheus_server
```

---

## Using Prometheus Expression Browser

### Access the Prometheus Graph
Open the Prometheus dashboard at [http://10.10.10.11:9090/](http://10.10.10.11:9090/).

#### Examples of Prometheus Expressions:

1. **Check instance status**:

   ```promql
   up{job="node-server"}
   ```

2. **Count active instances**:

   ```promql
   sum(up{job="node-server"})
   ```

3. **Show uptime in hours for node1**:

   ```promql
   (time() - process_start_time_seconds{instance="172.16.7.10:9100"}) / 3600
   ```

4. **Show uptime in hours for another node**:

   ```promql
   (time() - process_start_time_seconds{instance="172.16.7.20:9100"}) / 3600
   ```

5. **Display CPU utilization**:

   ```promql
   100 - (avg by(instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
   ```

6. **Available memory in MB**:

   ```promql
   node_memory_MemAvailable_bytes/1024/1024
   ```

7. **Memory usage in percentage**:

   ```promql
   100 * (1 - ((avg_over_time(node_memory_MemFree_bytes[10m]) + avg_over_time(node_memory_Cached_bytes[10m]) + avg_over_time(node_memory_Buffers_bytes[10m])) / avg_over_time(node_memory_MemTotal_bytes[10m])))
   ```

### Verification

- Ensure Prometheus Server is running.
- Verify access to Prometheus Expression Browser in the browser.
- Confirm that the targets `prometheus-server` and `node-server` are listed at [http://172.16.7.10:9090/targets](http://172.16.7.10:9090/targets).

---

**Congratulations!** You have completed Lab 2: Installing and Configuring Prometheus Server.