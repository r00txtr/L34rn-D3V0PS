# Lab 7: Create Visualizations and Dashboard in Kibana

## Introduction

In this lab, you will learn how to create two visualizations — a **Tag Cloud** and an **Area Chart** — in **Kibana** and then combine them into a dashboard. These visualizations will help you monitor and analyze failed SSH login attempts by showing which users triggered these failures and the frequency of the attempts over time. The lab is designed with beginners in mind, providing detailed explanations and steps.

---

## Prerequisites

- Basic understanding of Kibana and Elasticsearch
- An index pattern named `auth_log_*` already created in Kibana

**Note**: Screenshots are not provided here but are highly recommended when implementing these steps for documentation.

---

## Part 1: Create a Tag Cloud Visualization

### Step 1: Access the Kibana Dashboard

1. Open **Kibana** in your web browser using the URL provided (e.g., `http://10.10.10.11:5601`).

### Step 2: Navigate to the Visualize Library

1. Click the **menu icon (𝄘)** on the left side.
2. Select **"Visualize Library"**.

### Step 3: Create a New Visualization

1. Click **"Create a visualization"**.
2. Choose **"Aggregation Based"**.
3. Select **"Tag Cloud"**.

### Step 4: Configure the Tag Cloud

1. Choose **`auth_log_*`** as the data source index.
2. Under **Buckets**, click **"Add"** and select **"Tags"**.
3. Configure the following settings:
   - **Aggregation**: `Terms`
   - **Field**: `ssh_invalid_user.keyword`
4. Click **"Update"** to refresh the visualization.

### Step 5: Save the Tag Cloud Visualization

1. Click **"Save visualization"**.
2. Name the visualization **"Tag Cloud Invalid Users"**.
3. Click **"Save"**.

---

## Part 2: Create an Area Chart Visualization

### Step 1: Navigate to the Visualize Library

1. Click **"Visualize Library"** from the left menu.

### Step 2: Create a New Visualization

1. Click **"Create a visualization"**.
2. Choose **"Aggregation Based"**.
3. Select **"Area"**.

### Step 3: Configure the Area Chart

1. Choose **`auth_log_*`** as the data source index.
2. Under **Buckets**, click **"Add"** and choose **"X-axis"**.
3. Set the following parameters:
   - **Aggregation**: `Date Histogram`
   - **Field**: `@timestamp`
4. Click **"Update"** to refresh the visualization.

### Step 4: Save the Area Chart Visualization

1. Click **"Save visualization"**.
2. Name the visualization **"Area Count Invalid User"**.
3. Click **"Save"**.

---

## Part 3: Create a Dashboard

### Step 1: Navigate to the Dashboard Menu

1. Click **"Dashboard"** from the left menu.

### Step 2: Create a New Dashboard

1. Click **"Create new dashboard"**.

### Step 3: Add Visualizations to the Dashboard

1. Click **"Add from library"**.
2. Select **"Tag Cloud Invalid Users"** and **"Area Count Invalid User"** to add them to the dashboard.

### Step 4: Save the Dashboard

1. Click **"Save"**.
2. Name the dashboard **"dashboard-practice"**.
3. Click **"Save"**.

---

## Verification

1. Ensure that the visualizations are named **"Tag Cloud Invalid Users"** and **"Area Count Invalid User"** with the correct capitalization.
2. Verify that the dashboard is saved as **"dashboard-practice"** with the added visualizations.

**Expected Outcome**:

- The **Tag Cloud** visualization should display usernames from failed SSH attempts, sized by frequency.
- The **Area Chart** should show the trend of failed SSH login attempts over time.

---

## Conclusion

You have successfully created and saved a **Tag Cloud** and an **Area Chart** visualization, combined them into a **Kibana Dashboard**, and verified that everything is displayed correctly. This dashboard will help you monitor and analyze failed SSH login attempts in a visual and intuitive way.

Feel free to customize the visualizations and dashboard further to meet your monitoring needs!
