# Lab 9: Sending HTTPD Web Server Logs to ELK Server

## Introduction

In this lab, you will install the **HTTPD (Apache)** web server on **pod-node1**, configure it to send its access logs to an **ELK** (Elasticsearch, Logstash, Kibana) server, and query these logs in **Kibana**. This lab provides step-by-step instructions to help you gain insights into web server activity through centralized log management.

---

## Prerequisites

- Basic understanding of Linux commands
- ELK server with **Logstash**, **Elasticsearch**, and **Kibana** configured
- **pod-node1** ready for the installation of the HTTPD web server

---

## Part 1: Install HTTPD on pod-node1

### Step 1: Install HTTPD Web Server

1. Update the package list and install HTTPD:

   ```bash
   sudo apt update
   sudo apt install -y apache2
   ```

   **Note**: On certain Linux distributions, you may need to use:

   ```bash
   sudo yum install -y httpd
   ```

2. Start and enable the HTTPD service:

   ```bash
   sudo systemctl start apache2
   sudo systemctl enable apache2
   ```

3. Verify that the HTTPD service is running:

   ```bash
   sudo systemctl status apache2
   ```

   **Expected Output**:
   - The service status should be `Active: active (running)`.

---

## Part 2: Configure Filebeat to Send HTTPD Logs to Logstash

### Step 1: Edit the Filebeat Configuration

1. Open the Filebeat configuration file on **pod-node1**:

   ```bash
   sudo vi /etc/filebeat/filebeat.yml
   ```

2. Add the following configuration to monitor HTTPD `access_log`:

   ```yaml
   filebeat.inputs:
   - type: log
     enabled: true
     paths:
       - /var/log/apache2/access.log
       # Use the path below if using CentOS/RHEL:
       # - /var/log/httpd/access_log
     fields:
       log_name: httpd_access_log

   output.logstash:
     hosts: ["<ELK_SERVER_IP>:5044"]
   ```

   **Explanation**:
   - **Input Section**: Specifies the path to the `access_log` and labels the logs with `log_name: httpd_access_log`.
   - **Output Section**: Sends the logs to **Logstash** on the ELK server at port `5044`.

3. Save and exit the file.

### Step 2: Restart Filebeat

Restart the Filebeat service to apply the new configuration:

```bash
sudo systemctl restart filebeat
sudo systemctl status filebeat
```

---

## Part 3: Perform Web Server Access Activities

### Step 1: Generate Access Logs

1. Simulate web server access using **curl**:

   ```bash
   curl http://localhost
   ```

2. Repeat this command a few times or access the server’s IP from a browser to generate multiple log entries.

---

## Part 4: Configure Logstash to Process HTTPD Logs

### Step 1: Edit Logstash Configuration on ELK Server

1. Open the Logstash configuration file on the ELK server:

   ```bash
   sudo vim /etc/logstash/conf.d/httpd-access-log.conf
   ```

2. Add the following configuration:

   ```yaml
   input {
     beats {
       port => 5044
     }
   }

   filter {
     if [fields][log_name] == "httpd_access_log" {
       mutate {
         add_tag => "httpd"
       }
     }
   }

   output {
     elasticsearch {
       hosts => ["<ELK_SERVER_IP>:9200"]
       index => "httpd_access_log_%{+YYYY.MM}"
     }
   }
   ```

   **Explanation**:
   - **Input Section**: Listens for logs sent from **Filebeat**.
   - **Filter Section**: Tags logs from `access_log` with `httpd`.
   - **Output Section**: Sends the logs to **Elasticsearch** with an index name containing `httpd`.

3. Save and exit the file.

### Step 2: Restart Logstash

Restart Logstash to apply the new configuration:

```bash
sudo systemctl restart logstash
```

---

## Part 5: Query Logs in Kibana

### Step 1: Access Kibana Dashboard

1. Open **Kibana** in your web browser at:

   ```text
   http://<ELK_SERVER_IP>:5601
   ```

2. Navigate to **Discover**.

### Step 2: Perform a Log Query

1. Ensure you have created a **Data View** for the `httpd` index (e.g., `httpd_access_log_*`).
2. In the **Discover** search bar, type:

   ```text
   log.file.path: "/var/log/apache2/access.log"
   ```

   - For CentOS/RHEL, use:

     ```text
     log.file.path: "/var/log/httpd/access_log"
     ```

3. Click **Refresh** to display the results.

---

## Verification

- Confirm that an index containing `httpd` is present in **Elasticsearch**.
- Verify that the log source is from **pod-node1**.
- Ensure that logs from `/var/log/httpd/access_log` or `/var/log/apache2/access.log` appear in the **Kibana** query results.

**Expected Outcome**:

- Logs should be visible in **Kibana**, showing HTTPD access log details.

---

## Conclusion

You have successfully set up the **HTTPD** web server on **pod-node1**, configured **Filebeat** to send access logs to **Logstash**, and queried these logs in **Kibana**. This process helps centralize and monitor web server activity effectively.

Feel free to explore **Kibana** further to create visualizations and dashboards for enhanced log analysis!
