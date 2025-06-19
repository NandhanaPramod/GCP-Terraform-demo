# SonarQube Module

This module deploys SonarQube as a Cloud Run service for code quality analysis.

## Features

- **Code Quality Analysis** - Automated code review
- **Security Scanning** - Vulnerability detection
- **Code Coverage** - Test coverage analysis
- **Quality Gates** - Automated pass/fail conditions
- **Interactive Dashboard** - Real-time metrics

## Usage

1. **Deploy the module:**
   ```bash
   terraform init
   terraform plan
   terraform apply -auto-approve
   ```

2. **Access SonarQube:**
   - URL: Check the `sonarqube_service_url` output
   - Default login: `admin/admin`
   - Change password on first login

3. **Set up Quality Gates:**
   - Code Coverage > 80%
   - No Critical Bugs
   - No Security Vulnerabilities
   - Code Duplication < 3%

## Demo Workflow

1. **Create a project** in SonarQube
2. **Upload your code** (Python website)
3. **Run analysis** - SonarQube scans automatically
4. **Review results** - See quality metrics
5. **Set quality gates** - Configure pass/fail conditions

## Resources Created

- Cloud Run service: `stoxx-sonarqube`
- Service account with appropriate permissions
- Public access enabled for demo purposes  service_account_key: ${{ secrets.GCP_SA_KEY }}