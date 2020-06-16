<#
.SYNOPSIS
 Get Drive Space stats

.DESCRIPTION
 Collect data from something..
.LINK

.NOTES
 Extension: "TSDriveSpace"
 ExtensionID: "f435dfe4-0a04-4f2c-ab85-ab0b7072ef40"
 FileName: Invoke-TSDriveSpace.ps1
 Author: Tim Davis
 Contact: @binarymethod
 Created: 6/16/2020

 Version - 0.0.1


.Example
Invoke-TSDriveSpace.ps1

#>

[cmdletbinding(SupportsShouldProcess = $True)]
param(

)
begin {
    # Setup Global Variables
    $ComputerId = Get-CimInstance -ClassName Win32_ComputerSystemProduct | Select-Object -ExpandProperty UUID

    # Import any Modules your extension may need
}

process {
    Write-Verbose "Starting Extension $ExtensionName [$ExtensionID]"

    $drives = New-Object Collections.Generic.List[object]

    Get-CimInstance -ClassName Win32_logicaldisk | ForEach-Object {

        # Determine our Device Type
        $typeName = "Invalid DriveType"
        switch($_.DriveType) {
            0 {$typeName = "Unknown"; Break}
            1 {$typeName = "No Root Directory"; Break}
            2 {$typeName = "Removable Disk"; Break}
            3 {$typeName = "Local Disk"; Break}
            4 {$typeName = "Network Drive"; Break}
            5 {$typeName = "Compact Disc"; Break}
            6 {$typeName = "RAM Disk"; Break}
            default {$typeName = "Invalid DriveType"; Break}
        }

        if($_.Size -gt 0) {
            $drive = @{
                ComputerId = $ComputerId
                DriveLetter = $_.DeviceID
                Size = $_.Size
                Free = $_.FreeSpace
                Used = $_.Size - $_.FreeSpace
                PercentFree = [Math]::Floor([decimal](($_.FreeSpace / $_.Size) * 100))
                VolumeName = $_.VolumeName
                TypeName = $typeName
                TypeCode = $_.DriveType
            }
        } else {
            $drive = @{
                ComputerId = $ComputerId
                DriveLetter = $_.DeviceID
                Size = 0
                Free = 0
                Used = 0
                PercentFree = 0
                VolumeName = $_.VolumeName
                TypeName = $typeName
                TypeCode = $_.DriveType
            }
        }

        $drives.Add((New-Object PSObject -Property $drive))
    }

    #$drives
    # Option with Multiple Tables
    $results = @{
        "TSDriveSpace"       = $drives
    }
    $results
}
end { }
