
Describe 'Get-Deployment tests' -Tag 'unit' {
    BeforeAll {
        $repo = Resolve-Path(split-path -parent $PSScriptRoot)
        $sutDir = "$repo\src"
        . "$sutDir\Get-Deployment.ps1"

        $wrongDeploymentPathResult = Get-Deployments -DeploymentPath "$repo\tests\NotThere" -TdsPackagePath "$repo\tests\data\TDSBundle.Feature"
        $oneSuccesResult = Get-Deployments -DeploymentPath "$repo\tests\data\SitecorePackageDeployer" -TdsPackagePath "$repo\tests\data\TDSBundle.Feature"
        $failedResults = Get-Deployments -DeploymentPath "$repo\tests\data\SitecorePackageDeployer" -TdsPackagePath "$repo\tests\data\TDSBundle.FoundationFailed"
        $multipleFiles = Get-Deployments -DeploymentPath "$repo\tests\data\SitecorePackageDeployer" -TdsPackagePath "$repo\tests\data\TDSBundle.Foundation"
        $noTdsPackagePath = Get-Deployments -DeploymentPath "$repo\tests\data\SitecorePackageDeployer" -TdsPackagePath "$repo\tests\data\NotThere"
    }
    Context "With an non existent Deployment Path param" {
        It 'should return a status error' {
            $wrongDeploymentPathResult.Status | Should -Be "Error"
        }    
        It 'should return a 0 Count result' {
            $wrongDeploymentPathResult.Count | Should -Be 0
        }
    }
    Context "With an non existent -TdsPackagePath param" {
        It 'should return a status error' {
            $noTdsPackagePath.Status | Should -Be "Error"
        }    
        It 'should return a 0 Count result' {
            $noTdsPackagePath.Count | Should -Be 0
        }
    }
    Context "With deployments files found" {
        It 'should have the right number of deployments' {
            $oneSuccesResult.Deployments.Count | Should -Be 1
            $failedResults.Deployments.Count | Should -Be 1
            $multipleFiles.Deployments.Count | Should -Be 1
        }
        It 'should correctly count the number of deployments' {
            $oneSuccesResult.Count | Should -Be 1
            $oneSuccesResult.Deployments.Count | Should -Be 1
            $failedResults.Count | Should -Be 1
            $failedResults.Deployments.Count | Should -Be 1
            $multipleFiles.Deployments.Count | Should -Be 1
            $multipleFiles.Count | Should -Be 1
        }
        It 'should correctly count the number of successful deployments' {
            $oneSuccesResult.Deployments.Where({ $_.Status -ieq "Success" }).Count | Should -Be 1
            $failedResults.Deployments.Where({ $_.Status -ieq "Fail" }).Count | Should -Be 1
            $failedResults.Deployments.Where({ $_.Status -ieq "Success" }).Count | Should -Be 0
            $multipleFiles.Deployments.Where({ $_.Status -ieq "Success" }).Count | Should -Be 1
        }    
        It 'should correctly set the status from the latest execution' {
            $oneSuccesResult.Status | Should -Be "Success"
            $failedResults.Status | Should -Be "Fail"
            $multipleFiles.Status | Should -Be "Success"
        }    
    }
}
Describe 'Get-TdsPackage tests' -Tag 'unit' {
    BeforeAll {
        $repo = Resolve-Path(split-path -parent $PSScriptRoot)
        $sutDir = "$repo\src"
        . "$sutDir\Get-Deployment.ps1"
        $noFilesResult = Get-TdsPackage -TdsPackagePath "$repo\tests\data\NotThere"
        $succesResult = Get-TdsPackage -TdsPackagePath "$repo\tests\data\TDSBundle.Feature"
        $failedResult = Get-TdsPackage -TdsPackagePath "$repo\tests\data\TDSBundle.FoundationFailed"
        $multipleFile = Get-TdsPackage -TdsPackagePath "$repo\tests\data\TDSBundle.Foundation"
    }
    Context "With an non existent -TdsPackagePath param" {
        It 'should return a status error' {
            $noFilesResult | Should -BeNullOrEmpty
        }    
    }
}