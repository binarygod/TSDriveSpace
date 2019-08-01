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
param()
begin{
    Import-Module ClientHealthCore
    $ExtensionID = "d3d4bf2d-fd70-4e34-bccd-16986197e0f4"
}
process{
    

    # Define Model
    $Model = new-object PSCustomObject 

    # Mock data, important to define datatype
    # UUID links data to the Computer, should be kept
    [GUID]$UUID = "FF48135E-4764-405F-8BC8-8E83DED065E3"
    # Add more properties as needed
    [String]$DeviceID = "C:"
    [UInt64]$Size = 499530067968
    [uint64]$Free = 209478905856
    [String]$VolumeName = "Boot"

    # Add Properties to the model, these get translated to Database Columns
    $Model | Add-Member NoteProperty UUID $UUID
    # Add more properties as needed
    $Model | Add-Member NoteProperty DeviceID $DeviceID
    $Model | Add-Member NoteProperty Size $Size
    $Model | Add-Member NoteProperty Free $Free
    $Model | Add-Member NoteProperty VolumneName $VolumeName

    $response = Send-CHClientData -ExtensionID $ExtensionID -Data $Model -Table "TSDriveSpace"
    $response
}
