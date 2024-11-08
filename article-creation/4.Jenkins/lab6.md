# Lab 6: Creating a Simple Jenkins Declarative Pipeline with Maven on Docker Agent

In this lab, you will create a Jenkins Pipeline job to run Maven commands within a Docker Build Agent, allowing Jenkins to pull a sample project from Git and perform a compile step to ensure everything is set up correctly for CI/CD automation.

By the end of this lab, you will:

1. Set up a Pipeline project in Jenkins to run on a Docker agent labeled with Maven.
2. Pull a Git repository with vulnerable Java web application code.
3. Execute Maven commands to compile the project and verify the build output.

---

## Table of Contents

1. **Introduction**
2. **Step-by-Step Instructions**
    - Creating a New Pipeline Project
    - Configuring the Pipeline Script
    - Running and Verifying the Build
3. **Console Output Verification**
4. **Conclusion**

---

## Step-by-Step Instructions

### Step 1: Creating a New Pipeline Project

1. Go to the **Jenkins Dashboard**.
2. Click **New Item** on the left-hand side.
3. Enter the item name: **Simple Jenkins Declarative Pipeline**.
4. Select **Pipeline** as the item type and click **OK** to create the new item.

### Step 2: Configuring the Pipeline Script

1. In the configuration page, scroll to the **Pipeline** section.
2. Select **Pipeline script** and enter the following code to configure the pipeline stages and agent setup:

    ```groovy
    pipeline {
        agent none
        stages {
            stage('Maven Compile') {
                agent {
                    label 'Maven-Labels'
                }
                steps {
                    git 'https://github.com/r00txtr/VulnerableJavaWebApplication.git'
                    sh 'mvn compile'
                }
            }
        }
    }
    ```

3. Click **Save** to apply the configuration.

### Step 3: Running and Verifying the Build

1. Return to the project’s main page.
2. Click **Build Now** to start the build process.
3. To monitor the build’s progress and output, click on the build number under **Build History** and then select **Console Output**.

---

## Console Output Details

In the **Console Output**, you should see logs similar to the following, confirming the compilation success:

```plaintext
Downloaded from central: https://repo.maven.apache.org/maven2/com/google/collections/google-collections/1.0/google-collections-1.0.jar (640 kB at 1.3 MB/s)
[INFO] Changes detected - recompiling the module!
[INFO] Compiling 8 source files to /workspace/Simple Jenkins Declarative Pipeline/target/classes
[WARNING] /workspace/Simple Jenkins Declarative Pipeline/src/main/java/com/github/rafaelrpinto/vulnerablejavawebapp/config/AppLauncher.java: /workspace/Simple Jenkins Declarative Pipeline/src/main/java/com/github/rafaelrpinto/vulnerablejavawebapp/config/AppLauncher.java uses or overrides a deprecated API.
[WARNING] /workspace/Simple Jenkins Declarative Pipeline/src/main/java/com/github/rafaelrpinto/vulnerablejavawebapp/config/AppLauncher.java: Recompile with -Xlint:deprecation for details.
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  17.274 s
[INFO] Finished at: 2024-10-28T13:35:14Z
[INFO] ------------------------------------------------------------------------
```

This output confirms:

- The Git repository was successfully pulled.
- Maven compiled the project without critical errors.
- The pipeline ran as expected on the Docker agent labeled `Maven-Labels`.

---

## Conclusion

In **Lab 6**, you successfully configured a Jenkins Declarative Pipeline to pull a Java project from Git and compile it using Maven within a Docker Build Agent. This setup confirms Jenkins’ ability to interact with Docker agents, Git, and Maven, laying the groundwork for more sophisticated CI/CD processes.

Congratulations on completing **Lab 6: Creating a Simple Jenkins Declarative Pipeline with Maven on Docker Agent**!
