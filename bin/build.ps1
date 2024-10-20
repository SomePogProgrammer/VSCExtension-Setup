<#
    ===========================================
            Automatically Update Version 
    ===========================================

     And creates a proper build
#>
$psd1FilePath = "./VSC-ExtensionSetup.psd1"

# Check if the file exists
if (-Not (Test-Path $psd1FilePath)) {
    Write-Host "The specified .psd1 file does not exist: $psd1FilePath"
    exit
}

# Load the .psd1 file with UTF-8 encoding (no BOM)
$psd1Content = Get-Content -Path $psd1FilePath -Raw -Encoding UTF8

# Define a regex pattern to match the version number
$versionPattern = '(?<Version>\d+\.\d+\.\d+)'

# Check if the version number exists in the file
if ($psd1Content -notmatch $versionPattern) {
    Write-Host "No version number found in the specified .psd1 file."
    exit
}

# Extract the current version
$currentVersion = [regex]::Match($psd1Content, $versionPattern).Groups["Version"].Value

# Split the version into its components
$versionParts = $currentVersion -split '\.'

# Increment the patch version
$patchVersion = [int]$versionParts[2] + 1

# Roll over the version if it exceeds 9
if ($patchVersion -gt 9) {
    $patchVersion = 0
    $minorVersion = [int]$versionParts[1] + 1
    
    # Roll over minor version if it exceeds 9
    if ($minorVersion -gt 9) {
        $minorVersion = 0
        $majorVersion = [int]$versionParts[0] + 1
    } else {
        $majorVersion = [int]$versionParts[0]
    }
} else {
    $minorVersion = [int]$versionParts[1]
    $majorVersion = [int]$versionParts[0]
}

# Construct the new version string
$newVersion = "$majorVersion.$minorVersion.$patchVersion"

# Update the content with the new version
$newPsd1Content = $psd1Content -replace $versionPattern, "$newVersion"

# Write the updated content back to the .psd1 file as UTF-8 without BOM
$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
[System.IO.File]::WriteAllLines($psd1FilePath, $newPsd1Content, $Utf8NoBomEncoding)

Write-Host "Version updated from $currentVersion to $newVersion in $psd1FilePath"

<#

    ===========================================
           Creation Of Production Build
    ===========================================
     
#>

$checkMark = [char]0x2705   # ✅
$errorMark = [char]0x274C    # ❌
$outputMark = [System.Char]::ConvertFromUtf32(128195)

<#
 ------------------------------------ 
       Define base directory paths     
 ------------------------------------
#>
# Define the paths based on specified directory structure
$baseDirectory = "..\VSC-ExtensionSetup"
$inputScript = Join-Path -Path $baseDirectory -ChildPath "VSC-ExtensionSetup.ps1"
$modulesDir = Join-Path $baseDirectory 'Modules'
$outputExe = Join-Path $baseDirectory './Production/VSC-ExtensionSetup.exe'
$outputSourceFile = Join-Path $baseDirectory './Production/Source'
$outputVSCProd = Join-Path $baseDirectory './VSC-ExtensionSetup'

# Archive paths
$outputZipFile = Join-Path $baseDirectory './Production/VSC-ExtensionSetup.zip'
$outputTarFile = Join-Path $baseDirectory './Production/VSC-ExtensionSetup.tar'
$outputTarGzFile = Join-Path $baseDirectory './Production/VSC-ExtensionSetup.tar.gz'
$outputZipGzFile = Join-Path $baseDirectory './Production/VSC-ExtensionSetup.zip.gz'

# Temporary paths
$tempDir = Join-Path $baseDirectory 'TempBuild'



# ------------------------------------ 
#       Ensure required modules         
# ------------------------------------ 
function Install-ModuleIfNotInstalled {
    param (
        [string]$ModuleName
    )
    if (-not (Get-Module -ListAvailable -Name $ModuleName)) {
        try {
            Install-Module -Name $ModuleName -Scope CurrentUser -Force -AllowClobber -ErrorAction Stop
            Write-Host "[Info] $checkMark Installed module: $ModuleName" -ForegroundColor Cyan
        }
        catch {
            Write-Host "[Error] $errorMark Failed to install module {$ModuleName}: $_" -ForegroundColor Red
            exit 1
        }
    }
}


