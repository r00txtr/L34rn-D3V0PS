# Lab 3: Setting Up Logstash Pipeline to Send Logs to Elasticsearch

## Introduction

This lab demonstrates how to configure a **Logstash pipeline** to process and forward logs to an Elasticsearch instance. By the end of this lab, you will have a Logstash pipeline processing sample log data and indexing it into Elasticsearch for further analysis.

---

## Prerequisites

- Basic familiarity with Linux command line
- Elasticsearch instance running on **<http://172.16.7.10:9200>** (set up in previous labs)
- Logstash installed on **node1**

**Important**: Execute all instructions on **node1** only.

---

## Step-by-Step Instructions

### Step 1: Download and Extract Sample Logs

Download the sample log file and extract it to the `/var/log/` directory:

```bash
wget https://download.elastic.co/demos/logstash/gettingstarted/logstash-tutorial.log.gz
sudo gunzip logstash-tutorial.log.gz
sudo mv logstash-tutorial.log /var/log/
```

**Explanation**:

- The sample log file contains Apache log data.
- It will be used as input for the Logstash pipeline.

Verify the file exists in `/var/log/`:

```bash
ls /var/log/logstash-tutorial.log
```

---

### Step 2: Create and Configure Logstash Pipeline

Create a new configuration file for the Logstash pipeline:

```bash
sudo vim /etc/logstash/conf.d/example-practice-pipeline1.conf
```

Add the following configuration:

```bash
input {
  file {
    path => ["/var/log/logstash-tutorial.log"]
    start_position => "beginning"
    sincedb_path => "/dev/null"
  }
}

filter {
  grok {
    match => {
      "message" => "%{COMBINEDAPACHELOG}"
    }
  }
  mutate {
    convert => { "bytes" => "integer" }
  }
  date {
    match => [ "timestamp", "dd/MMM/YYYY:HH:mm:ss Z" ]
    locale => en
    remove_field => "timestamp"
  }
  geoip {
    source => "clientip"
  }
  useragent {
    source => "agent"
    target => "useragent"
  }
}

output {
  stdout {
    codec => dots
  }
  elasticsearch {
    hosts => ["http://172.16.7.10:9200"]
  }
}
```

**Explanation**:

- **Input Section**: Specifies the log file path and ensures processing starts from the beginning.
- **Filter Section**: Processes logs to:
  - Extract log patterns using Grok (`%{COMBINEDAPACHELOG}`).
  - Convert bytes field to integer.
  - Parse the timestamp field into a proper date format.
  - Perform GeoIP lookups on client IP addresses.
  - Parse user agent strings.
- **Output Section**: Sends processed data to Elasticsearch and prints dots to the terminal for debugging.

---

### Step 3: Configure Main Logstash Pipeline File

Edit the main pipeline configuration file:

```bash
sudo vim /etc/logstash/pipelines.yml
```

Add or modify the following:

```yaml
- pipeline.id: main
  path.config: "/etc/logstash/conf.d/*.conf"
  pipeline.ecs_compatibility: disabled
```

**Explanation**:

- **pipeline.id**: Unique identifier for the pipeline.
- **path.config**: Points to the pipeline configuration file(s).
- **pipeline.ecs_compatibility**: Disabled for backward compatibility with sample logs.

---

### Step 4: Restart Logstash Service

Restart Logstash to apply the changes:

```bash
sudo systemctl restart logstash
```

Verify the status:

```bash
sudo systemctl status logstash
```

---

### Step 5: Verify Logs in Elasticsearch

Use the following command to check the number of logs indexed in Elasticsearch:

```bash
curl -XGET http://172.16.7.10:9200/logstash-*/_count
```

**Expected Response**:

```json
{
  "count" : 100,
  "_shards" : {
    "total" : 5,
    "successful" : 5,
    "skipped" : 0,
    "failed" : 0
  }
}
```

**Troubleshooting**:

- If the count is not 100, refer to this [guide](https://www.cyberithub.com/how-to-delete-elasticsearch-red-status-indices/) to resolve potential issues.
- Revisit **Step 2** and check:
  - Pipeline configuration for typos.
  - Logstash service logs for errors:

    ```bash
    sudo journalctl -u logstash
    ```

---

### Cleanup Before Moving to Next Lab

To ensure no interference with future labs, delete the indexed logs:

```bash
curl -XDELETE http://172.16.7.10:9200/logstash-*
```

---

## Verification

1. Confirm that the `curl` command from Step 5 shows `count: 100`.
2. If not, investigate and fix issues in the pipeline configuration and logs.

---

## Conclusion

You have successfully configured a Logstash pipeline to process sample logs and send them to Elasticsearch. This setup demonstrates how to use Logstash for log ingestion and processing, forming a key part of the Elastic Stack.

Explore the indexed data in Elasticsearch using Kibana to visualize and analyze the logs further!
