# Cloud Readiness Checklist

- **Cloud Provider Setup**  
    - [ ] Cloud provider account (AWS / Azure / GCP) is fully set up.  
    - [ ] Billing alerts, budgets, and usage monitoring configured.  
    - [ ] Cloud cost estimation performed using tools like Terraform cost module or native cloud tools.  

- **Infrastructure Planning**  
    - [ ] Secure storage for remote Terraform state (e.g., S3 with DynamoDB for locking).  
    - [ ] Network architecture defined (VPC/Subnets/IP CIDRs planned).  
    - [ ] Required regions and availability zones documented.  

- **Security and Compliance**  
    - [ ] Security baselines enforced (IAM policies, MFA, key rotation).  
    - [ ] SSH key pairs, service principals, and credentials are securely stored.  
    - [ ] Default encryption enabled for all storage and databases.  
    - [ ] Compliance checks mapped (e.g., CIS Benchmark, SOC2, ISO 27001).  

- **Resource Management**  
    - [ ] DNS zones or domain names registered and integrated.  
    - [ ] Resource tagging strategy documented for cost tracking and access management.  

- **Monitoring and Logging**  
    - [ ] Logging and audit trails enabled (e.g., CloudTrail, Azure Activity Log).  

- **Testing and Validation**  
    - [ ] Initial cloud infrastructure deployment tested in a sandbox environment.  

**Note:** Ensure all configurations are production-ready.  