<#
    ============================== 
          Prepare for Archiving      
    ============================== 
#>
# Function to clean up previous build files
function Remove-OldFiles {
    param (
        [string[]]$Files
    )
    foreach ($file in $Files) {
        if (Test-Path $file) {
            Remove-Item $file -Recurse -Force
            Write-Host "[Output] $outputMark Removed old file: $file" -ForegroundColor DarkGray
        }
    }
}

$outputDir = Split-Path -Parent $outputZipFile
if (-not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
}

# Clean up old build files
Remove-OldFiles -Files @($outputZipFile, $outputTarFile, $outputTarGzFile, $outputZipGzFile, $outputSourceFile, $outputVSCProd, $outputExe, $outputDir)

# Ensure PS2EXE is installed
Install-ModuleIfNotInstalled -ModuleName 'PS2EXE'

# Import PS2EXE module
Import-Module PS2EXE

<# 
 ================================ 
    Create Temp File & Archives
 ================================ 
#>

# Create temporary build directory
if (Test-Path $tempDir) { 
    Remove-Item $tempDir -Recurse -Force 
}
New-Item -ItemType Directory -Path $tempDir -Force | Out-Null

# Copy Files to Temp Dir
function Copy-FilesToTemp {
    param (
        [string[]]$Files,
        [string]$Destination,
        [bool]$IsSilent
    )
    foreach ($file in $Files) {
        if (Test-Path $file) {
            Copy-Item -Path $file -Destination $Destination -Force
            if (-not $IsSilent) {
                Write-Host "[Output] $outputMark Copied file: $file to $Destination" -ForegroundColor DarkGray
            }
        }
        else {
            Write-Host "[Error] $errorMark Source file does not exist: $file" -ForegroundColor Red
        }
    }
}


# Copy files to TempDir after creating it
Copy-FilesToTemp -Files $filesToCopy -Destination $tempDir

# Rename tempDir to VSC-ExtensionSetup in parent directory
if (Test-Path $outputVSCProd) {
    Remove-Item $outputVSCProd -Recurse -Force
}

# Ensure tempDir exists before moving
if (Test-Path $tempDir) {
    Move-Item -Path $tempDir -Destination $outputVSCProd -Force
}
else {
    Write-Host "[Error] $errorMark TempBuild directory does not exist, cannot move files." -ForegroundColor Red
}
# Create the Modules directory in the temporary directory
$modulesTempDir = Join-Path $tempDir 'Modules'

New-Item -ItemType Directory -Path $modulesTempDir -Force | Out-Null

# Copy contents of the Modules folder to the Modules directory in the temp directory
Copy-Item -Path (Join-Path $modulesDir '*') -Destination $modulesTempDir -Recurse

$filesToCopy = @(
    (Join-Path $baseDirectory './VSC-ExtensionSetup.ps1'),
    (Join-Path $baseDirectory './README.md'),
    (Join-Path $baseDirectory './License.md'),
    (Join-Path $baseDirectory './sample.txt'),
    (Join-Path $baseDirectory './VSC-ExtensionSetup.psd1')
)
$ModuleCopy = @(
    (Join-Path $modulesDir './Checks.psm1'),
    (Join-Path $modulesDir './Colors.psm1'),
    (Join-Path $modulesDir './Extensions.psm1'),
    (Join-Path $modulesDir './Help.psm1')

)

Copy-FilesToTemp -Files $filesToCopy -Destination $tempDir


<#
 ================================ 
        Build & Archives      
 ================================ 
#>
# Create source directory and copy temp files
if (-not (Test-Path $outputSourceFile)) {
    New-Item -ItemType Directory -Path $outputSourceFile -Force | Out-Null
    Write-Host "[Info] $checkMark Created source directory: $outputSourceFile" -ForegroundColor Cyan
}



