# Lab 5: Configure Logstash and Filebeat to Monitor SSH Login Failures (Filtering Logs from Logstash with If Else)

## Introduction

In this lab, you will learn how to set up **Logstash** to process `auth.log` files from **node2**, send the processed data to **Elasticsearch** on **node1**, and visualize it in **Kibana**. This setup will help you monitor failed SSH login attempts, providing insights into potential security issues. This guide is designed for beginners and includes detailed explanations and examples.

---

## Prerequisites

- Basic familiarity with Linux command line
- Elasticsearch and Kibana running on **node1**
- Filebeat installed on **node2**
- Logstash configured on **node1**

**Important**: Execute the instructions on the appropriate nodes as specified.

---

## Part 1: Configure Logstash to Receive and Process `auth.log`

### Step 1: Create a Logstash Pipeline Configuration

**Execute on node1 only.**

1. Create a new configuration file for processing `auth.log`:

   ```bash
   sudo vim /etc/logstash/conf.d/filter-authlog.conf
   ```

2. Add the following configuration to filter SSH failure logs:

   ```yaml
   filter {
     if [fields][log_name] == "auth_log" {
       if "Invalid user" in [message] {
         mutate {
           add_tag => "ssh_fail"
           add_tag => "auth_log"
         }
       } else {
         drop { }
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
   - **Filter Section**: Checks if the `log_name` field matches `auth_log` and if the log message contains "Invalid user". If so, it tags the log as `ssh_fail` and `auth_log`.
   - **Output Section**: Sends the filtered logs to **Elasticsearch** with a custom index name.

3. Save and exit the file.

### Step 2: Restart Logstash Service

Restart the Logstash service to apply the new configuration:

```bash
sudo systemctl restart logstash
```

---

## Part 2: Configure Filebeat to Send `auth.log` to Logstash

**Execute on node2 only.**

### Step 1: Edit the Filebeat Configuration File

1. Open the Filebeat configuration file:

   ```bash
   sudo vi /etc/filebeat/filebeat.yml
   ```

2. Add the following lines to configure Filebeat to monitor `auth.log`:

   ```yaml
   filebeat.inputs:
   - type: log
     enabled: true
     paths:
       - /var/log/auth.log
     fields:
       log_name: auth_log

   output.logstash:
     hosts: ["172.16.7.10:5044"]
   ```

   **Explanation**:
   - **Input Section**: Specifies `/var/log/auth.log` as the source and adds a custom field `log_name: auth_log`.
   - **Output Section**: Directs the logs to **Logstash** on **node1** at port `5044`.

3. Save and exit the file.

### Step 2: Restart Filebeat Service

Restart the Filebeat service to apply the configuration:

```bash
sudo systemctl restart filebeat
```

---

## Part 3: Test and Verify Log Collection

**Execute on node1 and node2 as specified.**

### Step 1: Attempt SSH Login to Generate Logs

**From pod-node1**, attempt SSH login to **pod-node2** with an invalid user:

```bash
ssh test@pod-node2
```

Repeat the login attempts a few times to ensure logs are generated.

### Step 2: Verify Index Creation in Elasticsearch

Run the following command on **node1** to verify that the logs are being indexed:

```bash
curl http://172.16.7.10:9200/_cat/indices?v
```

**Expected Output**:

- You should see an index with a name like `auth_log_pod-node2*`.

---

## Part 4: Configure Kibana to Visualize the Data

### Step 1: Create an Index Pattern in Kibana

1. Open **Kibana** in your web browser at:

   ```text
   http://10.10.10.11:5601
   ```

2. Navigate to **Stack Management** > **Data Views**.

3. Click **Create Data View** and configure as follows:
   - **Name**: `auth_log_*`
   - **Index pattern**: `auth_log_pod-node2*` (use the actual index name if different)
   - **Timestamp Field**: `@timestamp`

4. Save the data view.

### Step 2: Search for Logs in Discover Menu

1. Go to **Discover** in **Kibana**.
2. In the search bar, type:

   ```text
   tags: ssh_fail
   ```

3. Click **Refresh**.

**Verification**:

- You should see logs tagged as `ssh_fail` with the `test` username from the failed login attempts.

---

## Troubleshooting

**If Step 2 verification fails**:

Run the following command to delete the existing index and repeat the failed SSH attempts:

```bash
curl -XDELETE 172.16.7.10:9200/$(curl -s http://172.16.7.10:9200/_cat/indices?v | grep auth_log | awk '{print $3}')
```

Then, repeat the SSH login step and recheck.

---

## Conclusion

You have successfully configured **Logstash** on **node1** to process `auth.log` from **node2**, sent the logs to **Elasticsearch**, and visualized them in **Kibana**. This lab helps you monitor SSH login failures, enhancing security visibility in your environment.
