<# NS01=printer with crashing spooler bc of TCP/IP ports AD04=Printer we're sharing print objects off of so that Nexus stops breaking print services
NS01 export all printers using PE scripted monthly backups 
NS01 delete all printers using TCP ports remove-printer blah blah 
AD04 make \\ local ports using get-printer-pipe, then use those results to feed a for loop
AD04 import using PE file
use magic to list out all printers using IP port rather than local port 

NS01 make all \\AD04 local ports 
NS01 create printers using \\ad04 ports

Run this script after exportprint.ps1 and before printerinstall.ps1
#>

# Get printer names, driver-type, portname, and style, export FROM NX01 to CSV.
Get-Printer | Select Name, DriverName, PortName, ShareName | Export-Csv -Path "C:\safe\nx01-printers.csv"

$printerList = "C:\safe\nx01-printers.csv"

try {
    if (-not (Test-Path -Path $printerList)) {
        throw "CSV file not found at path: $printerList"
    }

    $printers = Import-Csv -Path $printerList

    if (-not $printers -or $printers.Count -eq 0) {
        throw "CSV file is empty or has no valid rows."
    }

    foreach ($printer in $printers) {
        Remove-Printer -Name $printer.Name
        Remove-PrinterPort -Name $printer.PortName

        $newPort = $printer.PortName -replace "((?:[0-9]{1,3}\.){3}[0-9]{1,3})", "AD01"
        Add-PrinterPort -Name $newPort -PrinterHostAddress $newPort
        Add-Printer -Name $printer.Name -Drivername $printer.Driver -Portname $newPort -Shared -ShareName $printer.ShareName
    }
} catch {
    Write-Error "Error: $_"
}