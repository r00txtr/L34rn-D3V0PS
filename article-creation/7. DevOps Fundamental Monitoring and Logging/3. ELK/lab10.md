# Lab 10: Forward Docker Container Logs to ELK and Create Visualizations in Kibana

## Introduction

In this lab, you will learn how to run a Docker container using the `nfrankel/simplelog:1` image, forward the container logs to an **ELK** (Elasticsearch, Logstash, Kibana) stack on **pod-node1**, and create visualizations in **Kibana**. By the end of this lab, you will have a data table and a metric visualization displayed in a dashboard for easy log monitoring. This guide is designed for beginners, with step-by-step instructions, explanations, and examples.

---

## Prerequisites

- Basic understanding of Docker and Linux commands
- ELK stack running on **pod-node1**
- Filebeat installed on **pod-node1**

---

## Part 1: Run the Docker Container and Forward Logs to ELK

### Step 1: Run the Docker Container

1. Pull and run the `nfrankel/simplelog:1` image on **pod-node1**:

   ```bash
   docker run -d --name simplelog-container nfrankel/simplelog:1
   ```

2. Verify that the container is running:

   ```bash
   docker ps
   ```

   **Expected Output**:
   - The container `simplelog-container` should be listed as running.

### Step 2: Configure Filebeat to Forward Docker Logs

1. Open the Filebeat configuration file on **pod-node1**:

   ```bash
   sudo vi /etc/filebeat/filebeat.yml
   ```

2. Add the following configuration to monitor Docker logs:

   ```yaml
   filebeat.inputs:
   - type: container
     enabled: true
     paths:
       - /var/lib/docker/containers/*/*.log
     fields:
       log_name: docker_log

   output.logstash:
     hosts: ["localhost:5044"]
   ```

   **Explanation**:
   - **Input Section**: Specifies the path to Docker logs and adds a custom field `log_name: docker_log`.
   - **Output Section**: Sends the logs to **Logstash** running on **pod-node1** at port `5044`.

3. Save and exit the file.

### Step 3: Restart Filebeat

Restart the Filebeat service to apply the changes:

```bash
sudo systemctl restart filebeat
sudo systemctl status filebeat
```

---

## Part 2: Configure Logstash to Process Docker Logs

### Step 1: Edit Logstash Configuration on pod-node1

1. Open the Logstash configuration file:

   ```bash
   sudo vim /etc/logstash/conf.d/docker-log.conf
   ```

2. Add the following configuration:

   ```yaml
   input {
     beats {
       port => 5044
     }
   }

   filter {
     if [fields][log_name] == "docker_log" {
       mutate {
         add_tag => "docker"
       }
     }
   }

   output {
     elasticsearch {
       hosts => ["localhost:9200"]
       index => "docker_log_%{+YYYY.MM}"
     }
   }
   ```

   **Explanation**:
   - **Input Section**: Listens for logs sent from **Filebeat**.
   - **Filter Section**: Tags logs with `docker` for easy identification.
   - **Output Section**: Sends the logs to **Elasticsearch** with an index name that includes `docker`.

3. Save and exit the file.

### Step 2: Restart Logstash

Restart Logstash to apply the new configuration:

```bash
sudo systemctl restart logstash
```

---

## Part 3: Create Kibana Visualizations

### Step 1: Create a Data Table Visualization

1. Open **Kibana** in your web browser at:

   ```text
   http://<pod-node1-IP>:5601
   ```

2. Navigate to **Visualize Library**.

3. Click **"Create a visualization"**.

4. Choose **"Data Table"** under **"Aggregation Based"**.

5. Select the **`docker_log_*`** index as the data source.

6. Add the following columns:
   - **Column 1**:
     - **Aggregation**: Date Histogram
     - **Field**: `@timestamp`
   - **Column 2**:
     - **Aggregation**: Terms
     - **Field**: `host.name`
   - **Column 3**:
     - **Aggregation**: Terms
     - **Field**: `_index`
   - **Column 4**:
     - **Aggregation**: Count

7. Click **"Update"** to preview the table.

8. Save the visualization as **"docker-logs-table"**.

---

### Step 2: Create a Metric Visualization

1. Go back to **Visualize Library** and click **"Create a visualization"**.

2. Choose **"Metric"** under **"Aggregation Based"**.

3. Select the **`docker_log_*`** index as the data source.

4. Configure the metric:
   - **Aggregation**: Count

5. Click **"Update"** to preview the metric.

6. Save the visualization as **"docker-logs-count"**.

---

## Part 4: Create a Kibana Dashboard

### Step 1: Create a New Dashboard

1. Navigate to **Dashboard** and click **"Create new dashboard"**.

2. Click **"Add from library"** and select:
   - **"docker-logs-table"**
   - **"docker-logs-count"**

3. Arrange the visualizations as desired.

### Step 2: Save the Dashboard

1. Click **"Save"**.
2. Name the dashboard **"dashboard-docker-server"**.
3. Click **"Save"**.

---

## Verification

1. Ensure that the index contains the name **docker**.
2. Confirm that the **docker-logs-table** and **docker-logs-count** visualizations appear in the **dashboard-docker-server**.
3. Double-check that the names of visualizations and dashboard match exactly, including case sensitivity.

**Expected Outcome**:

- The data table should display columns for `@timestamp`, `host.name`, `_index`, and `count`.
- The metric visualization should show the total number of logs.
- The dashboard should combine these visualizations for comprehensive log analysis.

---

## Conclusion

You have successfully run a Docker container, forwarded its logs to the ELK stack, and created visualizations in **Kibana**. This setup helps you monitor and analyze container logs in real-time, providing valuable insights into container activity.

Feel free to further customize the visualizations or add more data sources for enhanced monitoring!
