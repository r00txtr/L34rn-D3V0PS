# Lab 6: Enhance Logstash Pipeline to Capture SSH Login Failures with User Details

## Introduction

In this lab, you will modify an existing **Logstash** pipeline to extract the username and client IP address from failed SSH login attempts using **Grok**. This modification will enhance your ability to monitor and analyze security-related events. By the end of this lab, you will be able to see detailed information about failed SSH attempts in **Kibana**.

---

## Prerequisites

- Basic familiarity with Linux command line
- Elasticsearch and Kibana running on **node1**
- Logstash configured on **node1**

**Important**: Execute all instructions on **node1** only.

---

## Part 1: Modify Logstash Filter Configuration

### Step 1: Edit the Logstash Pipeline Configuration

1. Open the existing Logstash configuration file:

   ```bash
   sudo vim /etc/logstash/conf.d/filter-authlog.conf
   ```

2. Modify the `filter` section to use the **Grok** pattern for capturing the username and IP address:

   ```yaml
   filter {
     if [fields][log_name] == "auth_log" {
       grok {
         match => [ "message", "Invalid user %{USERNAME:ssh_invalid_user} from %{IP:ssh_client_ip}" ]
         add_tag => [ "ssh_fail", "auth_log" ]
       }
     }

     if [fields][log_name] == "auth_log" and "_grokparsefailure" in [tags] {
       drop { }
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
   - **Grok Filter**: Extracts the `ssh_invalid_user` and `ssh_client_ip` from log messages that match the pattern `Invalid user <username> from <IP>`.
   - **Tag Addition**: Adds `ssh_fail` and `auth_log` tags for easy identification.
   - **Drop Section**: Drops logs that fail the Grok pattern matching to maintain log quality.

3. Save and exit the file.

### Step 2: Restart Logstash Service

Restart the Logstash service to apply the new configuration:

```bash
sudo systemctl restart logstash
```

---

## Part 2: Generate SSH Login Attempts

### Step 1: Attempt SSH Logins to Generate Log Entries

**From pod-node1**, attempt SSH logins to **pod-node2** with invalid usernames:

```bash
ssh -l test1 pod-node2
ssh -l test2 pod-node2
ssh -l test3 pod-node2
```

Repeat these commands a few times to ensure logs are captured.

---

## Part 3: Visualize Logs in Kibana

### Step 1: Search for Logs in the Discover Menu

1. Open **Kibana** in your web browser at:

   ```text
   http://10.10.10.11:5601
   ```

2. Navigate to **Discover**.

3. In the search bar, type the following query to find logs with specific invalid users:

   ```text
   ssh_invalid_user: test1,test2,test3
   ```

4. Click **Refresh** to display the results.

**Expected Outcome**:

- You should see logs containing the extracted `ssh_invalid_user` and `ssh_client_ip` fields for failed login attempts.
- The logs should have the `ssh_fail` and `auth_log` tags.

---

## Verification

Ensure that the search results in **Kibana** display logs with the `ssh_invalid_user` field populated with `test1`, `test2`, or `test3`, along with the client IP address. This confirms that the **Grok** filter in the Logstash pipeline is functioning correctly.

---

## Conclusion

You have successfully enhanced the **Logstash** pipeline to extract and tag detailed information about failed SSH login attempts, including the username and client IP address. This lab strengthens your ability to monitor potential security incidents by providing clear, structured data for analysis in **Kibana**.

Feel free to explore additional **Grok** patterns and tags to further customize your log parsing and monitoring capabilities!
