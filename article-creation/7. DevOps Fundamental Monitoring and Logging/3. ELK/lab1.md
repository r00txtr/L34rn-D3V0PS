# Lab 1: Install and Configure Elasticsearch and Logstash for Beginners

## Introduction

This lab provides a step-by-step guide to installing and configuring **Elasticsearch** and **Logstash**, two essential components of the Elastic Stack. By the end of this lab, you will have Elasticsearch and Logstash installed, configured, and running on a node. This guide is tailored for beginners, with explanations, examples, and notes to help you understand each step.

---

## Prerequisites

- Basic familiarity with Linux command line
- A server or virtual machine (node1) with Ubuntu or a similar Linux distribution
- Internet connection

**Important**: Execute all commands on **node1** only.

---

## Step-by-Step Instructions

### Step 1: Install Dependencies

Elasticsearch and Logstash require Java and other dependencies to function properly. Install them using the following commands:

```bash
sudo apt update
sudo apt install -y openjdk-17-jre apt-transport-https curl wget
```

- `openjdk-17-jre`: Required for running Elasticsearch and Logstash.
- `apt-transport-https`: Ensures secure communication with the package repository.
- `curl`, `wget`: Tools for downloading files.

---

### Step 2: Add Elasticsearch Public Signing Key

Download and install the public signing key:

```bash
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg
```

This key ensures the authenticity of packages from Elasticsearch’s repository.

---

### Step 3: Add Elasticsearch Repository

Add the Elasticsearch repository to your system:

```bash
echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list
```

**Why not use `add-apt-repository`?**

- `add-apt-repository` modifies `/etc/apt/sources.list`, not `/etc/apt/sources.list.d/`.
- It’s not included by default in many Linux distributions and has extra dependencies.

---

### Step 4: Install and Start Elasticsearch and Logstash

Update the package list and install the required components:

```bash
sudo apt-get update
sudo apt-get install elasticsearch logstash
```

Start and enable the services:

```bash
sudo systemctl start elasticsearch.service logstash.service
sudo systemctl enable elasticsearch.service logstash.service
```

**Notes**:

- If your VM has low specifications, the services might take some time to start.
- If Logstash gets stuck during restart, refer to this [discussion](https://discuss.elastic.co/t/logstash-stuck-after-restart-stop-command/310797/2):

  ```bash
  ps -ef | grep logstash
  sudo kill -9 <pid_from_previous_command>
  ```

---

### Step 5: Configure Elasticsearch to Listen on All IPv4 Networks

Edit the Elasticsearch configuration file:

```bash
sudo vim /etc/elasticsearch/elasticsearch.yml
```

Add or modify the following lines:

```yaml
# ---------------------------------- Network -----------------------------------
network.host: 0.0.0.0
http.port: 9200

# --------------------------------- Discovery ----------------------------------
discovery.seed_hosts: ["127.0.0.1", "[::1]"]

# Disable security for this lab
xpack.security.enabled: false
```

**Note**: For production environments, it is highly recommended to enable security features.

---

### Step 6: Restart Elasticsearch to Apply Configuration

Restart Elasticsearch to load the updated configuration:

```bash
sudo systemctl restart elasticsearch
sudo systemctl status elasticsearch
```

---

### Step 7: Verify Elasticsearch from pod-node2

On **node2**, verify that Elasticsearch is working:

```bash
curl -X GET "172.16.7.10:9200/?pretty"
```

Expected output:

```json
{
  "name" : "pod-node1",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "eFB_1f_jTWiIMWpwbZwyWw",
  "version" : {
    "number" : "8.8.0",
    "build_flavor" : "default",
    "build_type" : "deb",
    "build_hash" : "c01029875a091076ed42cdb3a41c10b1a9a5a20f",
    "build_date" : "2023-05-23T17:16:07.179039820Z",
    "build_snapshot" : false,
    "lucene_version" : "9.6.0",
    "minimum_wire_compatibility_version" : "7.17.0",
    "minimum_index_compatibility_version" : "7.0.0"
  },
  "tagline" : "You Know, for Search"
}
```

---

## Verification

Ensure the output from Step 7 matches the expected result. If it does, Elasticsearch is successfully installed and running.

---

## Conclusion

You have successfully installed Elasticsearch and Logstash on node1, configured Elasticsearch to listen on all IPv4 networks, and verified its functionality from pod-node2. This setup is the foundation for a robust log and metrics management system.

Feel free to explore more features of Elasticsearch and Logstash to enhance your observability stack!
