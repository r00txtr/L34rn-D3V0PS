# Lab 11: Creating Kibana Visualizations and Dashboard

## Introduction

In this lab, you will create three visualizations in **Kibana** and combine them into a dashboard. These visualizations will help you analyze and present data from the `challenge1_username` index created in the previous lab. This guide is written in a beginner-friendly tone with step-by-step instructions, examples, and where applicable, screenshots.

---

## Prerequisites

- ELK stack (Elasticsearch, Logstash, Kibana) running on **pod-node1**
- Data indexed in **Elasticsearch** under `challenge1_username` from the previous lab

---

## Part 1: Create a Metric Visualization

### Step 1: Create the Metric Visualization

1. Open **Kibana** in your web browser at:

   ```text
   http://<pod-node1-IP>:5601
   ```

2. Navigate to **Visualize Library**.
3. Click **"Create a visualization"**.
4. Choose **"Aggregation Based"** and select **"Metric"**.

### Step 2: Configure the Metric Visualization

1. Select the **`challenge1_username`** index as the data source.
2. Set the following configuration:
   - **Aggregation**: `Count`
3. Click **"Update"** to display the total number of logs.

### Step 3: Save the Metric Visualization

1. Click **"Save visualization"**.
2. Name the visualization **"c1-total-log"**.
3. Click **"Save"**.

---

## Part 2: Create a Horizontal Bar Visualization

### Step 1: Create the Bar Visualization

1. Go back to **Visualize Library**.
2. Click **"Create a visualization"**.
3. Choose **"Aggregation Based"** and select **"Horizontal Bar"**.

### Step 2: Configure the Bar Visualization

1. Select the **`challenge1_username`** index as the data source.
2. Configure the following settings:
   - **X-axis**:
     - **Aggregation**: `Date Histogram`
     - **Field**: `c1_time`
3. Click **"Update"** to display the bar chart.

### Step 3: Save the Bar Visualization

1. Click **"Save visualization"**.
2. Name the visualization **"c1-time-log-collect"**.
3. Click **"Save"**.

---

## Part 3: Create a Data Table Visualization

### Step 1: Create the Data Table Visualization

1. Navigate to **Visualize Library**.
2. Click **"Create a visualization"**.
3. Choose **"Aggregation Based"** and select **"Data Table"**.

### Step 2: Configure the Data Table Visualization

1. Select the **`challenge1_username`** index as the data source.
2. Add the following columns in this order:
   - **Column 1**:
     - **Field**: `@timestamp`
     - **Aggregation**: `Date Histogram`
   - **Column 2**:
     - **Field**: `c1_hostname`
     - **Aggregation**: `Terms`
   - **Column 3**:
     - **Field**: `c1_log_level`
     - **Aggregation**: `Terms`
   - **Column 4**:
     - **Field**: `c1_info`
     - **Aggregation**: `Terms`
3. Click **"Update"** to display the data table.

### Step 3: Save the Data Table Visualization

1. Click **"Save visualization"**.
2. Name the visualization **"c1-detail-log"**.
3. Click **"Save"**.

---

## Part 4: Create the Dashboard

### Step 1: Create a New Dashboard

1. Navigate to **Dashboard** in **Kibana**.
2. Click **"Create new dashboard"**.

### Step 2: Add Visualizations to the Dashboard

1. Click **"Add from library"**.
2. Select:
   - **"c1-total-log"**
   - **"c1-time-log-collect"**
   - **"c1-detail-log"**
3. Arrange the visualizations as needed.

### Step 3: Save the Dashboard

1. Click **"Save"**.
2. Name the dashboard **"dashboard-challenge-username"**.
3. Click **"Save"**.

---

## Verification

1. Ensure the names of the visualizations are:
   - **"c1-total-log"**
   - **"c1-time-log-collect"**
   - **"c1-detail-log"**
2. Confirm that the dashboard is named **"dashboard-challenge-username"** and includes the correct visualizations.
3. Verify that data is displayed correctly in each visualization.

**Expected Outcome**:

- The **Metric visualization** should show the total number of logs.
- The **Horizontal bar visualization** should display log data over time based on the `c1_time` field.
- The **Data table** should display columns in the order of `@timestamp`, `c1_hostname`, `c1_log_level`, and `c1_info`.

---

## Conclusion

You have successfully created three visualizations and combined them into a dashboard in **Kibana**. This dashboard helps you analyze the log data indexed under `challenge1_username` effectively. You can further customize these visualizations or add more to enhance your data analysis capabilities.
