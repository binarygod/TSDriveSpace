<#
.SYNOPSIS

.DESCRIPTION
    Drive Space Collection for Truesec Client Health Monitor
.LINK

.NOTES
 FileName: TSDriveSpace
 Author: Tim Davis
 Contact: binary.god@gmail.com
 Created: 2019-07-25
 Modified: 2019-07-25

 Version - 0.0.1 - (2019-07-25)


 TODO:
 [ ] Script Main Goal
 [ ] Script Secondary Goal

.Example

#>

[cmdletbinding()]
param(
    [Parameter(ParameterSetName = 'Default', ValueFromPipeline = $false, ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
    [String]$Hash,
    [Parameter(ParameterSetName = 'Default', ValueFromPipeline = $false, ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
    [String]$Source
)
begin {

    $ExtensionID = "d3d4bf2d-fd70-4e34-bccd-16986197e0f4"
    $ExtensionName = "TSDriveSpace"
    $ExtensionVersion = "0.0.1"
    $ExtensionEnabled = $true
}
process {

    # Define Model
    $Model = new-object PSCustomObject

    # Mock data, important to define datatype
    # UUID links data to the Computer, should be kept
    [GUID]$ComputerID = "FF48135E-4764-405F-8BC8-8E83DED065E3"
    # Add more properties as needed
    [String]$DeviceID = "C:"
    [UInt64]$Size = 499530067968
    [uint64]$Free = 209478905856
    [String]$VolumeName = "Boot"

    # Add Properties to the model, these get translated to Database Columns
    $Model | Add-Member NoteProperty ComputerID $ComputerID
    # Add more properties as needed
    $Model | Add-Member NoteProperty DeviceID $DeviceID
    $Model | Add-Member NoteProperty Size $Size
    $Model | Add-Member NoteProperty Free $Free
    $Model | Add-Member NoteProperty VolumneName $VolumeName

    # Define Tables/Models
    # Add any additional Table/Model pairs here.
    $Models = New-Object Collections.Generic.List[object]
    $Models.Add(@{
            'Table' = "TSDriveSpace";
            'Model' = $Model;
        }) | Out-Null

    # Define filters this Extension will use to trigger install on client
    $Filters = @{
        IsDesktop = $true
    }

    # Optional: Define require system Modules here
    # Plugin will auto import these modules as needed
    $SystemModules = New-Object System.Collections.ArrayList
    # $SystemModules.Add("Module-Name")

    # Optional: Define your Module here,
    # Allows server to manage what Modules are still needed
    # Plugin will auto import all modules listed

    $Modules = New-Object System.Collections.ArrayList
    #$Modules.Add(@{
    #    'ExtensionID' = "d3d4bf2d-fd70-4e34-bccd-16986197e0f4"
    #    'Name' = "TSDriveSpace";
    #    'Version' = '0.0.1';
    #    'Source' = 'Change Source to match your deployment distribution location';
    #    'Enabled' = $true;
    #})

    $Schedule = @{
        "ScheduleType" = "ScheduledTask"
        "Trigger"      = "Time"                 # Implemented: Startup, Logon, Time   ToDo list: Event, Workstation Lock
        "IntervalType" = "Daily"                # "Daily", "Weekly", "Hourly", "Minutely"
        "Interval"     = "1"                    # Every week
        "Time"         = "10:10:10"             # "22:33:05"
        "Executable"   = "powershell.exe"
        "Argument"     = "-NoProfile -ExecutionPolicy Bypass -File Invoke-DriveSpace.ps1"
        "ScheduleID"   = "ab80ccff-6215-4a9d-af58-e0f1da9d7add" # Uniqe guid
    }

    $Schedules = New-Object System.Collections.ArrayList
    $Schedules.add($Schedule) | Out-Null

    # Create Extension Object
    $Extension = @{
        'Id'      = $ExtensionID
        'Name'    = $ExtensionName
        'Version' = $ExtensionVersion
        'Source'  = $ExtensionSource # Not needed here, determined by Admin which installs the Extension (Path where client downlaods Extensions)
        'Enabled' = $ExtensionEnabled
        'Hash'    = $Hash # Not needed here, used for published packaging
        'Models'  = $Models
        'Filters' = $Filters
        'Modules' = $Modules
        'SystemModules' = $SystemModules
        'Schedules'= $Schedules
    }

    # Pass Extension object off to Pipe
    $Extension
}

