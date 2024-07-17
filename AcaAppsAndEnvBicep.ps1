# Define variables
$RESOURCE_GROUP = "rg-aca-app-bicep"
$LOCATION = "westeurope"
$DEPLOYMENT_NAME = "aca-demo-bicep"
$TEMPLATE_FILE = "mainenv.bicep"
$PARAMETERS_FILE = "azuredeployenv.parameters.json"
$ENV_FILE = "azuredeployenv.json"

# Function to create a resource group
function Create-ResourceGroup {
    param (
        [string]$ResourceGroupName,
        [string]$Location
    )
    Write-Host "Creating resource group: $ResourceGroupName in $Location"
    az group create --name $ResourceGroupName --location $Location
    if ($?) {
        Write-Host "Resource group created successfully."
    } else {
        Write-Error "Failed to create resource group."
        exit 1
    }
}

# Function to preview the deployment changes
function Preview-Deployment {
    param (
        [string]$DeploymentName,
        [string]$ResourceGroupName,
        [string]$TemplateFile,
        [string]$ParametersFile
    )
    Write-Host "Previewing deployment changes for: $DeploymentName"
    az deployment group what-if --name $DeploymentName --resource-group $ResourceGroupName --template-file $TemplateFile --parameters @$ParametersFile
    if ($?) {
        Write-Host "Preview completed successfully."
    } else {
        Write-Error "Failed to preview deployment."
        exit 1
    }
}

# Function to apply the deployment
function Apply-Deployment {
    param (
        [string]$DeploymentName,
        [string]$ResourceGroupName,
        [string]$TemplateFile,
        [string]$ParametersFile
    )
    Write-Host "Applying deployment: $DeploymentName"
    az deployment group create --name $DeploymentName --resource-group $ResourceGroupName --template-file $TemplateFile --parameters @$ParametersFile
    if ($?) {
        Write-Host "Deployment applied successfully."
    } else {
        Write-Error "Failed to apply deployment."
        exit 1
    }
}

# Function to delete the deployment
function Delete-Deployment {
    param (
        [string]$DeploymentName,
        [string]$ResourceGroupName
    )
    Write-Host "Deleting deployment: $DeploymentName"
    az deployment group delete --name $DeploymentName --resource-group $ResourceGroupName
    if ($?) {
        Write-Host "Deployment deleted successfully."
    } else {
        Write-Error "Failed to delete deployment."
        exit 1
    }
}

# Main script execution
try {
    Create-ResourceGroup -ResourceGroupName $RESOURCE_GROUP -Location $LOCATION
    Preview-Deployment -DeploymentName $DEPLOYMENT_NAME -ResourceGroupName $RESOURCE_GROUP -TemplateFile $TEMPLATE_FILE -ParametersFile $PARAMETERS_FILE
    Apply-Deployment -DeploymentName $DEPLOYMENT_NAME -ResourceGroupName $RESOURCE_GROUP -TemplateFile $TEMPLATE_FILE -ParametersFile $PARAMETERS_FILE
} catch {
    Write-Error "An error occurred: $_"
    exit 1
}

# Uncomment the following line to delete the deployment
# Delete-Deployment -DeploymentName $DEPLOYMENT_NAME -ResourceGroupName $RESOURCE_GROUP
