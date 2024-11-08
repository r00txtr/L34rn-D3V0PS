# Lab 13: Upload Scan Report dengan API & DefectDojo Integration with Pipeline

### 1. Upload Scan Report dengan API

- Visit [API Documentation](https://demo.defectdojo.org/api/v2/oa3/swagger-ui/) for more details.
- Check your API key at [API Key](https://demo.defectdojo.org/api/key-v2).
  
Your current API key is:

```
d790edd5ce89395b4464647950c61d368d150b43
```
  
Your current API Authorization Header value:

```
Token d790edd5ce89395b4464647950c61d368d150b43
```

- Check your engagement is `17` ([Engagement Link](https://demo.defectdojo.org/engagement/17)).

#### Example command

```bash
curl -X POST https://demo.defectdojo.org/api/v2/import-scan/ \
-H "Authorization: Token d790edd5ce89395b4464647950c61d368d150b43" \
-F "scan_type=ZAP Scan" \
-F "file=@C:\Users\LENOVO\Downloads\result-zap-full.xml" \
-F "engagement=17"
```

On success, there will be two uploads (building upon Lab 12).

---

### 2. DefectDojo Integration with Pipeline

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
    post {
        always {
            node ('Built-In')
            sh 'curl -X POST https://demo.defectdojo.org/api/v2/import-scan/ -H "Authorization: Token d790edd5ce89395b4464647950c61d368d150b43" -F "scan_type=Trufflehog Scan" -F "file=@./trufflehogscan.json;type=application/json" -F "engagement=17"'
            sh 'curl -X POST https://demo.defectdojo.org/api/v2/import-scan/ -H "Authorization: Token d790edd5ce89395b4464647950c61d368d150b43" -F "scan_type=Dependency Check Scan" -F "file=@./dependency-check-report.xml;type=text/xml" -F "engagement=17"'
            sh 'curl -X POST https://demo.defectdojo.org/api/v2/import-scan/ -H "Authorization: Token d790edd5ce89395b4464647950c61d368d150b43" -F "scan_type=Spotbugs Scan" -F "file=@./spotbugsXml.xml;type=text/xml" -F "engagement=17"'
            sh 'curl -X POST https://demo.defectdojo.org/api/v2/import-scan/ -H "Authorization: Token d790edd5ce89395b4464647950c61d368d150b43" -F "scan_type=ZAP Scan" -F "file=@./result-zap-full.xml;type=text/xml" -F "engagement=17"'
        }
    }
}
```

## Conclusion

In **Lab 13**, you leveraged DefectDojo's API capabilities to automate vulnerability management by uploading scan reports directly into DefectDojo, streamlining the integration with your CI/CD pipeline. Through the use of automated scripts, you managed to efficiently import results from multiple security scans—ranging from SAST, DAST, and dependency checks—directly into a centralized vulnerability management system. This approach further strengthens your application’s security posture and enables continuous security assessment across the development lifecycle.

Congratulations on completing **Lab 13: DefectDojo API Integration and CI/CD Pipeline Automation**!
