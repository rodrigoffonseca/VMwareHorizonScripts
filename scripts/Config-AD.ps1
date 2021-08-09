#This script helps you to prepare your On-Premises Active Directory Domain Services for Horizon Cloud Deployment
#The script will create one Organizational Unit, two users, one group and will delegate appropriate permissions to the group to be able to join HOrizon VMs to the domain
#Define Variables
$OUName = "HOrizon-Azure"
$BinduserName1 = "binduser1"
$BinduserName2 = "binduser2"
$BindPWD = "P@ssword01"
$bindGroupName = "Horizon-Bind"
#Create New OU and get OU Path
New-ADOrganizationalUnit -Name $OUName
$OUpath = Get-ADOrganizationalUnit -Filter 'Name -like $OUName'
Write-Host "Your OU Path is" $OUpath.DistinguishedName
#Create Group
New-ADGroup -Name $bindGroupName -DisplayName $bindGroupName -GroupScope Global -GroupCategory Security -Path $OUpath.DistinguishedName
#Create two Bind Users
New-ADUser -Name $BinduserName1 -GivenName $BinduserName1 -SamAccountName $BinduserName1 -Path $OUpath.DistinguishedName -AccountPassword(ConvertTo-SecureString $BindPWD -AsPlainText -Force) -Enabled $true
New-ADUser -Name $BinduserName2 -GivenName $BinduserName2 -SamAccountName $BinduserName2 -Path $OUpath.DistinguishedName -AccountPassword(ConvertTo-SecureString $BindPWD -AsPlainText -Force) -Enabled $true
#Add Bind Users as members of the group
Add-ADGroupMember -Identity $bindGroupName -Members $BinduserName1, $BinduserName2
#Set group permission
# Collect and prepare Objects
Set-Location AD:
$group = Get-ADGroup -Identity $bindGroupName
$delegationGroupSID = [System.Security.Principal.SecurityIdentifier] $group.SID
$delegationGroupACL = Get-Acl -Path $OUpath.DistinguishedName
$aceIdentity = [System.Security.Principal.IdentityReference] $delegationGroupSID
$aceType = [System.Security.AccessControl.AccessControlType] "Allow"

Write-host "Delegating AD Permissions for group" $bindGroupName

#1 - Build Access Control Entry (ACE) for Read Pemision 
$ObjType = "00000000-0000-0000-0000-000000000000"
$InheritedObjectType = "00000000-0000-0000-0000-000000000000"
$aceADRight = [System.DirectoryServices.ActiveDirectoryRights] "ReadProperty, GenericExecute"
$aceInheritanceType = [System.DirectoryServices.ActiveDirectorySecurityInheritance] "All"
$ace = New-Object System.DirectoryServices.ActiveDirectoryAccessRule($aceIdentity, $aceADRight, $aceType, $ObjType, $aceInheritanceType, $InheritedObjectType)
$delegationGroupACL.AddAccessRule($ace)

# Apply ACL
Set-Acl -Path $OUpath.DistinguishedName -AclObject $delegationGroupACL

#2 - Build Access Control Entry (ACE) for Create/Delete Computer Permission
$ObjType = "bf967a86-0de6-11d0-a285-00aa003049e2"
$InheritedObjectType = "00000000-0000-0000-0000-000000000000"
$aceADRight = [System.DirectoryServices.ActiveDirectoryRights] "CreateChild, DeleteChild"
$aceInheritanceType = [System.DirectoryServices.ActiveDirectorySecurityInheritance] "All"
$ace = New-Object System.DirectoryServices.ActiveDirectoryAccessRule($aceIdentity, $aceADRight, $aceType, $ObjType, $aceInheritanceType, $InheritedObjectType)
$delegationGroupACL.AddAccessRule($ace)

# Apply ACL
Set-Acl -Path $OUpath.DistinguishedName -AclObject $delegationGroupACL

#3 - Build Access Control Entry (ACE) for Write All Properties Permission
$ObjType = "00000000-0000-0000-0000-000000000000"
$InheritedObjectType = "00000000-0000-0000-0000-000000000000"
$aceADRight = [System.DirectoryServices.ActiveDirectoryRights] "WriteProperty"
$aceInheritanceType = [System.DirectoryServices.ActiveDirectorySecurityInheritance] "Descendents"
$ace = New-Object System.DirectoryServices.ActiveDirectoryAccessRule($aceIdentity, $aceADRight, $aceType, $ObjType, $aceInheritanceType, $InheritedObjectType)
$delegationGroupACL.AddAccessRule($ace)

# Apply ACL
Set-Acl -Path $OUpath.DistinguishedName -AclObject $delegationGroupACL

#4 - Build Access Control Entry (ACE) for Reset Computer Password Permission
$ObjType = "00000000-0000-0000-0000-000000000000"
$InheritedObjectType = "bf967a86-0de6-11d0-a285-00aa003049e2"
$aceADRight = [System.DirectoryServices.ActiveDirectoryRights] "ReadProperty, GenericExecute"
$aceInheritanceType = [System.DirectoryServices.ActiveDirectorySecurityInheritance] "Descendents"
$ace = New-Object System.DirectoryServices.ActiveDirectoryAccessRule($aceIdentity, $aceADRight, $aceType, $ObjType, $aceInheritanceType, $InheritedObjectType)
$delegationGroupACL.AddAccessRule($ace)

# Apply ACL
Set-Acl -Path $OUpath.DistinguishedName -AclObject $delegationGroupACL

#4 - Build Access Control Entry (ACE) for Reset Computer Password Permission
$ObjType = "00299570-246d-11d0-a768-00aa006e0529"
$InheritedObjectType = "bf967a86-0de6-11d0-a285-00aa003049e2"
$aceADRight = [System.DirectoryServices.ActiveDirectoryRights] "ExtendedRight"
$aceInheritanceType = [System.DirectoryServices.ActiveDirectorySecurityInheritance] "Descendents"
$ace = New-Object System.DirectoryServices.ActiveDirectoryAccessRule($aceIdentity, $aceADRight, $aceType, $ObjType, $aceInheritanceType, $InheritedObjectType)
$delegationGroupACL.AddAccessRule($ace)

# Apply ACL
Set-Acl -Path $OUpath.DistinguishedName -AclObject $delegationGroupACL
