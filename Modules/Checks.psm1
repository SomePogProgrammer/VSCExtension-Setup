<#
   Checks Module
   Contains functions to perform system checks.
#>

function Read-Installed {
    if (-not (Get-Command code -ErrorAction SilentlyContinue)) {
        Write-Red "Could not detect 'code' command on your system.`n Aborting... `n `n  [ Aborted ]"
        exit 1
    }

    Write-Host "[INFO] Detected Visual Studio Code installation."
}
