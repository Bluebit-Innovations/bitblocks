# IAM Module

This Terraform module manages AWS Identity and Access Management (IAM) resources. It provides a standardized approach to creating and managing IAM roles, policies, and user accounts while following security best practices and the principle of least privilege.

The module supports creating common IAM configurations for various AWS services and use cases, with built-in security controls and compliance features.

# Core Features for Each IAM Module

## Each module has: 

- ✅ Minimal required inputs (avoid hardcoded values).  <br/>
- ✅ Outputs for key attributes (e.g., ARNs, Role Names). <br/>
- ✅ Support for multiple environments (dev, staging, prod). <br/>
- ✅ Tagging support (for tracking and billing). <br/>
- ✅ Fine-grained permissions (least privilege model). <br/>
- ✅ Logging & auditing integration (CloudTrail, IAM Access Analyzer). <br/>