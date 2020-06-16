<#
.SYNOPSIS
 This file will be called from Deploy.ps1
.DESCRIPTION
 Collect data from something..
.LINK

.NOTES
 FileName: TSDriveSpace
 Author: Tim Davis
 Contact: @binarymethod
 Created: 6/16/2020
 Modified: 6/16/2020

 Version - 0.0.1 - (6/16/2020)

#>

[cmdletbinding()]
param(
)
begin {
    $ExtensionID = "f435dfe4-0a04-4f2c-ab85-ab0b7072ef40"
    $ExtensionName = "TSDriveSpace"
    $ExtensionVersion = "0.0.1"
    $ExtensionEnabled = $true
    $LastRun = $false
    $LastStatus = $false
}
process {

    # Define Model
    # This model will be used to create the table with the right columns and datatypes in the database
    $Model = New-Object Collections.Generic.List[object]

    $Model.Add(@{
            Name        = "ComputerId"
            DataType    = [Guid].ToString()
            Description = "Unique ID of machine running the script"
        })

    $Model.Add(@{
            Name        = "DriveLetter"
            DataType    = [String].ToString()
            Description = "OS Drive Letter"
        })

    $Model.Add(@{
            Name        = "Size"
            DataType    = [UInt64].ToString()
            Description = "Total drive space in bytes"
        })

    $Model.Add(@{
            Name        = "Free"
            DataType    = [UInt64].ToString()
            Description = "Free drive space in bytes"
        })

    $Model.Add(@{
            Name        = "Used"
            DataType    = [UInt64].ToString()
            Description = "Used drive space in bytes"
        })

    $Model.Add(@{
            Name        = "PercentFree"
            DataType    = [int].ToString()
            Description = "Percent of Free Space"
        })

    $Model.Add(@{
            Name        = "VolumeName"
            DataType    = [string].ToString()
            Description = "Name of Volume"
        })
    
    $Model.Add(@{
            Name        = "TypeName"
            DataType    = [string].ToString()
            Description = "Disk Type Name"
        })

    $Model.Add(@{
            Name        = "TypeCode"
            DataType    = [int].ToString()
            Description = "Disk Type Code"
        })


    # Define Tables/Models
    # Add any additional Table/Model pairs here.
    $Models = New-Object Collections.Generic.List[object]
    $Models.Add(@{
            'Table' = "TSDriveSpace";
            'Model' = $Model;
        })

    # Define filters this Extension will use to trigger install on client (to see availeble filters, run ClientHealthGather extension)
    $Filters = @{

        IsDellLaptop = @{
            IsLaptop = $true
            Make     = "Dell Inc."
        }

        IsDellTablet = @{
            IsTablet = $true
            Make     = "Dell Inc."
        }
    }

    # Optional: Define require system Modules here
    # Plugin will auto import these modules as needed
    $SystemModules = New-Object Collections.Generic.List[object]
    # $SystemModules.Add("Module-Name")

    # Optional: Define your Module here,
    # Allows server to manage what Modules are still needed
    # Plugin will auto import all modules listed

    $Modules = New-Object Collections.Generic.List[object]
    #$Modules.Add(@{
    #    'ExtensionID' = "d3d4bf2d-fd70-4e34-bccd-16986197e0f4"
    #    'Name' = "TSDriveSpace";
    #    'Version' = '0.0.1';
    #    'Source' = 'Change Source to match your deployment distribution location';
    #    'Enabled' = $true;
    #})

    $Schedules = New-Object Collections.Generic.List[object]

    # Create Extension Object
    $Extension = @{
        "Id"            = $ExtensionID
        "Name"          = $ExtensionName
        "Version"       = $ExtensionVersion
        "Enabled"       = $ExtensionEnabled
        "Models"        = $Models
        "Filters"       = $Filters
        "Modules"       = $Modules
        "SystemModules" = $SystemModules
        "Schedules"     = $Schedules
        "LastRun"       = $LastRun
        "LastStatus"    = $LastStatus
    }

    # Pass Extension object off to Pipeline
    $Extension
}
