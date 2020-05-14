$ExtensionPath = (get-item $PSScriptRoot ).parent.FullName

$file = Get-ChildItem -Path $ExtensionPath -Filter *.ps1 -Recurse | Where-Object { $_.Name -notlike "*.tests.ps1" }

$testCase = $file | Foreach-Object { @{file = $_ } }



Describe 'PSParser analysis' {
    $scripts = Get-ChildItem "$ExtensionPath\Runtime" -Recurse

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
    $ScriptAnalyzerRules = Get-ScriptAnalyzerRule | Where-Object { $_.RuleName -notlike "PSDSC*" -and $_.RuleName -ne "PSUseDeclaredVarsMoreThanAssignments" -and $_.RuleName -ne "PSAvoidUsingPositionalParameters" }

    foreach ($f in $file) {
        Foreach ( $Rule in $ScriptAnalyzerRules ) {
            it "$($f.name) Passes   $($Rule.RuleName)" {


                Invoke-ScriptAnalyzer -Path $f.fullname  -IncludeRule $Rule.RuleName | Should BeNullOrEmpty

            }
        }
    }
}
