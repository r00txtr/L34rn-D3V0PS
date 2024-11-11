# Lab 2: Install and Configure Filebeat and Kibana

## Introduction

In this lab, you will install and configure **Filebeat** on node2 and **Kibana** on node1. Filebeat is a lightweight shipper for forwarding and centralizing log data, while Kibana provides visualization and management capabilities for your Elastic Stack. By the end of this lab, you will have Filebeat collecting logs and Kibana ready to display them.

---

## Prerequisites

- Basic familiarity with Linux command line
- A two-node setup:
  - **node1**: For Kibana
  - **node2**: For Filebeat
- Internet connection

**Important**: Follow the instructions carefully, as steps for node1 and node2 are clearly marked.

---

## Step-by-Step Instructions

### Part 1: Filebeat Setup on Node2

**Execute the following steps on node2 only.**

---

#### Step 1: Install Dependencies

Filebeat requires Java and other essential tools. Install them using:

```bash
sudo apt update
sudo apt install -y openjdk-17-jre apt-transport-https curl wget
```

---

#### Step 2: Add Elasticsearch Public Signing Key

Download and add the Elasticsearch GPG key:

```bash
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg
```

---

#### Step 3: Add Elasticsearch Repository

Add the Elasticsearch repository for installing Filebeat:

```bash
echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list
```

---

#### Step 4: Install and Start Filebeat

Update the package list and install Filebeat:

```bash
sudo apt-get update
sudo apt-get install filebeat
```

Start and enable the Filebeat service:

```bash
sudo systemctl start filebeat.service
sudo systemctl enable filebeat.service
sudo systemctl status filebeat.service
```

**Expected Output**:

- Filebeat service status should display `Active: active (running)`.

**Exit node2** after completing these steps:

```bash
exit
```

---

### Part 2: Kibana Setup on Node1

**Execute the following steps on node1 only.**

---

#### Step 1: Install and Start Kibana

Install Kibana:

```bash
sudo apt install -y kibana
```

Start and enable the Kibana service:

```bash
sudo systemctl start kibana
sudo systemctl enable kibana
sudo systemctl status kibana
```

**Expected Output**:

- Kibana service status should display `Active: active (running)`.

---

#### Step 2: Configure Kibana for External Access

Edit the Kibana configuration file:

```bash
sudo vim /etc/kibana/kibana.yml
```

Update the following configuration to allow Kibana to listen on all IPv4 networks:

```yaml
# The default is 'localhost', which usually means remote machines will not be able to connect.
# To allow connections from remote users, set this parameter to a non-loopback address.
server.host: "0.0.0.0"
```

---

#### Step 3: Restart Kibana Service

Restart the Kibana service to apply the configuration:

```bash
sudo systemctl restart kibana
```

Verify that the service is running:

```bash
sudo apt install -y net-tools
netstat -tulpn | grep 5601
sudo systemctl status kibana.service
```

**Expected Output**:

- The netstat command should show Kibana listening on port `5601`.
- The Kibana service status should display `Active: active (running)`.

---

#### Step 4: Access Kibana Web Interface

To access Kibana, open a browser and navigate to:

```text
http://10.10.10.11:5601
```

**Tip**: Ensure your browser and Kibana are on the same network for successful access.

---

## Verification

1. **Filebeat**: Verify the Filebeat service on node2 is running (`Active: active (running)`).
2. **Kibana**:
   - Confirm that Kibana is listening on port `5601` (use `netstat`).
   - Access the Kibana web interface and ensure it loads correctly.

---

## Conclusion

You have successfully set up Filebeat on node2 to collect log data and Kibana on node1 to visualize the data. This foundational setup will enable you to monitor logs efficiently using the Elastic Stack.

Feel free to explore the Kibana interface and Filebeat configurations to tailor them to your needs!
