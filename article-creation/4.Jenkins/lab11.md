# Lab 11: Dynamic Application Security Testing (DAST) with ZAP Proxy and Arachni

In this lab, we’ll integrate Dynamic Application Security Testing (DAST) into the Jenkins pipeline using ZAP Proxy and Arachni. DAST tools are crucial for identifying security vulnerabilities in applications by examining them during runtime, simulating real-world attacks on the live application.

By the end of this lab, you will:
1. Set up ZAP Proxy for dynamic analysis.
2. Integrate Arachni for web application scanning.
3. Update the Jenkinsfile to include a DAST stage.

---

## Table of Contents

1. **Step-by-Step Instructions**
   - ZAP Proxy Setup
   - Arachni Setup
   - Jenkinsfile Update
2. **Running the Jenkins Pipeline**
3. **Reviewing Analysis Reports**
4. **Conclusion**

---

## Step-by-Step Instructions

### ZAP Proxy Setup

1. **Run ZAP Proxy for a baseline scan** (testing a URL):

    ```bash
    docker run --rm --network=host -i -v ${PWD}:/zap/wrk/:rw -t ghcr.io/zaproxy/zaproxy:stable zap-baseline.py -t https://localhost:9000 -r report-owasp-zap.html
    ```

2. **Run ZAP Proxy for a full scan**:

    ```bash
    docker run --rm --network=host -i -v ${PWD}:/zap/wrk/:rw -t ghcr.io/zaproxy/zaproxy:stable zap-full-scan.py -t https://localhost:9000 -r report-owasp-zap.html
    ```

### Arachni Setup

1. **Create a Dockerfile** for Arachni:

    ```dockerfile
    # Use Debian as the base image
    FROM debian:12

    # Define Arachni version arguments
    ARG VERSION=1.6.1.3
    ARG WEB_VERSION=0.6.1.1

    # Install essential dependencies
    RUN apt-get -qq update && apt-get upgrade -y && \
        apt-get -qq install -y --no-install-recommends wget ca-certificates libcurl4 libcurl4-openssl-dev libnghttp2-14 net-tools iputils-ping && \
        apt-get clean && rm -rf /var/lib/apt/lists/*

    # Install Chrome and dependencies for headless browsing
    RUN apt-get update && \
        apt-get install -y wget gnupg unzip libglib2.0-0 libnss3 libgconf-2-4 libfontconfig1 libx11-xcb1 && \
        wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
        echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list && \
        apt-get update && \
        apt-get install -y google-chrome-stable && \
        rm -rf /var/lib/apt/lists/*

    # Download and install Arachni
    RUN mkdir /arachni && \
        wget -qO- https://github.com/Arachni/arachni/releases/download/v${VERSION}/arachni-${VERSION}-linux-x86_64.tar.gz | tar xvz -C /arachni --strip-components=1

    # Create a user 'admin' and grant ownership of Arachni
    RUN useradd -m -s /bin/bash admin && \
        chown -R admin:admin /arachni

    # Set the working directory
    WORKDIR /arachni
    EXPOSE 9292
    ```

2. **Build the Docker image**:

    ```bash
    docker build -t docker-arachni .
    ```

3. **Run the Arachni container**:

    ```bash
    docker run -dit --name docker-arachni -p 9292:9292 docker-arachni /arachni/bin/arachni_web -o 0.0.0.0
    ```

4. **Access the Arachni Web Interface**:

   - URL: [http://localhost:9292](http://localhost:9292)
   - **Credentials**:
     - **Admin:** `admin@admin.admin` / `administrator`
     - **User:** `user@user.user` / `regular_user`

5. **Run a scan using Arachni** with the target URL:

    - Target: [http://testphp.vulnweb.com](http://testphp.vulnweb.com)

### Jenkinsfile Update

**Add the DAST Stage** to your Jenkinsfile in VulnerableJavaWebApplication Repository:

```groovy
pipeline {
    agent any
    stages {
        ...
        stage('DAST') {
            agent {
                docker {
                    image 'ghcr.io/zaproxy/zaproxy:stable'
                    args '--privileged -u root -v /var/run/docker.sock:/var/run/docker.sock --entrypoint= -v .:/zap/wrk/:rw'
                }
            }
            steps {
                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE'){
                    sh 'zap-full-scan.py -t https://172.18.0.3:9000 -r result-zap-full.html -x result-zap-full.xml'
                }

                sh 'cp /zap/wrk/result-zap-full.html ./result-zap-full.html'
                sh 'cp /zap/wrk/result-zap-full.xml ./result-zap-full.xml'
                archiveArtifacts artifacts: 'result-zap-full.html'
                archiveArtifacts artifacts: 'result-zap-full.xml'
            }
        }
    }
}
```

---

## Running the Jenkins Pipeline

Trigger the Jenkins job to execute the DAST stage. Review the Jenkins console logs for verification of successful scans by ZAP Proxy and Arachni.

## Reviewing Analysis Reports

Access the archived `result-zap-full.html` and `result-zap-full.xml` artifacts within Jenkins for a detailed breakdown of the DAST results.

---

## Conclusion

In **Lab 11**, you successfully integrated DAST with ZAP Proxy and Arachni in your Jenkins pipeline for dynamic application security testing. This setup provides real-time vulnerability assessments for your CI/CD pipeline, ensuring a robust defense against runtime threats.

Congratulations on completing **Lab 11: DAST Integration**!