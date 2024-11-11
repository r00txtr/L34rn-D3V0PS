# Lab 8: Sending Apache2 Access Logs to Logstash and Visualizing in Kibana

## Introduction

In this lab, you will learn how to set up **Apache2** on **pod-node2**, send its `access.log` data to **Logstash** on **node1**, and create a Data View in **Kibana** to visualize the logs. This process will help you monitor and analyze web server activities effectively. This guide is designed for beginners and includes detailed steps, explanations, and examples.

---

## Prerequisites

- Basic understanding of Linux commands
- Logstash running on **node1**
- Elasticsearch and Kibana configured on **node1**
- Filebeat installed on **pod-node2**

---

## Part 1: Install Apache2 Web Server on pod-node2

### Step 1: Install Apache2

**Execute the following commands on pod-node2:**

1. Update the package list and install Apache2:

   ```bash
   sudo apt update
   sudo apt install -y apache2
   ```

2. Verify that Apache2 is installed and running:

   ```bash
   sudo systemctl status apache2
   ```

   **Expected Output**:
   - The service should be `Active: active (running)`.

---

## Part 2: Configure Filebeat to Send Apache2 Logs to Logstash

### Step 1: Edit the Filebeat Configuration

1. Open the Filebeat configuration file on **pod-node2**:

   ```bash
   sudo vi /etc/filebeat/filebeat.yml
   ```

2. Add the following configuration to monitor the Apache2 `access.log`:

   ```yaml
   filebeat.inputs:
   - type: log
     enabled: true
     paths:
       - /var/log/apache2/access.log
     fields:
       log_name: apache2_access_log

   output.logstash:
     hosts: ["172.16.7.10:5044"]
   ```

   **Explanation**:
   - **Input Section**: Specifies the path to `access.log` and labels the log source with `log_name: apache2_access_log`.
   - **Output Section**: Sends the logs to **Logstash** on **node1** at port `5044`.

3. Save and exit the file.

### Step 2: Restart Filebeat

Restart Filebeat to apply the changes:

```bash
sudo systemctl restart filebeat
sudo systemctl status filebeat
```

---

## Part 3: Generate Web Server Activity

### Step 1: Simulate Web Traffic

**From pod-node2**, generate web server traffic using tools like **curl**, **w3m**, or **lynx**, or access the server through a browser:

1. Use **curl** to make web requests:

   ```bash
   curl http://localhost
   ```

2. Repeat this command a few times or use a browser to visit the server's IP address to create log entries.

---

## Part 4: Configure Logstash to Index Apache2 Logs

### Step 1: Edit the Logstash Configuration on node1

1. Open the Logstash configuration file on **node1**:

   ```bash
   sudo vim /etc/logstash/conf.d/apache2-access-log.conf
   ```

2. Add the following configuration:

   ```yaml
   input {
     beats {
       port => 5044
     }
   }

   filter {
     if [fields][log_name] == "apache2_access_log" {
       mutate {
         add_tag => "apache2"
       }
     }
   }

   output {
     elasticsearch {
       hosts => ["172.16.7.10:9200"]
       index => "apache2_access_log_%{+YYYY.MM}"
     }
   }
   ```

   **Explanation**:
   - **Input Section**: Listens for logs on port `5044` from **Filebeat**.
   - **Filter Section**: Tags logs from `access.log` with `apache2`.
   - **Output Section**: Sends logs to **Elasticsearch** with an index name that includes `apache2`.

3. Save and exit the file.

### Step 2: Restart Logstash

Restart Logstash to apply the configuration:

```bash
sudo systemctl restart logstash
```

---

## Part 5: Create a Data View in Kibana

### Step 1: Access Kibana and Create a Data View

1. Open **Kibana** in your web browser at:

   ```text
   http://10.10.10.11:5601
   ```

2. Go to **Stack Management** > **Data Views**.

3. Click **"Create Data View"**.

4. Configure the Data View:
   - **Name**: Include `apache2` (e.g., `apache2_access_log`).
   - **Index pattern**: `apache2_access_log_*`.
   - **Timestamp field**: `@timestamp`.

5. Click **Save** to create the Data View.

---

## Part 6: Verify and Query Logs in Kibana

### Step 1: Verify Index Creation

Run the following command on **node1** to verify that an index containing `apache2` exists:

```bash
curl http://172.16.7.10:9200/_cat/indices?v
```

**Expected Output**:

- You should see an index with a name like `apache2_access_log_*`.

### Step 2: Query Apache2 Logs in Kibana

1. Go to **Discover** in **Kibana**.
2. Select the **`apache2_access_log`** Data View.
3. In the search bar, type the following query:

   ```text
   log.file.path: "/var/log/apache2/access.log"
   ```

4. Click **Refresh** to view the results.

---

## Verification

1. Ensure that the index contains `apache2` in its name.
2. Verify that the source of the logs in the index is from **pod-node2**.
3. Confirm that the Data View has been created and selected correctly in **Kibana**.

**Expected Outcome**:

- Logs should be visible in **Kibana** with details about the `access.log` entries from **pod-node2**.

---

## Conclusion

You have successfully set up **Apache2** on **pod-node2**, configured **Filebeat** to send `access.log` data to **Logstash**, and created a **Kibana** Data View to visualize the logs. This setup helps monitor and analyze web server activity efficiently.

Feel free to further customize and enhance your **Kibana** dashboard with more visualizations and insights!
