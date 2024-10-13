# build.ps1
# Build script to package PowerShell scripts into a zip file

# Define directories and output file
$scriptDir = "..\VSC-ExtensionSetup"
$modulesDir = Join-Path $scriptDir 'Modules'
$outputFile = Join-Path $scriptDir 'VSC-ExtensionSetup.zip'

# Clean up previous build file if it exists
if (Test-Path $outputFile) {
    Remove-Item $outputFile -Force
}

# Create a temporary directory for packaging
$tempDir = Join-Path $scriptDir 'TempBuild'
New-Item -ItemType Directory -Path $tempDir -Force | Out-Null

# Copy main script and modules to the temporary directory
Copy-Item -Path (Join-Path $scriptDir 'Main.ps1') -Destination $tempDir
Copy-Item -Path (Join-Path $modulesDir '*') -Destination $tempDir

# Zip the contents of the temporary directory
Add-Type -AssemblyName 'System.IO.Compression.FileSystem'
[System.IO.Compression.ZipFile]::CreateFromDirectory($tempDir, $outputFile)

# Clean up temporary directory
Remove-Item $tempDir -Recurse -Force

# Output success message
Write-Output "Build completed. Output file: $outputFile"
