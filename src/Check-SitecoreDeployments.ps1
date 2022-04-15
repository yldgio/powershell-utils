param(
    [parameter (Mandatory = $true) ]
    [string]$TdsPackagePath,
    [parameter (Mandatory = $true) ]
    [string]$DeploymentPath,
    [parameter (Mandatory = $true) ]
    [int]$TryEvery = 5,
    [parameter (Mandatory = $true) ]
    [int]$MaxAttempts = 20
)

. $PSScriptRoot\Get-Deployment.ps1
$attempts = 0
Do{
    $deployments = Get-Deployments -TdsPackagePath $TdsPackagePath -DeploymentPath $DeploymentPath
    Write-Output($deployments)
    $attempts +=1
    Write-Output "Attempt number $attempts"
    Start-Sleep $TryEvery
}while ($deployments.Status -ieq "Pending" -and $attempts -lt $MaxAttempts)

if($deployments.Status -ne "Success"){
    Write-Warning "no successful deployment found: deployment in $($deployments.Status) with message $($deployments.Message). Failed in $attempts attempts."
    throw "$($deployments.Message)"
}