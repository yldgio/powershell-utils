function Get-MatchesInFiles(){
    [CmdletBinding()]
    param
    (
        [parameter (Mandatory = $true) ]
        [string]$Path,
        [parameter (Mandatory = $true) ]
        [string]$Filter,  # = "*.sql",
        [parameter (Mandatory = $true) ]
        [string]$Pattern # = "mydatabase\.\w+\.w+"
    )
    $result = @()
    $files = Get-ChildItem -Recurse -Filter $Filter | Select-String -Pattern $Pattern  | Select-Object -Unique Path
    foreach ($file in $files){
       $match = Get-Content -path $file.Path | Select-String -Pattern $Pattern -AllMatches | ForEach-Object {$_.Matches.Value}
       #Write-Host $match.Count
       if($match.Count -gt 0){
            $result += @{Path = $file.Path; Matches = $match}
       }
    }
    
    return $result
}

#Get-MatchesInFiles -Filter "*.sql" -Pattern "mydatabase\.\w+\.w+"