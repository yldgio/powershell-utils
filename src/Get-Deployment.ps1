function Get-Deployments(){
    [CmdletBinding()]
    param
    (
        [parameter (Mandatory = $true) ]
        [string]$DeploymentPath,
        [parameter (Mandatory = $true) ]
        [string]$TdsPackagePath
    )
    $result = @{Status= "Pending";Message=""; Count = 0; Deployments =@()}
    Write-Verbose "verify if $DeploymentPath exists"
    if(!(Test-Path $DeploymentPath)){
        Write-Warning "$DeploymentPath doesn't exist!"
        $result.Status = "Error"
        $result.Message="$DeploymentPath doesn't exist!"
        return $result
    }
    $TdsPackageFile = Get-TdsPackage($TdsPackagePath)
    if(! $TdsPackageFile){
        Write-Warning "$TdsPackagePath doesn't exist!"
        $result.Status = "Error"
        $result.Message="$TdsPackagePath doesn't exist!"
        return $result
    }
    
    $files = Get-ChildItem $DeploymentPath -Filter "$($TdsPackageFile.BaseName).json"
    if($files.Count -eq 0){
        Write-Warning "no files found in $DeploymentPath with pattern $($Layer)_$($Date)"
        return $result
    }
    foreach ($item in $files) {
        $result.Count += 1
        $deployment = Get-Content -Raw -Path $item.FullName | ConvertFrom-Json
        $res = [pscustomobject]@{File = $item.FullName; Status=$deployment.Status}
        $result.Deployments += $res        
    }
    $latest = $result.Deployments | Sort-Object -Property File -Descending | Select-Object -First 1
    $result.Status = $latest.Status
    return $result
}

function Get-TdsPackage(){
    [CmdletBinding()]
    param
    (
        [parameter (Mandatory = $true) ]
        [string]$TdsPackagePath
    )
    Write-Verbose "verify if $TdsPackagePath exists"
    if(!(Test-Path $TdsPackagePath)){
        Write-Warning "$TdsPackagePath doesn't exist!"
        return $null
    }
    return Get-ChildItem $TdsPackagePath -Filter "*.update" | Sort-Object -Property LastWritetime -Descending | Select-Object -First 1
}