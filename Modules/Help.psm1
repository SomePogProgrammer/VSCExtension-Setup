<# 
# Help module for VSC-ExtensionSetup
# Provides usage information for the script
#>

function Show-Help {
    $helpMessage = @"
Bulk install Visual Studio Code extensions.

Usage:

  .\Main.ps1                     # Uses suggested extensions
  .\Main.ps1 <ExtensionsFilePath>  # Uses extensions from the specified file (overrides suggestion/default)
        ---------------------------
        Format is: 
            [author.extensionName]
        Example: extensions.txt
            bradlc.vscode-tailwindcss
            brandonfowler.exe-runner
            christian-kohler.npm-intellisense
            ...

Commands:

  --help                        Display this help message
  --list                        List all pre-hardcoded extensions
  <ExtensionsFilePath>         Path to a .txt file containing a list of extensions

Examples:

  .\Main.ps1                              # Installs hardcoded extensions
  .\Main.ps1 C:\path\to\file.txt         # Installs extensions from a specified file
  .\Main.ps1 --list                       # Lists all pre-hardcoded extensions

More Information:

  Preparation of Extensions File:
    - Create a .txt file with one extension per line.
    - Ensure there are no non-printable characters.

"@
    Write-Host $helpMessage -ForegroundColor DarkGray
}

