# Lab 5: Creating a Simple Pipeline on Docker Agent with Maven in Jenkins

In this lab, you will create and run a Jenkins project configured to execute a basic Maven command on a Docker Build Agent. This setup leverages the Docker agent configured with Maven to validate that the environment is correctly provisioned and ready for CI/CD processes.

By the end of this lab, you will:

1. Set up a Jenkins Freestyle project to execute a Maven command on a Docker agent.
2. Restrict the project to run only on the Maven-labeled Docker agent.
3. Confirm the build execution and check the console output for validation.

---

## Table of Contents

1. **Introduction**
2. **Overview**
3. **Step-by-Step Instructions**
    1. Creating a New Jenkins Item
    2. Configuring Build Settings
    3. Running and Verifying the Build
4. **Verification**
5. **Conclusion**

---

## Introduction

In this lab, you'll create a basic Jenkins job to test the Docker Build Agent configured in previous labs. Using a Maven-labeled agent template, Jenkins will execute a simple command to retrieve Maven’s version information. This setup ensures that the Docker environment is properly configured and ready for future build tasks.

---

## Overview of Lab 5: Creating a Simple Pipeline on Docker Agent with Maven

In this lab, you’ll:

1. Create a new Jenkins job called **Simple Pipeline on Docker Agent Maven**.
2. Configure the job to run on a Docker Build Agent labeled specifically for Maven builds.
3. Execute a basic Maven command to verify the configuration.

### Why This Configuration?

Setting up a Freestyle project with Docker agents allows Jenkins to:

1. Verify agent functionality and environment setup.
2. Confirm the Docker agent can execute Maven commands.
3. Serve as a foundation for more complex builds using the configured Docker agent.

---

## Step-by-Step Instructions

### Step 1: Creating a New Jenkins Item

1. Go to the **Jenkins Dashboard**.
2. Click **New Item** on the left-hand side.
3. Enter the item name: **Simple Pipeline on Docker Agent Maven**.
4. Choose **Freestyle Project** as the item type.
5. Click **OK** to create the new item.

### Step 2: Configuring Build Settings

1. In the project configuration page, under **General**, check **Restrict where this project can be run**.
2. In the **Label Expression** field, enter the label assigned to the Docker agent (e.g., `Maven-Labels`). This label should match the one set up on your Docker Build Agent template for Maven.
   - You may see a message: "Label Maven-Labels matches no nodes and 1 cloud. Permissions or other restrictions provided by plugins may further reduce that list." This is normal as Jenkins dynamically provisions the agent.

3. **Build Steps**:
   - Scroll to the **Build** section.
   - Click **Add Build Step** and select **Execute Shell**.
   - In the command field, enter:

     ```bash
     mvn --version
     ```

   This command will display the version of Maven installed in the Docker container, validating that the agent is configured correctly.

4. Click **Save** to apply the configuration.

### Step 3: Running and Verifying the Build

1. Go back to the project’s main page.
2. Click **Build Now** to start the build process.
3. To view the build’s progress and output, click on the build number under **Build History** and then select **Console Output**.

---

## Console Output Details

The console output should display the following steps:

- **Running as SYSTEM**: Indicates that Jenkins is executing the build.
- **Building remotely on Maven-00000lmu4wm2n on Docker-Build-Agent (Maven-Labels) in workspace /workspace/Simple Pipeline on Docker Agent Maven**: Confirms that the build is running on the Docker agent with the `Maven-Labels` label.
- **Maven Version Output**:
  
  ```bash
  + mvn --version
  Apache Maven 3.9.9 (8e8579a9e76f7d015ee5ec7bfcdc97d260186937)
  Maven home: /usr/share/maven
  Java version: 11.0.25, vendor: Eclipse Adoptium, runtime: /opt/java/openjdk
  Default locale: en_US, platform encoding: UTF-8
  OS name: "linux", version: "5.15.146.1-microsoft-standard-wsl2", arch: "amd64", family: "unix"
  Finished: SUCCESS
  ```

   This output confirms:
  - The Docker agent is correctly configured with Maven.
  - Jenkins can successfully execute commands on the Docker container.
  - The Java and Maven versions meet the expected configuration.

---

## Conclusion

In **Lab 5**, you created a Jenkins Freestyle project to test the Docker Build Agent configured with Maven. By running a basic Maven command, you confirmed that Jenkins can interact with Docker agents and execute builds as expected.

Congratulations on completing **Lab 5: Creating a Simple Pipeline on Docker Agent with Maven in Jenkins**! You now have a verified Docker Build Agent setup ready for more complex builds and CI/CD workflows.