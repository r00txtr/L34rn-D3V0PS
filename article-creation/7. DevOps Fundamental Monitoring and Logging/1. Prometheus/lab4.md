# Lab 4: Setting Up Docker and Monitoring with Prometheus

In this lab, you will learn how to install Docker, expose its metrics, set up a MySQL container, and integrate Docker and MySQL metrics into Prometheus for monitoring. This guide is designed for beginners, with detailed explanations and examples provided to ensure clarity.

By the end of this lab, you will:

- Install Docker and expose its metrics
- Run MySQL and MySQL Exporter containers
- Integrate Docker and MySQL metrics into Prometheus
- Verify the setup with Prometheus expressions

---

## Prerequisites

- A Linux server (node1) with `sudo` access
- Basic knowledge of the Linux command line

---

## Step-by-Step Guide

### 1. Install Docker

Follow the official Docker installation guide for Ubuntu:

- Visit: [Docker Installation Guide](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository)

Ensure you complete:

- **Install using the apt repository**
- **Install Docker Engine**

### 2. Configure Docker for Metrics

Expose Docker metrics by editing the Docker configuration file:

```bash
sudo vim /etc/docker/daemon.json
```

**Add the following content:**

```json
{
  "experimental": true,
  "metrics-addr": "172.16.7.10:9323"
}
```

### 3. Add Docker Job to Prometheus

Edit the Prometheus configuration to include Docker metrics:

```bash
sudo vim /opt/prometheus-2.55.1.linux-amd64/config.yml
```

**Add the following content to `scrape_configs`:**

```yaml
global:
  scrape_interval:     10s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'prometheus-server'
    static_configs:
    - targets: ['172.16.7.10:9090']

  - job_name: 'node-server'
    scrape_interval:  5s
    static_configs:
    - targets: ['172.16.7.10:9100','172.16.7.20:9100']

  # Add job for Docker
  - job_name: 'docker-server'
    static_configs:
    - targets: ['172.16.7.10:9323']
```

### 4. Restart Docker and Prometheus

Restart Docker and Prometheus services:

```bash
sudo systemctl restart docker
sudo systemctl restart prometheus_server.service
```

### 5. Configure User Permissions

Ensure your user has the appropriate permissions:

```bash
sudo usermod -aG docker ${USER}
sudo chmod 666 /var/run/docker.sock
```

### 6. Create a Docker Network

Create a network for the MySQL container:

```bash
docker network create db_network
```

### 7. Run the MySQL Container

Deploy a MySQL container with the following command:

```bash
docker run -d \
 --name mysql80 \
 --publish 3306 \
 --network db_network \
 --restart unless-stopped \
 --env MYSQL_ROOT_PASSWORD=katakunci \
 --volume mysql80-datadir:/var/lib/mysql \
 mysql:8
```

**Connect to the MySQL container:**

```bash
docker exec -it mysql80 mysql -uroot -p
```

**Create a MySQL user for monitoring:**

```sql
Enter password: katakunci
mysql> CREATE USER 'exporter'@'%' IDENTIFIED BY 'katakunci' WITH MAX_USER_CONNECTIONS 3;
mysql> GRANT PROCESS, REPLICATION CLIENT, SELECT ON *.* TO 'exporter'@'%';
```

### 8. Run the MySQL Exporter Container

Deploy the MySQL Exporter container:

```bash
docker run -d \
--name mysql80-exporter \
--publish 9104:9104 \
--restart always \
--network db_network \
--env DATA_SOURCE_NAME="exporter:katakunci@(mysql80:3306)/" \
prom/mysqld-exporter:v0.16.0 \
--collect.info_schema.processlist \
--collect.info_schema.innodb_metrics \
--collect.info_schema.tablestats \
--collect.info_schema.tables \
--collect.info_schema.userstats \
--collect.engine_innodb_status
```

### 9. Access Metrics

Use `curl` to check the Docker and MySQL metrics:

```bash
curl http://172.16.7.10:9323/metrics
curl http://172.16.7.10:9104/metrics
```

**Access in a browser:**

- **Docker metrics**: [http://10.10.10.11:9323/metrics](http://10.10.10.11:9323/metrics)
- **MySQL metrics**: [http://10.10.10.11:9104/metrics](http://10.10.10.11:9104/metrics)

### 10. Verify Container Status in Prometheus

Open Prometheus at [http://10.10.10.11:9090/](http://10.10.10.11:9090/) and use the following queries:

- **Check running containers**:

  ```promql
  engine_daemon_container_states_containers{state="running"}
  ```

- **Count pulled images**:

  ```promql
  engine_daemon_image_actions_seconds_count{action="pull"}
  ```

---

## Verification

- Ensure the `mysql80` and `mysql80-exporter` containers are running (`docker ps`).
- Confirm that MySQL metrics are accessible via `curl` or a browser.
- Verify that the `docker-server` job appears in [http://10.10.10.11:9090/targets](http://10.10.10.11:9090/targets).

---

**Congratulations!** You have completed Lab 4: Setting Up Docker and Monitoring with Prometheus.
