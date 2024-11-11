# AWS Certified Solutions Architect - Associate exam

### 1. **What is Amazon EC2 and how is it used?**

**Answer**: Amazon EC2 (Elastic Compute Cloud) provides scalable virtual servers in the cloud. It is used to run applications on a virtual server, offering different instance types optimized for various workloads.

### 2. **What are EC2 instance types, and why are they important?**

**Answer**: EC2 instance types define the compute, memory, and storage capacity of an instance. They are categorized into general-purpose, compute-optimized, memory-optimized, storage-optimized, and GPU instances, enabling users to choose based on their specific workload needs.

### 3. **What is the purpose of Auto Scaling in AWS?**

**Answer**: Auto Scaling helps maintain application availability and allows you to scale your EC2 capacity up or down automatically according to defined conditions, ensuring cost-effectiveness and performance optimization.

### 4. **What is Amazon S3 and how does it ensure data durability?**

**Answer**: Amazon S3 (Simple Storage Service) is an object storage service that ensures data durability by automatically replicating data across multiple devices and Availability Zones. It offers a durability of 99.999999999% (11 nines).

### 5. **What are S3 storage classes, and why are they important?**

**Answer**: S3 storage classes (e.g., S3 Standard, S3 Intelligent-Tiering, S3 Glacier) offer different levels of availability, durability, and cost, allowing users to optimize their storage based on data access frequency.

### 6. **What is Amazon RDS and what are its key benefits?**

**Answer**: Amazon Relational Database Service (RDS) is a managed service for setting up, operating, and scaling a relational database in the cloud. It reduces administrative tasks like backups, patching, and scaling while ensuring high availability.

### 7. **What is the purpose of Multi-AZ deployments in RDS?**

**Answer**: Multi-AZ deployments provide high availability and failover support for RDS instances by replicating data synchronously to a standby instance in a different Availability Zone.

### 8. **What is Amazon CloudFront and how does it work?**

**Answer**: Amazon CloudFront is a content delivery network (CDN) service that distributes content globally with low latency by caching it at edge locations, improving load times for users.

### 9. **What is an AWS VPC?**

**Answer**: An Amazon Virtual Private Cloud (VPC) is a private network in AWS that allows you to launch resources in a logically isolated environment. You can configure subnets, route tables, and security to control the traffic within the VPC.

### 10. **What are subnets in a VPC?**

**Answer**: Subnets are segments within a VPC that divide the IP address range, allowing resources to be placed in either public (accessible from the internet) or private (internal use only) subnets.

### 11. **What is an Internet Gateway (IGW) and its function?**

**Answer**: An Internet Gateway is a component that allows communication between instances in a VPC and the internet, enabling public access to the resources in the VPC.

### 12. **What is the difference between a Security Group and a Network ACL?**

**Answer**: A Security Group acts as a virtual firewall for controlling inbound and outbound traffic at the instance level, while a Network ACL (Access Control List) controls traffic at the subnet level and can be configured with allow and deny rules.

### 13. **What is Amazon Route 53?**

**Answer**: Amazon Route 53 is a scalable and highly available Domain Name System (DNS) and domain name registration service that routes users to applications by translating domain names to IP addresses.

### 14. **What is Elastic Load Balancing (ELB)?**

**Answer**: ELB distributes incoming traffic across multiple targets (e.g., EC2 instances) to improve the availability and fault tolerance of applications.

### 15. **What are the types of load balancers available in AWS?**

**Answer**: The main types are:

- **Application Load Balancer (ALB)**: For HTTP/HTTPS traffic with advanced routing.
- **Network Load Balancer (NLB)**: For high performance and low latency.
- **Classic Load Balancer (CLB)**: Legacy option for basic load balancing.

### 16. **What is Amazon S3 bucket policy?**

**Answer**: A bucket policy is a JSON document that specifies the permissions for actions on an S3 bucket, allowing or denying access to the bucket's content based on conditions.

### 17. **What is AWS IAM?**

**Answer**: AWS Identity and Access Management (IAM) is a service that provides fine-grained control over access to AWS resources by managing users, groups, roles, and their associated permissions.

### 18. **What are IAM roles and how are they used?**

**Answer**: IAM roles are a way to grant permissions to entities that you trust (e.g., EC2 instances) without using long-term credentials. Roles have policies attached that specify the allowed actions.

### 19. **What is Amazon CloudWatch?**

**Answer**: Amazon CloudWatch is a monitoring service for AWS cloud resources and applications, providing real-time monitoring of metrics, collection of log data, and setting alarms for automated actions.

