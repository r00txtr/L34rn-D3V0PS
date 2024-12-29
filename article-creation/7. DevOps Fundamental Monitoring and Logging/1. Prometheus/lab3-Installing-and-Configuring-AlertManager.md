# **Lab 3: Installing and Configuring AlertManager**

### **1. Switch to Root User and Download AlertManager**

Run the following commands:

```bash
sudo su -
cd /opt
wget https://github.com/prometheus/alertmanager/releases/download/v0.27.0/alertmanager-0.27.0.linux-amd64.tar.gz
tar xvfz alertmanager-0.27.0.linux-amd64.tar.gz
```

---

### **2. Configure AlertManager `config.yml`**

Navigate to the AlertManager directory and edit the configuration file:

```bash
cd alertmanager-0.27.0.linux-amd64
vim config.yml
```

**Sample Configuration:**

```yaml
global:
  resolve_timeout: 1s

route:
  group_by: [Alertname]
  receiver: email-admin

receivers:
- name: email-admin
  email_configs:
  - to: "email1@gmail.com"
    from: "email1@gmail.com"
    smarthost: smtp.gmail.com:587
    auth_username: "email1@gmail.com"
    auth_identity: "email1@gmail.com"
    auth_password: "kqgtxxxxtxizxxxx"
    send_resolved: True
```

- Replace `[username]` with your username.
- For the `auth_password`, generate an **App Password** in your Google account:
  - [App Password Guide](https://support.google.com/mail/answer/185833?hl=en)

---

### **3. Create AlertManager as a Service**

Create a systemd service file:

```bash
vim /etc/systemd/system/alert_manager.service
```

**Service Configuration:**

```ini
[Unit]
Description=Alert Manager

[Service]
User=root
ExecStart=/opt/alertmanager-0.27.0.linux-amd64/alertmanager --config.file=/opt/alertmanager-0.27.0.linux-amd64/config.yml --web.external-url=http://172.16.7.10:9093/ --log.level=debug

[Install]
WantedBy=default.target
```

---

### **4. Start AlertManager as a Service**

Run the following commands:

```bash
./amtool check-config config.yml
systemctl daemon-reload
systemctl enable alert_manager.service
systemctl start alert_manager.service
systemctl status alert_manager.service
journalctl -u alert_manager
```

---

### **5. Test AlertManager URLs with `curl`**

Test the following URLs:

```bash
curl http://172.16.7.10:9093/metrics
curl http://172.16.7.10:9093
curl http://172.16.7.10:9093/#/status
```

---

### **6. Access AlertManager in Browser**

Access the following URLs:

- **Metrics**: [http://10.10.10.11:9093/metrics](http://10.10.10.11:9093/metrics)  
- **Dashboard**: [http://10.10.10.11:9093](http://10.10.10.11:9093)  
- **Status**: [http://10.10.10.11:9093/#/status](http://10.10.10.11:9093/#/status)

---

### **7. Create Alert Rules**

Navigate to Prometheus directory and create a rules file:

```bash
cd /opt/prometheus-3.0.1.linux-amd64/
vim mysql_rules.yml
```

**Sample Rule File:**

```yaml
groups:
- name: mysql.rules
  rules:
  - alert: Mysql80Down
    expr: mysql_up{job="mysql-server"} == 0
    for: 5m
    annotations:
      summary: "Service mysql80 Down"
      description: "Container service mysql80 of job {{ $labels.job }} has been down for more than 5 minutes."
```

---

### **8. Update Prometheus Configuration**

Add the following to Prometheus `config.yml`:

```yaml
alerting:
  alertmanagers:
  - static_configs:
    - targets:
      - 172.16.7.10:9093

rule_files:
  - "mysql_rules.yml"
```

Restart Prometheus:

```bash
cd /opt/prometheus-3.0.1.linux-amd64/
./promtool check config config.yml
systemctl restart prometheus_server
```

---

### **9. Test and Verify**

Access the following URLs in a browser:

- Prometheus Configuration: [http://10.10.10.11:9090/config](http://10.10.10.11:9090/config)  
- Rules: [http://10.10.10.11:9090/rules](http://10.10.10.11:9090/rules)  
- Alerts: [http://10.10.10.11:9090/alerts](http://10.10.10.11:9090/alerts)  
- AlertManager Status: [http://10.10.10.11:9093/#/status](http://10.10.10.11:9093/#/status)

Verify the following:

1. **`http://172.16.7.10:9093/#/status`** is accessible via `curl`.  
2. **`http://10.10.10.11:9093/#/status`** is accessible in the browser.  
3. **`mysql.rules`** appears at [http://10.10.10.11:9090/rules](http://10.10.10.11:9090/rules).  
4. **`Mysql80Down`** appears at [http://10.10.10.11:9090/alerts](http://10.10.10.11:9090/alerts).  