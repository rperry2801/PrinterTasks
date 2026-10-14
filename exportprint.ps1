<#
Schedule task for once a day early in the morning or out of office hours
Action > Start a program > Program location: C:\WINDOWS\System32\WindowsPowershell\v1.0\powershell.exe
Arguments: -ExecutionPolicy Bypass -command "& C:\safe\exportprint.ps1"
Start in: C:\safe
#>

$currentDate = Get-Date -Format "MMddyy"
$backupName = "printer-$currentDate-export.printerExport"

& "$env:SystemRoot\System32\spool\tools\PrintBrm.exe" -b -f "C:\safe\$backupName"

Copy-Item -Path "C:\safe\$backupName" -Destination "\\AD01\Shared\printerbackups"