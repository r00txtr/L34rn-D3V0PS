# Lab 10: Trufflehog for Secret Scanning, SpotBugs, and SonarQube Integration

In this lab, you will integrate Trufflehog for secret scanning, SpotBugs for static code analysis, and SonarQube for comprehensive code review within the Jenkins pipeline. These tools are vital for enhancing the security and quality of your CI/CD pipeline.

By the end of this lab, you will:
1. Set up Trufflehog for secret scanning.
2. Integrate SpotBugs for static code analysis.
3. Configure SonarQube for code quality analysis.
4. Update the Jenkinsfile to include these stages.

---

## Table of Contents

1. **Introduction**
2. **Step-by-Step Instructions**
   - Trufflehog Setup for Secret Scanning
   - SpotBugs Integration
   - SonarQube Configuration
   - Jenkinsfile Update
3. **Running the Jenkins Pipeline**
4. **Reviewing Analysis Reports**
5. **Conclusion**

---

## Step-by-Step Instructions

### Trufflehog Setup for Secret Scanning

1. **Run Trufflehog to scan a public Git repository**:

    ```bash
    docker run --rm -it -v "$PWD:/pwd" ghcr.io/trufflesecurity/trufflehog:latest git https://github.com/trufflesecurity/test_keys --only-verified --json
    ```

2. **Scan the `VulnerableJavaWebApplication` folder locally**:

    ```bash
    docker run --rm -it -v "${PWD}:/pwd" trufflesecurity/trufflehog:latest filesystem /pwd --json
    ```

### SpotBugs Integration

1. **Add the SpotBugs Maven plugin** in `pom.xml`:

    ```xml
    <plugin>
        <groupId>com.github.spotbugs</groupId>
        <artifactId>spotbugs-maven-plugin</artifactId>
        <version>4.8.6.4</version>
        <configuration>
            <includeFilterFile>spotbugs-security-include.xml</includeFilterFile>
            <excludeFilterFile>spotbugs-security-exclude.xml</excludeFilterFile>
            <xmlOutput>true</xmlOutput>
            <htmlOutput>true</htmlOutput>
            <plugins>
                <plugin>
                    <groupId>com.h3xstream.findsecbugs</groupId>
                    <artifactId>findsecbugs-plugin</artifactId>
                    <version>1.12.0</version>
                </plugin>
            </plugins>
        </configuration>
    </plugin>
    ```

2. **Create the following files**:

    - **`spotbugs-security-include.xml`**:

        ```xml
        <FindBugsFilter>
            <Match>
                <Bug category="SECURITY"/>
            </Match>
        </FindBugsFilter>
        ```

    - **`spotbugs-security-exclude.xml`**:

        ```xml
        <FindBugsFilter>
        </FindBugsFilter>
        ```

3. **Run SpotBugs locally**:

    ```bash
    docker run --rm -v "$PWD:/usr/src/app" -w /usr/src/app maven:3.9.9-ibm-semeru-23-jammy mvn clean compile spotbugs:spotbugs
    ```

### SonarQube Configuration

1. **Run SonarQube using Docker**:

    ```bash
    docker run -d --name sonarqube --network jenkins -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true -p 9000:9000 sonarqube:latest
    ```

    - **Default credentials**: `admin:admin`

2. **Create a new project in SonarQube**:
   - Project display name: `VulnerableJavaWebApplication`
   - Project key: `VulnerableJavaWebApplication`
   - Main branch name: `master`

3. **Analyze the project locally**:

    ```bash
    mvn sonar:sonar -Dsonar.host.url=http://localhost:9000 -Dsonar.login=<your-token> -Dsonar.projectKey=VulnerableJavaWebApplication -X
    ```

    OR

    ```bash
    docker run --rm --network jenkins -v "$PWD:/usr/src/app" -w /usr/src/app maven:3.9.9-ibm-semeru-23-jammy mvn sonar:sonar -Dsonar.host.url=http://172.21.0.3:9000 -Dsonar.login=<your-token> -Dsonar.projectKey=VulnerableJavaWebApplication
    ```

### Jenkinsfile Update

**Update the Jenkinsfile** to include the new stages:

```groovy
pipeline {
    agent any
    stages {
        stage('Check Node') {
            steps {
                script {
                    echo "Running on: ${env.NODE_NAME}"
                }
            }
        }
        stage('Maven Compile and SAST') {
            agent {
                docker {
                    image 'maven:3.9.9-eclipse-temurin-11'
                    args '--privileged -u root -v /var/run/docker.sock:/var/run/docker.sock --entrypoint='
                }
            }
            steps {
                sh 'mvn clean compile spotbugs:spotbugs'
                archiveArtifacts artifacts: 'target/site/spotbugs.html'
                archiveArtifacts artifacts: 'target/spotbugsXml.xml'
            }
        }
        stage('SCA') {
            agent {
                docker {
                    image 'owasp/dependency-check:latest'
                    args '--privileged -u root -v /var/run/docker.sock:/var/run/docker.sock -v my-docker-volume-dependency-check-data:/usr/share/dependency-check/data --entrypoint='
                }
            }
            steps {
                sh '/usr/share/dependency-check/bin/dependency-check.sh --scan . --project "VulnerableJavaWebApplication" --format HTML --format XML --format JSON'
                archiveArtifacts artifacts: 'dependency-check-report.html'
                archiveArtifacts artifacts: 'dependency-check-report.json'
                archiveArtifacts artifacts: 'dependency-check-report.xml'
            }
        }
        stage('Secret Scanning') {
            agent {
                docker {
                    image 'trufflesecurity/trufflehog:latest'
                    args '--privileged -u root -v /var/run/docker.sock:/var/run/docker.sock --entrypoint='
                }
            }
            steps {
                sh 'trufflehog --no-update filesystem . --json > trufflehogscan.json'
                archiveArtifacts artifacts: 'trufflehogscan.json'
            }
        }
        stage('Build Docker Image') {
            agent {
                docker {
                    image 'docker:latest'
                    args '--privileged -u root -v /var/run/docker.sock:/var/run/docker.sock'
                }
            }
            steps {
                sh 'docker rmi java-vulnerable-application:0.1 || true'
                sh 'docker build -t java-vulnerable-application:0.1 .'
            }
        }
        stage('Run Docker Image') {
            agent {
                docker {
                    image 'docker:latest'
                    args '--privileged -u root -v /var/run/docker.sock:/var/run/docker.sock'
                }
            }
            steps {
                sh 'docker rm -f vulnerable-java-application || true'
                sh 'docker run --name vulnerable-java-application -p 9000:9000 -d java-vulnerable-application:0.1'
            }
        }
    }
}
```

---

## Running the Jenkins Pipeline

Trigger the Jenkins job and review the console logs to confirm successful execution of the Trufflehog, SpotBugs, and SonarQube stages.

## Reviewing Analysis Reports

Review the archived artifacts in Jenkins and navigate to SonarQube to examine detailed reports on vulnerabilities, code smells, and other issues.

---

## Conclusion

In **Lab 10**, you successfully integrated Trufflehog, SpotBugs, and SonarQube into your Jenkins pipeline for enhanced security and code analysis. This setup bolsters your CI/CD pipeline, ensuring robust code quality and security checks.

Congratulations on completing **Lab 10: Trufflehog, SpotBugs, and SonarQube Integration**!
