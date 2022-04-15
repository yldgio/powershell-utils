param(    
    [Parameter(Mandatory=$true, HelpMessage="name of the dotnet project")]
    [Alias("n", "name")]
    [string]$ProjectName,
    [Parameter(Mandatory=$true, HelpMessage="name of the dotnet template (classlib, webapi, webapp, web, mvc, etc.. type 'dotnet new --list' for a list)")]
    [Alias("t","tpl")]
    [string]$Template = ".",
    [Parameter(Mandatory=$false, HelpMessage="name of the dotnet Solution (when empty the -name Parameter will be used)")]
    [Alias("s","sln")]
    [string]$SolutionName,
    [Parameter(Mandatory=$false, HelpMessage="the path to the root folder (when empty the current path will be used)")]
    [Alias("o","path")]
    [string]$Output = ".",
    [Parameter(Mandatory=$false, HelpMessage="Dotnet SDK version in the format x.y.z (when empty the globaljson file will be skipped and the current version will be used)")]
    [Alias("v","sdk")]
    [string]$SdkVersion = "",
    [Parameter(Mandatory=$false, HelpMessage="Test framework to use, defaults to xunit")]
    [Alias("x","test")]
    [string]$TestFramework = "xunit",
    [ValidateSet("Stop","Inquire","Continue","SilentlyContinue")]
    [string]$progress="Stop"
)
if([string]::IsNullOrEmpty($SolutionName)){
    $SolutionName = $ProjectName
}
$startLocation = Get-Location 
if(!(Test-Path -Path $Output)){
    Write-Error "The path $Output was not found"
    exit 1
}
if($Output -eq "."){
    $Output = "./$SolutionName"
    New-Item -Type Directory -Path $Output -Force
}
$Output = Resolve-Path $Output
Set-Location $Output
mkdir src
mkdir tests
mkdir docs
dotnet new gitignore
dotnet new editorconfig
if(![string]::IsNullOrEmpty($SdkVersion)){
    dotnet new globaljson --sdk-version $SdkVersion --roll-forward feature
}
dotnet new sln -n $SolutionName
dotnet new $Template -n $ProjectName -o "src/$ProjectName" --no-restore
dotnet new $TestFramework -n "$($ProjectName).UnitTests" -o "tests/$($ProjectName).UnitTests" --no-restore
dotnet new $TestFramework -n "$($ProjectName).IntegrationTests" -o "tests/$($ProjectName).IntegrationTests" --no-restore
Get-ChildItem -Path "src/" -Filter "*.csproj" -Recurse | ForEach-Object { 
    dotnet sln add $_.FullName
}
Get-ChildItem -Path "tests/" -Filter "*.csproj" -Recurse | ForEach-Object { 
    dotnet sln add $_.FullName
}


Set-Location $startLocation