# Create .zip file
try {
    Add-Type -AssemblyName 'System.IO.Compression.FileSystem'
    [System.IO.Compression.ZipFile]::CreateFromDirectory($tempDir, $outputZipFile)
    Write-Host "[Info] $checkMark ZIP archive created: $outputZipFile" -ForegroundColor Cyan
}
catch {
    Write-Host "[Error] $errorMark Failed to create zip file: $_" -ForegroundColor Red
}


# Create .tar and .tar.gz files using tar command
try {
    tar -cvf $outputTarFile -C $tempDir . *> $null   # Redirect all output to $null
    tar -czvf $outputTarGzFile -C $baseDirectory 'VSC-ExtensionSetup.tar' *> $null   # Redirect all output to $null
    Write-Host "[Info] $checkMark TAR archives created: $outputTarFile, $outputTarGzFile" -ForegroundColor Cyan
}
catch {
    Write-Host "[Error] $errorMark Failed to create tar files: $_" -ForegroundColor Red
}

# Create .zip.gz file
try {
    $zipFileStream = [System.IO.File]::OpenRead($outputZipFile)
    $zipGzStream = [System.IO.Compression.GzipStream]::new(
        [System.IO.File]::Open($outputZipGzFile, [System.IO.FileMode]::Create),
        [System.IO.Compression.CompressionMode]::Compress
    )
    
    $buffer = New-Object byte[] 8192  # 8 KB buffer
    while (($bytesRead = $zipFileStream.Read($buffer, 0, $buffer.Length)) -gt 0) {
        $zipGzStream.Write($buffer, 0, $bytesRead)
    }

    $zipFileStream.Dispose()
    $zipGzStream.Dispose()
    Write-Host "[Info] $checkMark Compressed ZIP to ZIP.GZ: $outputZipGzFile" -ForegroundColor Cyan
}
catch {
    Write-Host "[Error] $errorMark Failed to create zip.gz file: $_" -ForegroundColor Red
}


<#
    ================================ 
          Compile the PS1 to EXE       
    ================================ 
#>
try {
    Invoke-PS2EXE -InputFile $inputScript `
        -OutputFile $outputExe `
        -Title "VSC Extension Setup" `
        -Description "This executable sets up Visual Studio Code extensions." `
        -Company "Quincy.M.Dack" `
        -Product "VSC Extension Setup Tool" `
        -Copyright "2024 © Quincy.M.Dack" `
        -Version "1.0.0"  *> $null   # Redirect all output to $null
    Write-Host "[Info] $checkMark Exe Build completed: $outputExe" -ForegroundColor Cyan
   
}
catch {
    Write-Host "[Error] $errorMark Failed to compile the script to exe: $_" -ForegroundColor Red
}


if (Test-Path $outputVSCProd) {
    Remove-Item $outputVSCProd -Recurse -Force
}

# Move tempDir to VSC-ExtensionSetup
Move-Item -Path $tempDir -Destination $outputVSCProd -Force

# Complete Source Copy
$TempModuleSource = Join-Path $outputSourceFile "./Modules"
Copy-FilesToTemp -Files $filesToCopy  -Destination $outputSourceFile -IsSilent $true
Copy-FilesToTemp -Files $modulesDir -Destination $outputSourceFile -IsSilent $true
Copy-FilesToTemp -Files $ModuleCopy -Destination $TempModuleSource -IsSilent $true

Write-Host "[Info] $checkMark Source Directory Completed: $outputSourceFile" -ForegroundColor Cyan

<#
    ============================== 
            Final Output             
    ============================== 
#>
Write-Host "[Info] $checkMark Build completed. Output files:
  `n $outputExe,
  `n $outputZipFile,
  `n $outputTarFile,
  `n $outputTarGzFile,
  `n $outputZipGzFile
" -ForegroundColor Green

