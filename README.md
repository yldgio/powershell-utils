# Dotnet Create

Prototype Utility for dotnet project setup & initialization.

```powershell  
dotnet-create.ps1 [-ProjectName] <string> [-Template] <string> [[-SolutionName] <string>] [[-Output] <string>] [[-SdkVersion] <string>] [[-TestFramework] <string>] [[-progress] <string>] [<CommonParameters>]
```

Parameters:

- -__ProjectName__: main project name (-n, -name), Mandatory
- -__Template__: name of the dotnet template (classlib, webapi, webapp, web, mvc, etc.. type `dotnet new --list` for a list) (-t, -tpl)
- -__SolutionName__: name of the dotnet Solution (when empty the -name Parameter will be used) (-s, -sln)
- -__Output__: the path to the root folder (when empty the current path will be used) (-o, -path)
- -__SdkVersion__: Dotnet SDK version in the format x.y.z (when empty the globaljson file will be skipped and the current version will be used) (-v, -sdk)
- -__TestFramework__: Test framework to use, defaults to xunit (-x, -test)

example usage:

`.\src\dotnet-create.ps1 -s Test.Solution -n Test.Project.WebApi -t webapi -x xunit`

## TODO

- load solution configuration from json, ie:

```json
{
    "name": "solutionName",
    "sdk": "6.0",
    "projects": [
        {
            "name": "My.Project",
            "packages":[]

        }
    ]
}
```

---
---

# Check Sitecore Tds Package Deployment

Script per verificare l'avvenuto deployment dei package tds e lo stato di deployment stesso.
Lo script verifica l'esistenza del file di report di installazione e il contenuto per individuare l'esito dell'installazione.

Può tornare errore se il file non è stato trovato o lo Stato è 'Fail'

## Check-SitecoreDeployments.ps1

Parametri:

- __TdsPackagePath__: path al folder contenente il Package TDS rilasciato, es:

      -TdsPackagePath "c:\WorkFolder\TDSBundle.Foundation\"

- __DeploymentPath__: path alla cartella in cui vencono depositati i package TDS in fase di rilascio, es:

      -DeploymentPath "c:\SitecoreRoot\Data\SitecorePackageDeployer"

- __MaxAttempts__: numero massimo di tentativi
- __TryEvery__: numero di secondi tra ogni tentativo

Example:

`
Check-SitecoreDeployments.ps1 -TdsPackagePath "c:\WorkFolder\TDSBundle.Foundation\"  -DeploymentPath "c:\SitecoreRoot\Data\SitecorePackageDeployer" -MaxAttempts 10 -TryEvery 5
`

Nell'esempio, lo script proverà per 50 secondi ogni 5 secondi a vrificare l'esito del deploy.
