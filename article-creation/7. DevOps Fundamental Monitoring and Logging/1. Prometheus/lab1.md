# Lab 1: Installing and Configuring Node Exporter

In this beginner-friendly lab, you’ll learn how to set up **Node Exporter** on a Linux server. Node Exporter is a key component in Prometheus monitoring setups, collecting hardware and OS metrics that can be visualized for system monitoring.

By the end of this lab, you will be able to:

- Download and extract Node Exporter
- Run Node Exporter manually and check its status
- Set up Node Exporter as a service

---

## Prerequisites

Before you start, ensure you have:

- A Linux server with `sudo` access
- Basic command-line knowledge

---

## Step-by-Step Guide

### 1. Switch to the `root` User

For this setup, switch to the `root` user to simplify the installation.

```bash
sudo su
```

### 2. Navigate to the `/opt` Directory

The `/opt` directory is a common place to install optional software packages.

```bash
cd /opt
```

### 3. Download Node Exporter

Use `wget` to download the Node Exporter tarball from the official repository.

```bash
wget https://github.com/prometheus/node_exporter/releases/download/v1.8.2/node_exporter-1.8.2.linux-amd64.tar.gz
```

### 4. Extract the Node Exporter Tarball

Extract the tarball using the `tar` command with the following options:

```bash
tar xvfz node_exporter-1.8.2.linux-amd64.tar.gz
```

**Explanation of Parameters:**

- **`x` (extract)**: Extracts the files from the archive.
- **`v` (verbose)**: Displays the progress of the extraction.
- **`f` (file)**: Specifies the filename to operate on.
- **`z` (zip)**: Indicates the file is compressed using gzip.

### 5. Run Node Exporter Manually

Navigate to the extracted Node Exporter directory and run it manually.

```bash
cd node_exporter-1.8.2.linux-amd64
```

#### View Help Options

```bash
./node_exporter --help
```

#### Check the Version

```bash
./node_exporter --version
```

#### Run Node Exporter

```bash
./node_exporter
```

### 6. Test Node Exporter Locally

Use `curl` to ensure that Node Exporter is running and accessible.

```bash
curl http://172.16.7.10:9100/metrics
curl http://172.16.7.20:9100/metrics
```

Try accessing these metrics from a browser as well:

- [http://10.10.10.11:9100/metrics](http://10.10.10.11:9100/metrics)
- [http://10.10.10.12:9100/metrics](http://10.10.10.12:9100/metrics)

### 7. Set Up Node Exporter as a Systemd Service

To ensure Node Exporter runs on system boot, create a service file.

```bash
vim /etc/systemd/system/node_exporter.service
```

**Add the following content:**

```ini
[Unit]
Description=Node Exporter

[Service]
User=root
ExecStart=/opt/node_exporter-1.8.2.linux-amd64/node_exporter

[Install]
WantedBy=default.target
```

### 8. Enable and Start the Node Exporter Service

Reload the systemd configuration and start the Node Exporter service.

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now node_exporter.service
```

### 9. Check the Status

Verify that Node Exporter is running properly.

```bash
sudo systemctl status node_exporter.service
```

### 10. View Logs

For troubleshooting, check the logs with:

```bash
sudo journalctl -u node_exporter
```

---

## Conclusion

In this lab, you successfully downloaded, installed, and configured **Node Exporter** to run as a service on your Linux system. You can now monitor your system’s metrics through the Node Exporter endpoint, which can be integrated into Prometheus for further analysis and visualization.

**Great job completing Lab 1: Installing and Configuring Node Exporter!**
