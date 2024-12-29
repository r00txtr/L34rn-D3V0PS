# Lab 5: Installing and Configuring cAdvisor with Prometheus

In this lab, you will learn how to install **cAdvisor** to collect more detailed container metrics and integrate it with Prometheus for monitoring. This lab builds on Lab 4, so make sure you have completed Lab 4 before starting this one.

By the end of this lab, you will:

- Install and start cAdvisor
- Add cAdvisor and MySQL Exporter as Prometheus targets
- Modify Prometheus global settings for scraping intervals
- Explore and verify cAdvisor and MySQL metrics in Prometheus

---

## Prerequisites

- Completion of **Lab 4**
- A Linux server (node1) with `sudo` access
- Basic knowledge of Docker and Prometheus

---

## Step-by-Step Guide

### 1. Install and Start cAdvisor

To collect comprehensive container metrics, install **cAdvisor** using Docker:

**Run cAdvisor in a Docker container:**

```bash
docker run -d \
  --name=cadvisor \
  --publish=8080:8080 \
  --volume=/:/rootfs:ro \
  --volume=/var/run:/var/run:rw \
  --volume=/sys:/sys:ro \
  --volume=/var/lib/docker/:/var/lib/docker:ro \
  --restart unless-stopped \
  gcr.io/cadvisor/cadvisor
```

This command will:

- Name the container `cadvisor`
- Publish cAdvisor metrics on `172.16.7.10:8080`
- Mount necessary directories to collect data
- Ensure the container restarts unless stopped manually

### 2. Add MySQL Exporter and cAdvisor to Prometheus

Edit the Prometheus configuration file to add MySQL Exporter and cAdvisor as scrape targets:

```bash
sudo vim /opt/prometheus-2.55.1.linux-amd64/config.yml
```

**Add the following `scrape_configs` entries:**

```yaml
global:
  scrape_interval: 10s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'prometheus-server'
    static_configs:
    - targets: ['172.16.7.10:9090']

  - job_name: 'node-server'
    scrape_interval: 5s
    static_configs:
    - targets: ['172.16.7.10:9100', '172.16.7.20:9100']

  - job_name: 'docker-server'
    static_configs:
    - targets: ['172.16.7.10:9323']

  # Add job for MySQL Exporter
  - job_name: 'mysql-server'
    scrape_interval: 5s
    static_configs:
    - targets: ['172.16.7.10:9104']

  # Add job for cAdvisor
  - job_name: 'cadvisor-server'
    static_configs:
    - targets: ['172.16.7.10:8080']
```

### 3. Restart Prometheus

To apply the changes, restart the Prometheus service:

```bash
sudo systemctl restart prometheus_server.service
```

### 4. Explore Metrics in Prometheus

Access Prometheus at [http://10.10.10.11:9090/](http://10.10.10.11:9090/) and use the **Expression Browser** to explore metrics:

- **Metrics for `mysql-server`**:
  - Query: `mysql_global_status_uptime`
  - Query: `mysql_global_status_queries`

- **Metrics for `cadvisor-server`**:
  - Query: `container_memory_usage_bytes`
  - Query: `container_cpu_usage_seconds_total`

### 5. Verify cAdvisor Metrics Access

Check if cAdvisor metrics are accessible by opening the following URL in your browser:

- **cAdvisor metrics**: [http://10.10.10.11:8080/metrics](http://10.10.10.11:8080/metrics)

### 6. Verify Prometheus Targets

Ensure that the `mysql-server` and `cadvisor-server` targets appear in Prometheus:

- Open [http://10.10.10.11:9090/targets](http://10.10.10.11:9090/targets) in your browser.
- Confirm that both `mysql-server` and `cadvisor-server` are listed and the **scrape interval** for `mysql-server` is set to 5 seconds.

---

## Verification

- **Lab 4 completion**: Ensure that Lab 4 was successfully completed.
- **cAdvisor metrics**: Accessible at [http://10.10.10.11:8080/metrics](http://10.10.10.11:8080/metrics).
- **Prometheus targets**: Confirm that `mysql-server` and `cadvisor-server` appear at [http://10.10.10.11:9090/targets](http://10.10.10.11:9090/targets).
- **Scrape interval**: Verify that the `mysql-server` job has a 5-second scrape interval.

---

**Congratulations!** You have completed Lab 5: Installing and Configuring cAdvisor with Prometheus.
