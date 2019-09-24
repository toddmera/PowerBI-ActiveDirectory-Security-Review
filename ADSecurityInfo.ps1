###############################################
# Script to collect Windows Server information, 
# Services installed on the servers and user information.
#
# Be sure to edit the path where the CSV files should be placed.
#
############################################### 

#### Start Edit ####

$myPath = "C:\Temp"

#### End Edit ######


Get-ADComputer -Filter {(OperatingSystem -like "*Windows Server*")} -Properties * | Export-Csv -Path $myPath\servers.csv -NoTypeInformation
Get-ADUser -Filter * | Export-Csv -Path $myPath\users.csv -NoTypeInformation

$computers = Get-ADComputer -Filter {(OperatingSystem -like "*Windows Server*")}
foreach($Computer in $computers)
    {
        Get-WmiObject win32_service -ComputerName $Computer.DNSHostName | Export-Csv -Path $myPAth\services.csv -NoTypeInformation -Append

    }




