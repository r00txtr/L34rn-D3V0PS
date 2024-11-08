# Lab 8: Jenkins Auto Trigger Configuration

In this lab, you will configure a Jenkins Pipeline to automatically trigger builds based on changes to a Git repository. You’ll modify the Pipeline script to run without manually pulling the repository and configure Jenkins to poll the Git repository at regular intervals.

By the end of this lab, you will:
1. Set up a Jenkins Pipeline to build automatically on Git changes.
2. Use Jenkins Poll SCM to trigger the pipeline every 15 minutes.

---

## Table of Contents

1. **Introduction**
2. **Step-by-Step Instructions**
   - Preparing the Git Repository
   - Creating and Configuring the Jenkins Pipeline
   - Testing Auto Trigger with Git Changes
3. **Console Output Verification**
4. **Conclusion**

---

## Step-by-Step Instructions

### Step 1: Preparing the Git Repository

1. **Clone the Git repository** locally (forked from rafaelrpinto/VulnerableJavaWebApplication):

    ```bash
    git clone https://github.com/r00txtr/VulnerableJavaWebApplication.git VulnerableJavaWebApplication
    ```

2. **Navigate** into the cloned repository directory:

    ```bash
    cd VulnerableJavaWebApplication
    ```

3. **Create a Jenkinsfile** in the project root with the following script (same as Lab 7 but without the Git clone command):

    ```groovy
    pipeline {
        agent any  // Use any available agent for the pipeline
        stages {
            stage('Check Node') {
                steps {
                    script {
                        echo "Running on: ${env.NODE_NAME}"  // Outputs the name of the node
                    }
                }
            }
            stage('Maven Compile') {
                agent {
                    label 'Maven-Labels'  // Runs on an agent labeled 'Maven-Labels'
                }
                steps {
                    sh 'mvn compile'  // Compile the Maven project
                }
            }
            stage('Build Docker Image') {
                agent {
                    docker {
                        image 'docker:latest'  // Using Docker image
                        args '--privileged -u root -v /var/run/docker.sock:/var/run/docker.sock'
                    }
                }
                steps {
                    sh 'docker rmi java-vulnerable-application:0.1 || true'  // Remove existing image if present
                    sh 'docker build -t java-vulnerable-application:0.1 .'  // Build the Docker image
                }
            }
            stage('Run Docker Image') {
                agent {
                    docker {
                        image 'docker:latest'  // Using Docker image
                        args '--privileged -u root -v /var/run/docker.sock:/var/run/docker.sock'
                    }
                }
                steps {
                    // Clean up any existing container with the same name
                    sh 'docker rm -f vulnerable-java-application || true' 
                    sh 'docker run --name vulnerable-java-application -p 9000:9000 -d java-vulnerable-application:0.1'  // Run the Docker container
                }
            }
        }
    }
    ```

4. **Add the Jenkinsfile** to Git, commit, and push to the repository:

    ```bash
    git add Jenkinsfile
    git commit -m "add Jenkinsfile"
    git push
    ```

### Step 2: Configuring Jenkins for Auto Trigger

1. **In Jenkins**, go to the Dashboard and select **New Item**.
2. **Name the project** (e.g., `VulnerableJavaWebApp-AutoTrigger`) and choose **Pipeline**.
3. In the project configuration page:
   - Scroll to the **Pipeline** section, select **Pipeline script from SCM**.
   - Choose **Git** as the SCM and enter the repository URL (e.g., `https://github.com/r00txtr/VulnerableJavaWebApplication.git`).
   - Set **Credentials** if necessary.
4. **Enable Poll SCM** in the **Build Triggers** section and set the schedule to poll every 15 minutes:

    ```
    H/15 * * * *
    ```

### Step 3: Testing the Auto Trigger

1. **Create a new file** in the repository to simulate a change:

    ```bash
    touch newfile.txt
    git add newfile.txt
    git commit -m "add new file"
    git push
    ```

2. **Check Jenkins** to ensure the pipeline triggers automatically. You should see a new build initiated within a few minutes of the commit.

---

## Console Output Verification

In **Console Output**, expect logs that confirm each stage ran as defined in the Jenkinsfile, confirming successful execution and deployment of the updated pipeline.

---

## Conclusion

In **Lab 8**, you configured Jenkins to automatically trigger a pipeline based on Git repository changes. This setup is essential for automated CI/CD processes, as it ensures that new changes are built and tested without manual intervention, streamlining the deployment process.

Congratulations on completing **Lab 8: Jenkins Auto Trigger Configuration**!