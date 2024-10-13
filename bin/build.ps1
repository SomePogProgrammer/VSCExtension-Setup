# build.ps1

# Define the paths based on your specified directory structure
$baseDirectory = "..\VSC-ExtensionSetup"
$inputScript = Join-Path -Path $baseDirectory -ChildPath "Main.ps1"
$outputExe = Join-Path -Path $baseDirectory -ChildPath "vsc-extensionsetup.exe"

# Check if PS2EXE is installed, if not, install it
if (-not (Get-Module -ListAvailable -Name 'PS2EXE')) {
    Install-Module -Name 'PS2EXE' -Scope CurrentUser -Force -AllowClobber
}

# Import the PS2EXE module
Import-Module PS2EXE

# Execute PS2EXE with all options, ensuring it outputs to the console
Invoke-PS2EXE -InputFile $inputScript `
              -OutputFile $outputExe `
              -Title "VSC Extension Setup" `
              -Description "This executable sets up Visual Studio Code extensions." `
              -Company "Quincy.M.Dack" `
              -Product "VSC Extension Setup Tool" `
              -Copyright "2024 © Quincy.M.Dack" `
              -Version "1.0.0" `


Write-Output "Build completed: $outputExe"


# ------// Build Zip & Tar \\ ------
$scriptDir = "..\VSC-ExtensionSetup"
$modulesDir = Join-Path $scriptDir 'Modules'
$outputZipFile = Join-Path $scriptDir './Production/VSC-ExtensionSetup.zip'
$outputTarFile = Join-Path $scriptDir './Production/VSC-ExtensionSetup.tar'
$outputTarGzFile = Join-Path $scriptDir './Production/VSC-ExtensionSetup.tar.gz'
$outputZipGzFile = Join-Path $scriptDir './Production/VSC-ExtensionSetup.zip.gz'
$outputSourceFile = Join-Path $scriptDir './Production/Source'
$productionExe = Join-Path $scriptDir './Production/vsc-extensionsetup.exe'

# Clean up previous build files if they exist
if (Test-Path $outputZipFile) {
    Remove-Item $outputZipFile -Force
}
if (Test-Path $outputTarFile) {
    Remove-Item $outputTarFile -Force
}
if (Test-Path $outputTarGzFile) {
    Remove-Item $outputTarGzFile -Force
}
if (Test-Path $outputZipGzFile) {
    Remove-Item $outputZipGzFile -Force
}
if (Test-Path $outputSourceFile) {
    Remove-Item $outputSourceFile -Recurse -Force
}
if (Test-Path $productionExe) {
    Remove-Item $productionExe -Force
}

# Create a temporary directory for packaging
$tempDir = Join-Path $scriptDir 'TempBuild'
New-Item -ItemType Directory -Path $tempDir -Force | Out-Null

# Copy main script and other files to the temporary directory
Copy-Item -Path (Join-Path $scriptDir 'Main.ps1') -Destination $tempDir
Copy-Item -Path (Join-Path $scriptDir 'README.md') -Destination $tempDir
Copy-Item -Path (Join-Path $scriptDir 'License.md') -Destination $tempDir
Copy-Item -Path (Join-Path $scriptDir 'sample.txt') -Destination $tempDir
Copy-Item -Path (Join-Path $scriptDir 'Manifest.psd1') -Destination $tempDir

# Create the Modules directory in the temporary directory
$modulesTempDir = Join-Path $tempDir 'Modules'
New-Item -ItemType Directory -Path $modulesTempDir -Force | Out-Null

# Copy contents of the Modules folder to the Modules directory in the temp directory
Copy-Item -Path (Join-Path $modulesDir '*') -Destination $modulesTempDir -Recurse

# Create the output directory if it doesn't exist
$outputDir = Split-Path -Parent $outputZipFile
if (-not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
}

# Create the .zip file
Add-Type -AssemblyName 'System.IO.Compression.FileSystem'
[System.IO.Compression.ZipFile]::CreateFromDirectory($tempDir, $outputZipFile)

# Create the .tar file using the tar command
tar -cvf $outputTarFile -C $tempDir .

# Create the .tar.gz file by compressing the .tar file with gzip
tar -czvf $outputTarGzFile -C $scriptDir 'VSC-ExtensionSetup.tar'

# Create the zip.gz file by compressing the .zip file
$zipFileStream = [System.IO.File]::OpenRead($outputZipFile)
$zipGzStream = [System.IO.Compression.GzipStream]::new(
    [System.IO.File]::Open($outputZipGzFile, [System.IO.FileMode]::Create),
    [System.IO.Compression.CompressionMode]::Compress
)

# Buffer to hold the data while reading and writing
$buffer = New-Object byte[] 8192  # 8 KB buffer
$bytesRead = 0

# Read from the zip file and write to the gzip stream
do {
    $bytesRead = $zipFileStream.Read($buffer, 0, $buffer.Length)
    if ($bytesRead -gt 0) {
        $zipGzStream.Write($buffer, 0, $bytesRead)
    }
} while ($bytesRead -gt 0)

# Cleanup streams
$zipGzStream.Dispose()
$zipFileStream.Dispose()

# Create source file & prod exe
Copy-Item -Path $tempDir -Destination $outputSourceFile -Recurse -Force
Copy-Item -Path $outputExe -Destination $productionExe -Recurse -Force

# Clean up temporary directory
Remove-Item $tempDir -Recurse -Force

# Output success message
Write-Output "Build completed. Output files: $outputZipFile, $outputTarFile, $outputTarGzFile, $outputZipGzFile, $outputSourceFile"
