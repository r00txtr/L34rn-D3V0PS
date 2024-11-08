# Lab 3: Simple Pipeline with Jenkins

In this lab, you will create a **simple Jenkins pipeline** to familiarize yourself with the Jenkins interface and the basics of setting up a project. By the end of this lab, you will have created a basic project in Jenkins, configured essential build options, and run a job that outputs "Hello World, I am learning Jenkins" in the console.

---

## Table of Contents
1. **Introduction**
2. **Step-by-Step Instructions**
    1. Accessing Jenkins Dashboard
    2. Creating a New Jenkins Project
    3. Configuring Project Options
    4. Adding Build Steps
    5. Building the Project
    6. Viewing Console Output
3. **Verification**
4. **Conclusion**

---

## Introduction

This lab is designed to introduce you to Jenkins’ **Freestyle project** functionality. You’ll learn to:
1. Set up a new project in Jenkins.
2. Configure essential project settings.
3. Define build steps to run basic shell commands.

Freestyle projects are a simple type of job that allows for quick builds without complex configurations, making them ideal for beginners.

---

## Step-by-Step Instructions

### Step 1: Accessing Jenkins Dashboard

1. Open your browser and go to `http://localhost:8080`.
2. Log in to Jenkins if prompted.

---

### Step 2: Creating a New Jenkins Project

1. From the Jenkins dashboard, click **New Item**.
2. In the **Enter an item name** field, type `Belajar-Jenkins-01`.
3. Select **Freestyle project** and click **OK**.

---

### Step 3: Configuring Project Options

You’ll now configure various options in the project settings to customize the behavior of your Jenkins job.

#### 3.1 General

1. **Description**: This is a plain text field where you can add a brief summary of the project. It helps others understand the purpose of the job.
   - **Example**: "This is a simple Jenkins job to demonstrate basic configuration and build steps."

2. **Discard Old Builds**: When enabled, Jenkins will automatically delete old build data based on the number or age of builds.
   - Useful for saving storage space.

3. **GitHub Project**: If the project is hosted on GitHub, enabling this option allows Jenkins to link directly to it.

4. **This project is parameterized**: Lets you add parameters to the job (e.g., environment variables). 
   - Parameters are useful for controlling job behavior without modifying the project configuration.

5. **Throttle Builds**: Controls the frequency of builds for resource management.
   - Useful in environments with limited resources or high job volumes.

6. **Execute concurrent builds if necessary**: Allows Jenkins to run multiple builds of the same job simultaneously.
   - Useful for projects that can handle parallel processing.

7. **Quiet Period**: Specifies a delay (in seconds) before a build is triggered. 
   - Useful for avoiding frequent builds due to minor changes.

8. **Retry Count**: Defines the number of attempts Jenkins will make if a build fails.

9. **Block build when upstream/downstream project is building**: Prevents conflicts by blocking this job while other related jobs are running.

10. **Use custom workspace**: Lets you specify a directory outside of Jenkins’s default workspace for the job.

11. **Display Name**: Sets a custom name for this build, visible in the Jenkins interface.

12. **Keep the build logs of dependencies**: Retains logs from dependent jobs to improve traceability.

#### 3.2 Source Code Management

- **None**: Choose this if no source code is required for the project.
- **Git**: Allows you to specify a Git repository URL if the job requires code.

#### 3.3 Build Triggers

1. **Trigger builds remotely**: Enables triggering builds from an external script or system.
2. **Build after other projects are built**: Configures the job to trigger after specific projects complete.
3. **Build periodically**: Schedules the job to run at regular intervals.
4. **GitHub hook trigger for GITScm polling**: Triggers the job based on GitHub webhooks.
5. **Poll SCM**: Checks the source control for changes periodically and triggers the job if there’s a modification.

#### 3.4 Build Environment

1. **Delete workspace before build starts**: Clears any existing data in the workspace, ensuring a fresh build.
2. **Use secret text(s) or file(s)**: Adds secrets or files securely for use within the build.
3. **Add timestamps to the Console Output**: Includes timestamps in logs to improve tracking.
4. **Terminate a build if it's stuck**: Stops builds if they exceed a certain duration, avoiding resource wastage.

#### 3.5 Build Steps

1. Click **Add build step** and select **Execute shell**.
2. Enter the following command in the text field:

   ```bash
   echo "Hello World, I am learning Jenkins"
   ```

---

### Step 4: Saving and Running the Project

1. Click **Save** to store your project configuration.
2. From the project page, click **Build Now** to start the job.

---

### Step 5: Viewing Console Output

1. Once the build completes, go to **Build History** and click on the build number to open the build details.
2. Select **Console Output** to see the result of the job.

   The output should display:

   ```
   Hello World, I am learning Jenkins
   ```

---

## Verification

To verify the success of this lab, ensure the following:
1. **Project Creation**: A project named `Belajar-Jenkins-01` was created successfully.
2. **Build Execution**: The build completed without errors.
3. **Console Output**: The phrase "Hello World, I am learning Jenkins" appears in the console log.

---

## Conclusion

In this lab, you learned to create a simple Jenkins pipeline by setting up a **Freestyle project** with basic configurations and running a shell command as a build step. This foundational knowledge will help you as you explore more advanced Jenkins functionalities.

Congratulations on completing **Lab 3: Simple Pipeline with Jenkins**!