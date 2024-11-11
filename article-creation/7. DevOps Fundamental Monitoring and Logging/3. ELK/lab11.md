# Lab 11: Parsing and Visualizing Logs with Grok Filter in Logstash

## Introduction

In this lab, you will download a log file, parse it using **Logstash** with a **Grok filter**, and visualize the parsed data in **Kibana**. This will help you understand how to process log data and create meaningful visualizations. The lab is structured for beginners, with detailed explanations, examples, and, where applicable, screenshots.

---

## Prerequisites

- Basic understanding of Linux and ELK stack components
- ELK stack running on **pod-node1**

---

## Part 1: Download and Store the Log File

### Step 1: Download the Log File

1. Connect to **pod-node1** and navigate to the `/var/log` directory:

   ```bash
   cd /var/log
   ```

2. Download the log file from the provided URL:

   ```bash
   wget https://raw.githubusercontent.com/bta-adinusa/elk-challenge1/main/challenge1.log.gz
   ```

3. Extract the log file:

   ```bash
   gunzip challenge1.log.gz
   ```

4. Verify that the file exists:

   ```bash
   ls -l /var/log/challenge1.log
   ```

   **Expected Output**:
   - The `challenge1.log` file should be present in the `/var/log` directory.

---

## Part 2: Configure Logstash to Parse the Log File

### Step 1: Create a Logstash Configuration File

1. Open a new Logstash configuration file:

   ```bash
   sudo vim /etc/logstash/conf.d/challenge1-log.conf
   ```

2. Add the following configuration to parse the log file using **Grok**:

   ```yaml
   input {
     file {
       path => "/var/log/challenge1.log"
       start_position => "beginning"
       sincedb_path => "/dev/null"
     }
   }

   filter {
     grok {
       match => {
         "message" => "%{TIMESTAMP_ISO8601:c1_time} %{HOSTNAME:c1_hostname} %{WORD:c1_monitor} %{LOGLEVEL:c1_log_level} %{GREEDYDATA:c1_info}"
       }
     }
   }

   output {
     elasticsearch {
       hosts => ["localhost:9200"]
       index => "challenge1_username"
     }
   }
   ```

   **Explanation**:
   - **Input Section**: Reads the `challenge1.log` file from `/var/log` and ensures it processes from the beginning each time by setting `sincedb_path` to `/dev/null`.
   - **Filter Section**: Uses a **Grok filter** to parse and label the log fields:
     - `time` field as `c1_time`
     - `hostname` field as `c1_hostname`
     - `monitor` field as `c1_monitor`
     - `log level` field as `c1_log_level`
     - `Health/cluster info` field as `c1_info`
   - **Output Section**: Sends the parsed logs to **Elasticsearch** with an index name of `challenge1_username`.

3. Save and exit the file.

### Step 2: Restart Logstash

Restart the Logstash service to apply the new configuration:

```bash
sudo systemctl restart logstash
sudo systemctl status logstash
```

---

## Part 3: Create a Data View in Kibana

### Step 1: Access Kibana

1. Open **Kibana** in your web browser at:

   ```text
   http://<pod-node1-IP>:5601
   ```

### Step 2: Create a Data View

1. Navigate to **Stack Management** > **Data Views**.
2. Click **"Create Data View"**.
3. Configure the Data View as follows:
   - **Name**: `challenge1_username`
   - **Index pattern**: `challenge1_username`
   - **Timestamp field**: `c1_time`
4. Click **Save**.

---

## Verification

### Step 1: Check Log File Location

Ensure that the `challenge1.log` file is located in the `/var/log` directory:

```bash
ls -l /var/log/challenge1.log
```

### Step 2: Verify Parsed Logs in Kibana

1. Go to **Discover** in **Kibana**.
2. Select the **`challenge1_username`** Data View.
3. Check if the logs are displayed with the parsed fields (`c1_time`, `c1_hostname`, `c1_monitor`, `c1_log_level`, `c1_info`).

**Expected Outcome**:

- The logs should be displayed in **Kibana** with fields labeled as `c1_time`, `c1_hostname`, `c1_monitor`, `c1_log_level`, and `c1_info`.
- The index should be named **`challenge1_username`**.

---

## Conclusion

You have successfully downloaded and stored a log file, configured **Logstash** to parse the logs using a **Grok filter**, and created a **Kibana Data View** to visualize the parsed data. This setup allows you to analyze and monitor log data effectively.

Feel free to explore **Kibana** further to create additional visualizations and dashboards for deeper insights!
