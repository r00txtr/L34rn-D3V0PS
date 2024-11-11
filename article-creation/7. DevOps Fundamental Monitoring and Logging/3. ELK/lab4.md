# Lab 4: Configuring Filebeat and Logstash to Collect and Send Logs to Elasticsearch

## Introduction

This lab demonstrates how to configure **Logstash** and **Filebeat** for collecting and forwarding syslog data from node2 to Elasticsearch on node1. You'll also learn how to visualize the data in Kibana by creating an index pattern and using the Discover menu.

---

## Prerequisites

- Elasticsearch and Kibana running on **node1**
- Filebeat installed on **node2**
- Logstash configured on **node1**

**Important**: Follow the steps carefully, as instructions for **node1** and **node2** are clearly marked.

---

## Step-by-Step Instructions

### Part 1: Configure Logstash on Node1

**Execute the following steps on node1 only.**

---

#### Step 1: Configure Logstash to Receive Beats Input

Create a configuration file for the Beats input plugin:

```bash
sudo vim /etc/logstash/conf.d/beats.conf
```

Add the following configuration:

```yaml
input {
  beats {
    port => 5044
  }
}
```

**Explanation**:

- The `beats` input listens on port `5044` for logs sent by Filebeat from node2.

---

#### Step 2: Configure Logstash Pipeline for Syslog Logs

Create a new configuration file for processing syslog logs:

```bash
sudo vim /etc/logstash/conf.d/filter-syslog.conf
```

Add the following configuration:

```yaml
filter {
  if [fields][log_name] == "syslog" {
    mutate {
      add_tag => [ "syslog" ]
    }
  }
}

output {
  elasticsearch {
    hosts => ["172.16.7.10:9200"]
    manage_template => false
    index => "%{[fields][log_name]}_%{[agent][name]}_%{+YYYY.MM}"
  }
}
```

**Explanation**:

- **Filter Section**: Adds a tag to logs identified as syslog.
- **Output Section**: Sends processed logs to Elasticsearch. The index name is dynamically created based on log name, agent name, and date.

---

#### Step 3: Restart Logstash Service

Restart Logstash to apply the new configurations:

```bash
sudo systemctl restart logstash
sudo systemctl status logstash
```

---

### Part 2: Configure Filebeat on Node2

**Execute the following steps on node2 only.**

---

#### Step 1: Configure Filebeat to Send Syslog Logs to Logstash

Backup the default Filebeat configuration file and create a new one:

```bash
sudo mv /etc/filebeat/filebeat.yml /etc/filebeat/filebeat.yml.original
sudo vim /etc/filebeat/filebeat.yml
```

Add the following configuration:

```yaml
filebeat.inputs:
- type: log
  enabled: true
  paths:
    - /var/log/syslog
  fields:
    log_name: syslog

output.logstash:
  hosts: ["172.16.7.10:5044"]
```

**Explanation**:

- **Input Section**: Specifies `/var/log/syslog` as the log source and adds a custom field `log_name: syslog`.
- **Output Section**: Sends the logs to Logstash on `172.16.7.10:5044`.

---

#### Step 2: Restart Filebeat Service

Restart the Filebeat service:

```bash
sudo systemctl restart filebeat
sudo systemctl status filebeat
```

---

#### Step 3: Verify Elasticsearch Indices

Run the following command to verify the logs are being sent to Elasticsearch:

```bash
curl http://172.16.7.10:9200/_cat/indices?v
```

**Expected Output**:

- An index with a name like `syslog_pod-node2_*` should appear.

**Troubleshooting**:

- If the index does not appear:
  - Check Filebeat logs:

    ```bash
    sudo journalctl -u filebeat
    ```

  - Refer to these discussions:
    - [Reference 1](https://discuss.elastic.co/t/filebeat-failed-to-connect-to-backoff-async-tcp5044/182147/2)
    - [Reference 2](https://discuss.elastic.co/t/logstash-not-listening-to-5044/277432)

---

### Part 3: Visualize Data in Kibana

**Execute the following steps on node1.**

---

#### Step 1: Create an Index Pattern in Kibana

1. Open **Kibana** in your browser:  

   ```text
   http://10.10.10.11:5601
   ```

2. Navigate to:
   - **Stack Management** → **Data Views** → **Create Data View**.
3. Configure the new data view:
   - **Name**: `syslog_*`
   - **Index Pattern**: `syslog_pod-node2_*` (replace with the actual index name if different).
   - **Timestamp Field**: `@timestamp`.
4. Save the data view.

---

#### Step 2: Search for Logs in Kibana Discover Menu

1. Go to **Discover**.
2. Search for specific logs:
   - Logs from `/var/log/syslog`:

     ```text
     log.file.path: "/var/log/syslog"
     ```

   - Logs tagged as `syslog`:

     ```text
     tags: syslog
     ```

3. Click **Refresh** to view results.

---

### Verification

1. Run the `curl` command from **Part 2, Step 3** to ensure the `syslog_pod-node2_*` index is created.
2. Use the **Kibana Discover Menu** to locate logs based on file path and tags.
3. Verify that the logs display correctly with their associated metadata.

---

## Conclusion

You have successfully configured Filebeat on node2 to send syslog data to Logstash on node1, processed the logs with a Logstash pipeline, and indexed them into Elasticsearch. Finally, you visualized the data in Kibana by creating an index pattern and searching logs in the Discover menu.

This setup forms a crucial part of centralized log management using the Elastic Stack!
