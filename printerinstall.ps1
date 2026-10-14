# Run this on the server that you are going to share all of the printers from.
# Transfer most recent printer export into AD01 first
# Extract it with

$currentDate = Get-Date -Format "MMddyy"
$backupName = "printer-$currentDate-export.printerExport"

& "$env:SystemRoot\System32\spool\tools\PrintBrm.exe" -r -f "E:\Shared\Data\backuplocation\$backupName"