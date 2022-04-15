function Edit-XmlNodes {
    param (
        [xml] $doc = $(throw "doc is a required parameter"),
        [string] $xpath = $(throw "xpath is a required parameter"),
        [string] $value = $(throw "value is a required parameter"),
        [Hashtable] $Namespace = @{}
    )    
            
    Select-Xml -xml $doc -Namespace $Namespace -XPath "//SSIS:Property[@SSIS:Name='Description']" | ForEach-Object { 
        $_.Node.InnerText = '1.1.55'
    }
}
$Namespace = @{
    SSIS="www.microsoft.com/SqlServer/SSIS"
}
#$repo = Resolve-Path(split-path -parent $PSScriptRoot)
$file = Resolve-Path "..\tests\data\xml\test.dtproj"
$xml = [xml](Get-Content $file)
Select-Xml -xml $xml -Namespace $Namespace -XPath "//SSIS:Property[@SSIS:Name='Description']" | ForEach-Object { 
    $_.Node.InnerText = '1.1.55'
}
$xml.save($file)