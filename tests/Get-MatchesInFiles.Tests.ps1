
Describe 'Get-LinkedTables tests' -Tag 'unit' {
    BeforeAll {
        $repo = Resolve-Path(split-path -parent $PSScriptRoot)
        $sutDir = "$repo\src"
        . "$sutDir\Get-MatchesInFiles.ps1"
        $result = Get-MatchesInFiles -Path "$repo\tests\data\SitecorePackageDeployer" -Filter "*.json" -Pattern '"status":"fail"'
    }
    Context "With files found" {
        It 'should return all matching paths' {
            Write-Host ($result | ForEach-Object{ [pscustomobject]$_ })
            $result.Length | Should -Be 2
        }
    }
}