### 20. **What is the difference between CloudWatch and CloudTrail?**

**Answer**: **CloudWatch** monitors resource performance and application metrics, while **CloudTrail** logs API calls and events in your AWS account for auditing and compliance purposes.

### 21. **What is Amazon EBS?**

**Answer**: Amazon Elastic Block Store (EBS) is a block-level storage service designed for use with EC2 instances, providing persistent data storage independent of the instance lifecycle.

### 22. **What are EBS volume types?**

**Answer**: Common EBS volume types include:

- **General Purpose SSD (gp3, gp2)**: Balanced price and performance.
- **Provisioned IOPS SSD (io1, io2)**: High-performance for intensive workloads.
- **Throughput Optimized HDD (st1)**: High throughput for large, sequential workloads.
- **Cold HDD (sc1)**: Low-cost storage for infrequent access.

### 23. **What is AWS Elastic Beanstalk?**

**Answer**: Elastic Beanstalk is a platform-as-a-service (PaaS) that allows you to deploy and manage applications without worrying about the infrastructure. It automates deployment, scaling, monitoring, and maintenance.

### 24. **What is AWS CloudFormation?**

**Answer**: AWS CloudFormation allows you to define and deploy AWS infrastructure as code using templates, enabling you to provision and manage resources programmatically.

### 25. **What is AWS Lambda?**

**Answer**: AWS Lambda is a serverless compute service that lets you run code without managing servers. You pay only for the compute time consumed, making it cost-effective for event-driven applications.

### 26. **What is Amazon S3 Transfer Acceleration?**

**Answer**: S3 Transfer Acceleration speeds up data transfer to S3 by leveraging AWS CloudFront’s globally distributed edge locations.

### 27. **What is AWS Storage Gateway?**

**Answer**: AWS Storage Gateway is a hybrid cloud storage service that provides on-premises access to virtually unlimited cloud storage.

### 28. **What is AWS Direct Connect?**

**Answer**: AWS Direct Connect establishes a dedicated network connection from your on-premises data center to AWS, offering a more consistent network experience compared to the internet.

### 29. **What is AWS Snowball?**

**Answer**: AWS Snowball is a data transport solution for large-scale data transfer into and out of AWS. It is a physical device that can move large volumes of data securely.

### 30. **What is Amazon RDS Read Replica?**

**Answer**: Read replicas in Amazon RDS allow you to create read-only copies of your database for load balancing, offloading read traffic, and disaster recovery.

### 31. **What is Amazon Aurora?**

**Answer**: Amazon Aurora is a high-performance, fully managed relational database that is compatible with MySQL and PostgreSQL and offers improved scalability and reliability.

### 32. **What is AWS Multi-Factor Authentication (MFA)?**

**Answer**: MFA adds an extra layer of security by requiring users to present multiple forms of identification: their credentials (username and password) and an MFA token (e.g., an OTP).

### 33. **What is Amazon Route 53 health check?**

**Answer**: Health checks in Route 53 monitor the availability and health of resources and route traffic based on their status to ensure high availability.

### 34. **What is the principle of least privilege?**

**Answer**: It is a security principle that states users and services should have only the permissions necessary to complete their tasks, minimizing potential security risks.

### 35. **What is AWS CloudFront signed URL?**

**Answer**: Signed URLs allow you to restrict access to content served by CloudFront to authenticated users by requiring a signature that proves the user has permission to access the content.

### 36. **What is the AWS Well-Architected Tool?**

**Answer**: The AWS Well-Architected Tool helps users review the state of their workloads and compares them to AWS best practices in the areas of reliability, security, performance efficiency, cost optimization, and operational excellence.

### 37. **What are

 EC2 Spot Instances?**
**Answer**: EC2 Spot Instances allow you to bid for unused EC2 capacity at a discounted price, making them ideal for flexible and non-critical workloads.

### 38. **What is an EC2 Dedicated Host?**

**Answer**: A Dedicated Host is a physical server dedicated for your use, providing full control over instance placement and supporting software licensing that requires a physical server.

### 39. **What is Elastic File System (EFS)?**

**Answer**: Amazon EFS is a scalable, managed file storage service for use with AWS cloud services and on-premises resources, allowing multiple EC2 instances to access the same file system concurrently.

### 40. **What is the difference between S3 and EFS?**

**Answer**: S3 is object storage suitable for unstructured data like media and backups, while EFS is a file storage service suitable for use cases where applications require a traditional file system.

### 41. **What is AWS KMS?**

