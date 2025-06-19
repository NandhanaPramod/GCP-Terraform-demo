# Deploy GCP Landing Zone - One Click Script
# Run this script from the root of your STOXX repo

Write-Host "Starting GCP Landing Zone Deployment..." -ForegroundColor Cyan

# Define modules in deployment order
$modules = @("2-env", "3-networks", "4-projects", "5-app-infra", "6-sonarqube")

foreach ($module in $modules) {
    Write-Host "`n===============================" -ForegroundColor Yellow
    Write-Host "Deploying module: $module" -ForegroundColor Yellow
    Write-Host "===============================`n" -ForegroundColor Yellow
    
    # Change to module directory
    Set-Location $module
    
    try {
        # Initialize Terraform
        Write-Host "Initializing Terraform..." -ForegroundColor Green
        terraform init
        
        # Plan the deployment
        Write-Host "Planning deployment..." -ForegroundColor Green
        terraform plan
        
        # Apply the changes
        Write-Host "Applying changes..." -ForegroundColor Green
        terraform apply -auto-approve
        
        Write-Host "Module $module deployed successfully!" -ForegroundColor Green
    }
    catch {
        Write-Host "Error deploying $module : $($_.Exception.Message)" -ForegroundColor Red
        Set-Location ..
        exit 1
    }
    
    # Go back to root directory
    Set-Location ..
}

Write-Host "`nAll modules deployed successfully!" -ForegroundColor Green

# Show final outputs
Write-Host "`nCloud Run and App Outputs:" -ForegroundColor Cyan
Set-Location "5-app-infra"
terraform output
Set-Location ..

Write-Host "`nSonarQube Outputs:" -ForegroundColor Cyan
Set-Location "6-sonarqube"
terraform output
Set-Location ..

Write-Host "`nDeployment complete! Your GCP Landing Zone is ready." -ForegroundColor Green 