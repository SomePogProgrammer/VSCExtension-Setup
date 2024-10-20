<#
   Colors Module
   Provides color functions for console output.
#>

function Write-Green {
    param ([string]$message)
    Write-Host $message -ForegroundColor "Green"
}

function Write-Red {
    param ([string]$message)
    Write-Host $message -ForegroundColor "Red"
}

function Write-Yellow {
    param ([string]$message)
    Write-Host $message -ForegroundColor "Yellow"
}
