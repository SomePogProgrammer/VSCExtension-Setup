# Set console output encoding to UTF-8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# --- // VSC-ExtensionSetup \ ---
<#
   Author: SomeProgrammer / SomePogProgrammer
   Repo: https://github.com/SomePogProgrammer/VSCExtension-Setup
   Description: Installs suggested Visual Studio Code extensions for developers, mainly software + web devs.
   Copyright 2024 ©, SomeProgrammer / SomePogProgrammer | Quincy M. Dack | ALL RIGHTS RESERVED ©
   This is free to use and distribute but may not be commercialized, nor can you claim it as your own.
#>

# Import Modules
Import-Module .\Modules\Colors.psm1
Import-Module .\Modules\Help.psm1
Import-Module .\Modules\Extensions.psm1
Import-Module .\Modules\Checks.psm1


# --- // Main Execution \ ---


# Define a hardcoded list of extensions (uncomment to use)
$hardcodedExtensions = @(
    "aaravb.chrome-extension-developer-tools",
    "bradlc.vscode-tailwindcss",
    "brandonfowler.exe-runner",
    "christian-kohler.npm-intellisense",
    "cirlorm.mobileview",
    "codesandbox-io.codesandbox-projects",
    "dbaeumer.vscode-eslint",
    "eamodio.gitlens",
    "emmanuelbeziat.vscode-great-icons",
    "esbenp.prettier-vscode",
    "fill-labs.dependi",
    "github.codespaces",
    "github.github-vscode-theme",
    "github.remotehub",
    "github.vscode-github-actions",
    "github.vscode-pull-request-github",
    "henoc.svgeditor",
    "jannisx11.batch-rename-extension",
    "johnpapa.vscode-peacock",
    "me-dutour-mathieu.vscode-github-actions",
    "mrmlnc.vscode-scss",
    "ms-azuretools.vscode-docker",
    "ms-python.debugpy",
    "ms-python.python",
    "ms-python.vscode-pylance",
    "ms-vscode-remote.remote-containers",
    "ms-vscode-remote.remote-ssh",
    "ms-vscode-remote.remote-ssh-edit",
    "ms-vscode-remote.remote-wsl",
    "ms-vscode.azure-repos",
    "ms-vscode.cmake-tools",
    "ms-vscode.live-server",
    "ms-vscode.powershell",
    "ms-vscode.remote-explorer",
    "ms-vscode.remote-repositories",
    "ms-vscode.remote-server",
    "ms-vscode.vscode-typescript-next",
    "ms-vsliveshare.vsliveshare",
    "nguyenngoclong.terminal-keeper",
    "nickcernis.github-cli-ui",
    "pkief.material-icon-theme",
    "pranaygp.vscode-css-peek",
    "prisma.prisma",
    "prisma.prisma-insider",
    "pucelle.vscode-css-navigation",
    "redhat.vscode-xml",
    "redhat.vscode-yaml",
    "ritwickdey.liveserver",
    "searking.preview-vscode",
    "sibiraj-s.vscode-scss-formatter",
    "sinclair.react-developer-tools",
    "zignd.html-css-class-completion"
)


function Start-InstallationProcess {
    param (
        [string]$extensionsFilePath
    )
    # Check for visual studio code command
    Read-Installed

    # Check if provided file exists and load extensions
    $extensionsFilePath = $args[0]

    if ([string]::IsNullOrEmpty($extensionsFilePath)) {
        # No file path provided, use hardcoded extensions
        $extensions = $hardcodedExtensions
    }
    else {
        # Load extensions from the specified file
        $extensions = Get-ExtensionsFromFile -filePath $extensionsFilePath
    }

    # Install extensions
    if (-not $extensions) {
        Write-Red "No extensions provided via file or hardcoded list. ❌ `n Aborting... `n `n  [ Aborted ]"
        exit 1
    }

    Install-Extensions -extensions $extensions

    Write-Host "[INFO] Check the logs above for a detailed report."
    Write-Green "[DONE] Successfully finished."
}

# Parse command line arguments
if ($args.Count -gt 0) {
    switch ($args[0]) {
        '--help' { Show-Help }
        '--list' { Show-PreHardcodedExtensions }
        default { Start-InstallationProcess $args[0] }
    }
} else {
    Start-InstallationProcess
}

