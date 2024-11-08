# Lab 12: Vulnerability Management with DefectDojo

In this lab, you’ll explore DefectDojo, a DevSecOps and vulnerability management tool that supports end-to-end security testing, vulnerability tracking, deduplication, and reporting. DefectDojo provides an efficient way to manage vulnerabilities across applications, integrating smoothly into CI/CD pipelines for continuous security assessments.

By the end of this lab, you will:
1. Set up DefectDojo in a local environment.
2. Configure a product for vulnerability assessment.
3. Import DAST results from Lab 11 for centralized vulnerability tracking.

---

## Table of Contents

1. **Introduction**
2. **Minimum System Requirements**
3. **Step-by-Step Instructions**
   - Building and Running DefectDojo
   - Web Demo Option
   - Configuring a Product
   - Importing Scan Results
4. **Conclusion**

---

## Introduction

DefectDojo is a powerful tool for **DevSecOps** and **Application Security Posture Management (ASPM)**. It enables comprehensive vulnerability management through:
- **Orchestrated security testing**
- **Vulnerability tracking and deduplication**
- **Automated remediation workflows**
- **Robust reporting capabilities**

With DefectDojo, you can streamline vulnerability management for applications, improving security posture and integrating well into continuous development environments.

---

## Minimum System Requirements

For optimal performance, DefectDojo requires the following resources:
- **2 vCPUs**
- **8 GB of RAM**
- **10 GB of disk space** (separate from the database storage, though using a different disk than your OS may improve performance)

---

## Step-by-Step Instructions

### Building and Running DefectDojo

1. **Clone the Project**:

    ```bash
    git clone https://github.com/DefectDojo/django-DefectDojo
    cd django-DefectDojo
    ```

2. **Build Docker Images**:

    ```bash
    ./dc-build.sh
    ```

3. **Run the Application**:

    ```bash
    ./dc-up-d.sh postgres-redis
    ```

    *Note: Other profiles are available; see [DefectDojo Docker Documentation](https://github.com/DefectDojo/django-DefectDojo/blob/dev/readme-docs/DOCKER.md) for more options.*

4. **Obtain Admin Credentials**:

    The initializer can take up to 3 minutes to run. You can track the progress with:

    ```bash
    docker compose logs -f initializer
    ```

    Once initialized, retrieve the admin password:

    ```bash
    docker compose logs initializer | grep "Admin password:"
    ```

### Web Demo Option

Alternatively, you can try DefectDojo’s **web demo** for uploading scan reports manually. The demo resets regularly, so avoid using sensitive data.

- **URL**: [demo.defectdojo.org](https://demo.defectdojo.org)
- **Login**: `admin` / `1Defectdojo@demo#appsec`

### Configuring a Product

1. **Add a Product**:
   - In DefectDojo, navigate to the "Add Product" section.
   - **Name**: `VulnerableJavaWebApplication`
   - **Product Type**: `Research and Development`
   - Submit the new product.

2. **Add an Engagement**:
   - Go to the created product (URL: [https://demo.defectdojo.org/product/7](https://demo.defectdojo.org/product/7) if using the demo).
   - Select **New Engagement**.
   - **Name**: `VulnerableJavaWebApplication-Assessment`
   - Submit to add the engagement.

### Importing Scan Results

1. Navigate to the **Finding** section within the VulnerableJavaWebApplication product.
2. Select **Import Scan Result**.
3. **Scan Type**: `ZAP Scan`
4. **File**: Upload `result-zap-full.xml` from Lab 11.
5. Complete the import process to analyze findings.

---

## Conclusion

In **Lab 12**, you successfully set up DefectDojo for vulnerability management and imported dynamic scan results for VulnerableJavaWebApplication. This lab enhances your application security workflow, centralizing vulnerability tracking and reporting.

Congratulations on completing **Lab 12: DefectDojo Vulnerability Management**!