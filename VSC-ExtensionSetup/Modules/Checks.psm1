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

function Show-PATHPrompt {
    param (
        [string]$Message = "Would you also like to set up a PATH env variable, so you can execute the command doing: vsc-extensionsetup <command>"
    )

    while ($true) {
        $response = Read-Host "$Message (Y/N)"
        
        switch ($response.ToLower()) {
            'y' {
                return $true
            }
            'n' {
                return $false
            }
            default {
                Write-Host "Invalid input. Please enter Y or N."
            }
        }
    }
}

