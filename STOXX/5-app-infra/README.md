# Application Infrastructure Module

This module sets up the application infrastructure including Cloud Run, Cloud SQL, and Cloud Storage.

## Features

- **Cloud Run Service**: Deploy your containerized application
- **Cloud SQL Database**: MySQL database for your application
- **Cloud Storage Bucket**: File storage for your application
- **Service Account**: Dedicated service account with appropriate permissions
- **IAM Policies**: Proper access controls and permissions

## Usage

1. Copy `terraform.tfvars.example` to `terraform.tfvars`
2. Update the values in `terraform.tfvars`:
   - Set your `project_id`
   - Set your `region`
   - Update `container_image` to point to your container image
   - Adjust `cpu_limit` and `memory_limit` as needed
   - Set `allow_unauthenticated` based on your security requirements

3. Deploy the infrastructure:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Container Image Requirements

Your container image should:
- Listen on the port specified in `container_port` (default: 8080)
- Handle HTTP requests
- Be available in Google Container Registry or Artifact Registry

## Environment Variables

The Cloud Run service will have these environment variables available:
- `DATABASE_URL`: Cloud SQL connection name
- `STORAGE_BUCKET`: Cloud Storage bucket name

## Security

- The service account has minimal required permissions
- Database has deletion protection disabled for development
- Public access is disabled by default (set `allow_unauthenticated = true` to enable)

## Outputs

- `cloud_run_service_url`: The URL where your application is accessible
- `cloud_run_service_name`: The name of the Cloud Run service
- `app_service_account_email`: Service account email
- `app_bucket_name`: Storage bucket name
- `database_connection_name`: Database connection name 