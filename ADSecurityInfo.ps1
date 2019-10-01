###############################################
# Script to collect Windows Server information, 
# Services installed on the servers and user information.
#
# Be sure to edit the path where the CSV files should be placed.
#
############################################### 


# Set the path where csv files will be stored.  Must be full path excluding final "\"
$myPath = "C:\Temp"

# Get information about the domian
Get-ADDomain | Select-Object -Property DNSRoot, NetBIOSName, DomainMode | Export-Csv -Path $myPath\domain.csv -NoTypeInformation

# Get list of users in AD
Get-ADUser -Filter * -Properties Enabled, LastLogonDate, PasswordLastSet,PasswordNeverExpires, SIDHistory, TrustedForDelegation, TrustedToAuthForDelegation, userAccountControl | Export-Csv -Path $myPath\users.csv -NoTypeInformation

# Get servers in AD as well as any service running on the server.
$computers = Get-ADComputer -Filter {(OperatingSystem -like "*Windows Server*")}  -Properties LastLogonDate,OperatingSystem, PasswordLastSet, primaryGroupID, TrustedForDelegation, TrustedToAuthForDelegation
$computers | Export-Csv -Path $myPath\servers.csv -NoTypeInformation
foreach($Computer in $computers)
    {
        Get-WmiObject win32_service -ComputerName $Computer.DNSHostName -ErrorAction SilentlyContinue | Select-Object -Property DisplayName, Name, PathName, PSComputerName, startName, startMode, State | Export-Csv -Path $myPAth\services.csv -NoTypeInformation -Append -Force

    }



##########################################
## Useful info
#
### PrimaryGroupID
# 515 – Domain Computers
# 516 – Domain Controllers (writable)
# 521 – Domain Controllers (Read-Only)
####
#
##########################################