**Answer**: AWS Key Management Service (KMS) is a managed service that enables you to create and control encryption keys used to secure your data across AWS services and applications.

### 42. **What is AWS Systems Manager Parameter Store?**

**Answer**: Parameter Store is a secure storage solution for configuration data management and secrets management (e.g., passwords, database strings) within AWS Systems Manager.

### 43. **What is Amazon MQ?**

**Answer**: Amazon MQ is a managed message broker service that helps set up and operate message brokers, simplifying the setup and scaling of messaging infrastructure.

### 44. **What is Amazon QuickSight?**

**Answer**: Amazon QuickSight is a business intelligence service that enables users to create and publish interactive dashboards for data visualization and analysis.

### 45. **What is AWS Organizations?**

**Answer**: AWS Organizations helps you centrally manage and govern multiple AWS accounts, applying policies to control costs and security across your organization.

### 46. **What is the purpose of AWS Trusted Advisor?**

**Answer**: Trusted Advisor checks your AWS account against best practices in security, fault tolerance, cost optimization, performance, and service limits to help you optimize your cloud environment.

### 47. **What is the AWS Service Catalog?**

**Answer**: AWS Service Catalog allows organizations to manage and distribute approved AWS resources and services to maintain governance and compliance.

### 48. **What is AWS CodeCommit?**

**Answer**: AWS CodeCommit is a fully managed source control service that hosts Git repositories, making it easy to store and version control your code securely.

### 49. **What is AWS CodeBuild?**

**Answer**: AWS CodeBuild is a fully managed build service that compiles your source code, runs tests, and produces software packages ready for deployment.

### 50. **What is AWS CodeDeploy?**

**Answer**: AWS CodeDeploy automates code deployments to any instance, including EC2 instances and on-premises servers, ensuring consistent application updates.

### 51. **What is AWS CodePipeline?**

**Answer**: AWS CodePipeline is a CI/CD service that automates the build, test, and deployment phases of your release process to enable fast and reliable updates.

### 52. **What is Amazon EMR?**

**Answer**: Amazon EMR (Elastic MapReduce) is a cloud big data platform for processing large datasets using tools like Apache Hadoop, Spark, and HBase.

### 53. **What is Amazon Glue?**

**Answer**: AWS Glue is a managed ETL service that makes it easy to prepare and transform data for analytics and machine learning.

### 54. **What is AWS X-Ray?**

**Answer**: AWS X-Ray helps developers analyze and debug distributed applications by tracing requests as they travel through the system.

### 55. **What is AWS OpsWorks?**

**Answer**: AWS OpsWorks is a configuration management service that provides managed instances of Chef and Puppet for automating server configuration, deployment, and management.

### 56. **What is AWS Step Functions?**

**Answer**: AWS Step Functions orchestrates multiple AWS services into serverless workflows to automate business-critical processes.

### 57. **What is Amazon Kinesis Data Streams?**

**Answer**: Kinesis Data Streams is a real-time data streaming service that allows you to collect, process, and analyze streaming data in real time.

### 58. **What is Amazon Redshift Spectrum?**

**Answer**: Redshift Spectrum allows you to run queries against exabytes of data in S3 without having to load the data into Amazon Redshift.

### 59. **What is AWS Global Accelerator?**

**Answer**: AWS Global Accelerator improves the availability and performance of your applications by routing traffic through the global AWS network to the optimal endpoint.

### 60. **What is AWS Transit Gateway?**

**Answer**: AWS Transit Gateway connects VPCs and on-premises networks through a single gateway, simplifying network architecture and management.

### 61. **What is Amazon Polly?**

**Answer**: Amazon Polly is a service that turns text into lifelike speech, allowing you to create applications that talk.

### 62. **What is Amazon Lex?**

**Answer**: Amazon Lex is a service for building conversational interfaces into applications using voice and text, the same technology behind Amazon Alexa.

### 63. **What is the AWS Pricing Calculator?**

**Answer**: The AWS Pricing Calculator is a tool that helps you estimate the costs of your AWS services based on your usage plans.

### 64. **What are AWS Savings Plans?**

**Answer**: Savings Plans offer a flexible pricing model that provides significant savings compared to On-Demand pricing by committing to a consistent amount of usage for a term.

### 65. **What is the AWS Personal Health Dashboard?**

**Answer**: The AWS Personal Health Dashboard provides alerts and remediation guidance when AWS is experiencing events that may affect your resources.

---

These questions cover essential topics for the **AWS Certified Solutions Architect - Associate** exam, focusing on services, best practices, and architecture patterns that are commonly included in the certification.
