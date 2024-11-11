# Lab 2: Creating Grafana Dashboard for Pod Monitoring

## Introduction

In this lab, we will create a Grafana dashboard to monitor the status, uptime, restart total, and CPU usage for a specific node (`pod-node2`). You will learn how to use Prometheus queries to create visualizations and customize them to display data effectively.

## Step-by-Step Instructions

### Step 1: Create a Status Visualization

1. **Access Grafana Dashboard**:
   - Log in to your Grafana instance.
   - Navigate to **Dashboard > New > New Dashboard > Add visualization**.

2. **Set the Data Source**:
   - Select **Prometheus-server** as the data source.

3. **Enter the Query**:
   - Paste the following query in the **Query Field**:

     ```promql
     up{instance="172.16.7.20:9100",job="node-server"}
     ```

4. **Set Query Options**:
   - Set the query type to **Instant**.

5. **Change Visualization Type**:
   - Change the visualization from **Time Series** to **Stat**.

6. **Configure Panel Options**:
   - Set the **Title** to `Status`.

7. **Add Value Mappings**:
   - Go to the **Value Mapping** tab and add the following mappings:
     - **First Row**:
       - **Condition**: 1
       - **Display text**: Up
       - **Set color**: Green
     - **Second Row**:
       - **Condition**: 0
       - **Display text**: Down
       - **Set color**: Red

8. **Update and Save**:
   - Click **Update**.
   - Save the dashboard and name it **pod-node2**.

### Step 2: Create an Uptime Visualization

1. **Add a New Visualization**:
   - Go to **Dashboard pod-node2 > Add visualization**.

2. **Set the Data Source**:
   - Choose **Prometheus-server**.

3. **Enter the Query**:

   ```promql
   (time() - process_start_time_seconds{instance="172.16.7.20:9100",job="node-server"})
   ```

4. **Set Query Options**:
   - Set the query type to **Instant**.

5. **Change Visualization Type**:
   - Change the visualization from **Time Series** to **Stat**.

6. **Configure Panel Options**:
   - Set the **Title** to `Uptime`.

7. **Set Standard Options**:
   - **Unit**: `Seconds(s)`
   - **Color scheme**: From thresholds (by value).

8. **Configure Thresholds**:
   - Remove the default red `80` value.

9. **Save and Apply**:
   - Save the visualization.

### Step 3: Create a Restart Total Visualization

1. **Add a New Visualization**:
   - Go to **Dashboard pod-node2 > Add visualization**.

2. **Set the Data Source**:
   - Choose **Prometheus-server**.

3. **Enter the Query**:

   ```promql
   changes(process_start_time_seconds{instance="172.16.7.20:9100"}[7d])
   ```

4. **Set Query Options**:
   - Set the query type to **Instant**.

5. **Change Visualization Type**:
   - Change the visualization from **Time Series** to **Stat**.

6. **Configure Panel Options**:
   - Set the **Title** to `Restart Total`.

7. **Configure Thresholds**:
   - Remove the default red `80` value.

8. **Save and Apply**:
   - Save the visualization.

### Step 4: Create a CPU Usage Visualization (Gauge)

1. **Add a New Visualization**:
   - Go to **Dashboard pod-node2 > Add visualization**.

2. **Set the Data Source**:
   - Choose **Prometheus-server**.

3. **Enter the Query**:

   ```promql
   100 - (avg(irate(node_cpu_seconds_total{mode="idle",instance="172.16.7.20:9100"}[5m])) * 100)
   ```

4. **Change Visualization Type**:
   - Change the visualization from **Time Series** to **Gauge**.

5. **Configure Panel Options**:
   - Set the **Title** to `CPU Usage[5m]`.

6. **Set Standard Options**:
   - **Unit**: `Percent (0 - 100)`
   - **Min**: 0
   - **Max**: 100.

7. **Configure Thresholds**:
   - **Thresholds mode**: Percentage.

8. **Save and Apply**:
   - Save the visualization.

### Step 5: Create a CPU Usage Visualization (Time Series)

1. **Add a New Visualization**:
   - Go to **Dashboard pod-node2 > Add visualization**.

2. **Set the Data Source**:
   - Choose **Prometheus-server**.

3. **Enter the Query**:

   ```promql
   100 - (avg(irate(node_cpu_seconds_total{mode="idle",instance="172.16.7.20:9100"}[1m])) * 100)
   ```

4. **Set Legend Options**:
   - **Custom**: `CPU usage in 1m`.

5. **Configure Panel Options**:
   - Set the **Title** to `CPU Usage`.

6. **Graph Style Options**:
   - **Line interpolation**: Smooth.
   - **Line width**: 3.
   - **Fill opacity**: 25.
   - **Gradient mode**: Scheme.
   - **Point size**: 5.

7. **Set Standard Options**:
   - **Unit**: `Percent (0 - 100)`
   - **Min**: 0.
   - **Max**: 100.
   - **Color scheme**: Green-Yellow-Red (by value).

8. **Configure Thresholds**:
   - **Thresholds mode**: Percentage.
   - **Show thresholds**: As filled regions.

9. **Save and Apply**:
   - Save the visualization.

## Conclusion

You have successfully created various visualizations for monitoring **pod-node2** in Grafana. These panels provide valuable insights into the status, uptime, restart counts, and CPU usage of the node. Use this dashboard to monitor your system's performance and detect potential issues early.
