# Lab 6: Testing AlertManager with Prometheus

In this lab, you will test the AlertManager setup from previous labs by simulating a failure scenario where the MySQL container (`mysql80`) is stopped. This will trigger an alert and send an email notification.

By the end of this lab, you will:

- Stop the `mysql80` container to simulate an alert condition
- Verify the alert status in Prometheus
- Check for email notifications sent by AlertManager

---

## Prerequisites

- Completion of **Lab 4** and **Lab 5**
- A properly configured Prometheus and AlertManager setup with email notifications enabled

---

## Step-by-Step Guide

### 1. Stop the `mysql80` Container

To simulate a failure and trigger the alert, stop the MySQL container:

```bash
sudo docker stop mysql80
```

### 2. Access Prometheus Alerts

Navigate to Prometheus to check the alert status:

- Open [http://10.10.10.11:9090/alerts](http://10.10.10.11:9090/alerts) in your browser.

**What to expect**:

- The `Mysql80Down` alert should change to **FIRING** status within a few moments, indicating that Prometheus has detected the issue.

### 3. Check Your Email

Once the alert is firing, AlertManager should send an email notification. 

**Verify**:

- Ensure that you receive an email alert from AlertManager indicating the `Mysql80Down` status.

---

## Verification Steps

### 1. Confirm Lab Completion

- Ensure that **Lab 4** and **Lab 5** were completed successfully, as they set up the necessary infrastructure.

### 2. Verify the `Mysql80Down` Alert

- Confirm that the `Mysql80Down` alert status is **FIRING** at [http://10.10.10.11:9090/alerts](http://10.10.10.11:9090/alerts).

### 3. Check Email Notification

- Confirm that you have received an email notification from AlertManager indicating that the `Mysql80Down` alert is **FIRING**.

**Troubleshooting**:

- If the alert is **FIRING** but you haven’t received an email, check connectivity to the SMTP server:

  ```bash
  nc -zv smtp.gmail.com 587
  curl smtp.gmail.com:587
  ```

- If the SMTP connection is successful, try restarting the alert process:

  ```bash
  sudo docker start mysql80
  sudo docker stop mysql80
  ```

---

**Congratulations!** You have completed Lab 6: Testing AlertManager with Prometheus.