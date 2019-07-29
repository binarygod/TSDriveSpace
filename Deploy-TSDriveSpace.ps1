<#
.SYNOPSIS

.DESCRIPTION
    Drive Space Collection for CHM
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
    [string]$Instance,
    [PSCredential]$Credentials,
    [string]$Database
)
begin{
    $ExtensionID = "ff48135e-4764-405f-8bc8-8e83ded065e3"
    $ExtensionName = "TSDriveSpace"
    $ExtensionVersion = "0.0.1"
    $ExtensionSource = "Change Source to match your deployment distribution location"
    $ExtensionEnabled = $true
}
process{
    Import-Module ClientHealthServerCore

    # Create Extension Object
    $Extension = @{
        'Id' = $ExtensionID;
        'Name' = $ExtensionName;
        'Version' = $ExtensionVersion;
        'Source' = $ExtensionSource;
        'Enabled' = $true
    }

    # Define Model
    $Model = new-object PSCustomObject 

    # Mock data, important to define datatype
    # UUID links data to the Computer, should be kept
    [GUID]$UUID = $ExtensionID
    # Add more properties as needed

    # Add Properties to the model, these get translated to Database Columns
    $Model | Add-Member NoteProperty UUID $UUID
    # Add more properties as needed

    # Define Tables/Models
    # Add any additional Table/Model pairs here.
    $Models = New-Object System.Collections.ArrayList
    $Models.Add(@{
        'Table' = "TSDriveSpace";
        'Model' = $Model;
    })

    # Define filters this Extension will use to trigger install on client
    $Filters = @{
        IsDesktop = $true
    }

    # Optional: Define your Module here,
    # Allows server to manage what Modules are still needed
    # If defined append '-Modules $Module' to Install-Extension call
    
    #$Module = @{
    #    'name' = "TSAppCrash";
    #    'version' = '0.0.1';
    #    'source' = '0.0.1'
    #}

    Install-Extension -Instance $Instance -Credentials $Credentials -Database $Database -Extension $Extension -Models $Models -Filters $Filters
}

