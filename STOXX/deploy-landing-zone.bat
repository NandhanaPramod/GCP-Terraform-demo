@echo off
echo Starting GCP Landing Zone Deployment...

echo.
echo ===============================
echo Deploying module: 2-env
echo ===============================
cd 2-env
terraform init
terraform plan
terraform apply -auto-approve
if %errorlevel% neq 0 (
    echo Error deploying 2-env
    exit /b 1
)
cd ..

echo.
echo ===============================
echo Deploying module: 3-networks
echo ===============================
cd 3-networks
terraform init
terraform plan
terraform apply -auto-approve
if %errorlevel% neq 0 (
    echo Error deploying 3-networks
    exit /b 1
)
cd ..

echo.
echo ===============================
echo Deploying module: 4-projects
echo ===============================
cd 4-projects
terraform init
terraform plan
terraform apply -auto-approve
if %errorlevel% neq 0 (
    echo Error deploying 4-projects
    exit /b 1
)
cd ..

echo.
echo ===============================
echo Deploying module: 5-app-infra
echo ===============================
cd 5-app-infra
terraform init
terraform plan
terraform apply -auto-approve
if %errorlevel% neq 0 (
    echo Error deploying 5-app-infra
    exit /b 1
)
cd ..

echo.
echo All modules deployed successfully!
echo.
echo Cloud Run and App Outputs:
cd 5-app-infra
terraform output
cd ..

echo.
echo Deployment complete! Your GCP Landing Zone is ready.
pause 