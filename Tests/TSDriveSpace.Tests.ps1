$ExtensionPath = (get-item $PSScriptRoot ).parent.FullName

$file = Get-ChildItem -Path $ExtensionPath -Filter *.ps1 -Recurse | Where-Object { $_.Name -notlike "*.tests.ps1" }

$testCase = $file | Foreach-Object { @{file = $_ } }



Describe 'PSParser analysis' {
    $scripts = Get-ChildItem "$ExtensionPath\Runtime" -Recurse -Filter *.ps1

    # TestCases are splatted to the script so we need hashtables
    $testCase = $scripts | Foreach-Object { @{file = $_ } }
    It "Script <file> should be valid powershell" -TestCases $testCase {
        param($file)

        $file.fullname | Should Exist

        $contents = Get-Content -Path $file.fullname -ErrorAction Stop
        $errors = $null
        $null = [System.Management.Automation.PSParser]::Tokenize($contents, [ref]$errors)
        $errors.Count | Should Be 0
    }

}


Describe 'PSScriptAnalyzer Rules' {
    $ScriptAnalyzerRules = Get-ScriptAnalyzerRule | Where-Object { $_.RuleName -notlike "PSDSC*" }

    foreach ($f in $file) {
        Foreach ( $Rule in $ScriptAnalyzerRules ) {
            it "$($f.name) Passes   $($Rule.RuleName)" {
                $result = Invoke-ScriptAnalyzer -Path $f.fullname -IncludeRule $Rule.RuleName

                if ($null -ne $result) {
                    Write-Host "    [-] $($f.Name) Fails   $($result.RuleName)" -ForegroundColor Red
                    $result | ForEach-Object {
                        Write-Host "       [Line $($_.Extent.StartLineNumber)]   $($_.Message)" -ForegroundColor Yellow
                    }
                }

                $result | Should BeNullOrEmpty
            }
        }
    }
}

$extension = & $ExtensionPath\Config.ps1
foreach ($model in $extension.Models) {


    Describe "$($model.Table) Column Types" {

        $obj = New-Object -TypeName PSObject

        foreach ($m in $model.model) {


            It "$($m.name) should be a valid type ($($m.DataType))" {

                if ($m.DataType -eq "Guid") {

                    $obj | Add-Member -MemberType NoteProperty -Name $m.Name -Value (New-Object System.Guid) | should be $null
                } else {
                    $obj | Add-Member -MemberType NoteProperty -Name $m.Name -Value ($null -as ($m.DataType -as [type])) | should be $null
                }

            }

        }
    }


}

Describe "Extension data" {

    It "Should have a name" {
        $extension.name | Should not be $null
    }

    It "ExtensionId should be a guid" {
        $extension.id -match ("^(\{){0,1}[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}(\}){0,1}$") | Should be $true
    }
    It "Should have a valid version" {
        [version]$extension.version | Should be $true
    }
}

Describe "Parameters in Invoke-TSDriveSpace.ps1 should match Config.ps1" {

    # Get the content from the runtime file
    $runtime = Get-Command  "$ExtensionPath\RunTime\Invoke-TSDriveSpace.ps1"

    # Grab the parameters from the file
    $parameters = $runtime.parameters.keys

    # Parameters should match whats defined in config.ps1
    If ($extension.LastRun) {
        It "LastRun should exist" {
            $parameters -contains "LastRun" | Should be $true
        }
    } else {
        It "LastRun should not exist" {
            $parameters -contains "LastRun" | Should be $false
        }
    }

    If ($extension.LastStatus) {
        It "LastStatus should exist" {
            $parameters -contains "LastStatus" | Should be $true
        }
    } else {
        It "LastStatus should not exist" {
            $parameters -contains "LastStatus" | Should be $false
        }
    }

}

