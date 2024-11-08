# Lab 9: OWASP Dependency Check Integration with Jenkins Pipeline

In this lab, you’ll integrate **OWASP Dependency Check** into your Jenkins Pipeline to perform software composition analysis (SCA) for identifying vulnerabilities in project dependencies. This is an essential step for securing your application against known vulnerabilities.

---

## Objectives

By the end of this lab, you will:

1. Download and configure OWASP Dependency Check.
2. Modify your Jenkins Pipeline to run OWASP Dependency Check.
3. Automatically archive the generated dependency reports for further review.

---

## Step-by-Step Instructions

### Step 1: Download OWASP Dependency Check

1. **Download OWASP Dependency Check** from the official site: [OWASP Dependency Check](https://owasp.org/www-project-dependency-check/).
2. **Extract** the downloaded file (e.g., `dependency-check-10.0.2-release.zip`).
3. Note the path where the tool is extracted. You’ll need this path for running dependency check commands.

### Step 2: Run Dependency Check Command Line Test (Optional)

1. Open your terminal and execute the following command to run a test on your local project:

   ```bash
   C:\Users\Downloads\Compressed\dependency-check-10.0.2-release\dependency-check\bin\dependency-check.bat --project VulnerableJavaWebApplication --scan "C:\Users\VulnerableJavaWebApplication" --format ALL
   ```

   This scans the project and generates reports in various formats (e.g., HTML, JSON, XML). This step is optional but useful to verify the tool locally.

### Step 3: Update the Jenkinsfile

1. **In the project root**, edit your `Jenkinsfile` as follows. This script is similar to the previous labs but includes a new **Software Composition Analysis (SCA)** stage using OWASP Dependency Check.

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
            stage('Software composition analysis (SCA)') {
                agent {
                    docker {
                        image 'owasp/dependency-check:latest'  
                        args '--privileged -u root -v /var/run/docker.sock:/var/run/docker.sock -v my-docker-volume-dependency-check-data:/usr/share/dependency-check/data --entrypoint='
                    }
                }
                steps {
                    sh '/usr/share/dependency-check/bin/dependency-check.sh --scan . --project "VulnerableJavaWebApplication" --format ALL'
                    archiveArtifacts artifacts: 'dependency-check-report.html'
                    archiveArtifacts artifacts: 'dependency-check-report.json'
                    archiveArtifacts artifacts: 'dependency-check-report.xml'
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

### Step 4: Commit and Push Changes

1. **Add** the updated `Jenkinsfile` to Git, commit, and push the changes to your repository:

    ```bash
    git add .
    git commit -m "owasp dependency check integration with jenkins"
    git push
    ```

---

## Conclusion

By completing **Lab 9**, you’ve added OWASP Dependency Check to your CI/CD pipeline in Jenkins, enhancing your project’s security. Now, each build will include a dependency vulnerability check, with reports automatically archived for easy access and review.

Congratulations on integrating software composition analysis into your Jenkins pipeline!
