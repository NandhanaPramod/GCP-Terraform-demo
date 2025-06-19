# GCP Landing Zone with Terraform

This repository contains Terraform modules and configurations for setting up a secure, scalable, and compliant Google Cloud Platform (GCP) landing zone.

## Directory Structure

```
/0-bootstrap/         # Org-level bootstrap (IAM, billing, groups)
/1-org/              # Org/folder structure
/2-env/              # Environment setup (dev, prod, etc.)
/3-networks/         # Shared VPCs, subnets, firewalls
/4-projects/         # Project creation and configuration
/5-app-infra/        # App-specific infra (GKE, databases, etc.)
/modules/            # Custom/shared Terraform modules
.github/workflows/   # CI/CD for Terraform
```

## Prerequisites

- Terraform >= 1.0.0
- Google Cloud SDK
- Appropriate GCP permissions
- Service account with necessary roles

## Setup Instructions

1. Initialize Terraform:
   ```bash
   terraform init
   ```

2. Configure your variables in `terraform.tfvars`

3. Apply the configuration:
   ```bash
   terraform plan
   terraform apply
   ```

## Module Dependencies

This landing zone uses the following key modules:
- Google Cloud Foundation Fabric (Fabric FAST)
- Custom modules for specific requirements

## Security Considerations

- All infrastructure is deployed with security best practices
- IAM roles follow the principle of least privilege
- Network security is implemented with proper segmentation
- Audit logging is enabled for all resources

## Contributing

1. Fork the repository
2. Create a feature branch
3. Submit a pull request

## License

MIT License 