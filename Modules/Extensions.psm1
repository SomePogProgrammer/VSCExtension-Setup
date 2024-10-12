<#
   Extensions Module
   Manages loading and installing extensions.
#>
$checkMark = [char]0x2705  # ✅
$crossMark = [char]0x274C  # ❌

function Show-PreHardcodedExtensions {
    # List all pre-hardcoded VS Code extensions
  

    Write-Host "Pre-Hardcoded Extensions:"
    Write-Host "
        [aaravb.chrome-extension-developer-tools](vscode:extension/aaravb.chrome-extension-developer-tools)
        [bradlc.vscode-tailwindcss](vscode:extension/bradlc.vscode-tailwindcss)
        [brandonfowler.exe-runner](vscode:extension/brandonfowler.exe-runner)
        [christian-kohler.npm-intellisense](vscode:extension/christian-kohler.npm-intellisense)
        [cirlorm.mobileview](vscode:extension/cirlorm.mobileview)
        [codesandbox-io.codesandbox-projects](vscode:extension/codesandbox-io.codesandbox-projects)
        [dbaeumer.vscode-eslint](vscode:extension/dbaeumer.vscode-eslint)
        [eamodio.gitlens](vscode:extension/eamodio.gitlens)
        [emmanuelbeziat.vscode-great-icons](vscode:extension/emmanuelbeziat.vscode-great-icons)
        [esbenp.prettier-vscode](vscode:extension/esbenp.prettier-vscode)
        [fill-labs.dependi](vscode:extension/fill-labs.dependi)
        [github.codespaces](vscode:extension/github.codespaces)
        [github.github-vscode-theme](vscode:extension/github.github-vscode-theme)
        [github.remotehub](vscode:extension/github.remotehub)
        [github.vscode-github-actions](vscode:extension/github.vscode-github-actions)
        [github.vscode-pull-request-github](vscode:extension/github.vscode-pull-request-github)
        [henoc.svgeditor](vscode:extension/henoc.svgeditor)
        [jannisx11.batch-rename-extension](vscode:extension/jannisx11.batch-rename-extension)
        [johnpapa.vscode-peacock](vscode:extension/johnpapa.vscode-peacock)
        [me-dutour-mathieu.vscode-github-actions](vscode:extension/me-dutour-mathieu.vscode-github-actions)
        [mrmlnc.vscode-scss](vscode:extension/mrmlnc.vscode-scss)
        [ms-azuretools.vscode-docker](vscode:extension/ms-azuretools.vscode-docker)
        [ms-python.debugpy](vscode:extension/ms-python.debugpy)
        [ms-python.python](vscode:extension/ms-python.python)
        [ms-python.vscode-pylance](vscode:extension/ms-python.vscode-pylance)
        [ms-vscode-remote.remote-containers](vscode:extension/ms-vscode-remote.remote-containers)
        [ms-vscode-remote.remote-ssh](vscode:extension/ms-vscode-remote.remote-ssh)
        [ms-vscode-remote.remote-ssh-edit](vscode:extension/ms-vscode-remote.remote-ssh-edit)
        [ms-vscode-remote.remote-wsl](vscode:extension/ms-vscode-remote.remote-wsl)
        [ms-vscode.azure-repos](vscode:extension/ms-vscode.azure-repos)
        [ms-vscode.cmake-tools](vscode:extension/ms-vscode.cmake-tools)
        [ms-vscode.live-server](vscode:extension/ms-vscode.live-server)
        [ms-vscode.powershell](vscode:extension/ms-vscode.powershell)
        [ms-vscode.remote-explorer](vscode:extension/ms-vscode.remote-explorer)
        [ms-vscode.remote-repositories](vscode:extension/ms-vscode.remote-repositories)
        [ms-vscode.remote-server](vscode:extension/ms-vscode.remote-server)
        [ms-vscode.vscode-typescript-next](vscode:extension/ms-vscode.vscode-typescript-next)
        [ms-vsliveshare.vsliveshare](vscode:extension/ms-vsliveshare.vsliveshare)
        [nguyenngoclong.terminal-keeper](vscode:extension/nguyenngoclong.terminal-keeper)
        [nickcernis.github-cli-ui](vscode:extension/nickcernis.github-cli-ui)
        [pkief.material-icon-theme](vscode:extension/pkief.material-icon-theme)
        [pranaygp.vscode-css-peek](vscode:extension/pranaygp.vscode-css-peek)
        [prisma.prisma](vscode:extension/prisma.prisma)
        [prisma.prisma-insider](vscode:extension/prisma.prisma-insider)
        [pucelle.vscode-css-navigation](vscode:extension/pucelle.vscode-css-navigation)
        [redhat.vscode-xml](vscode:extension/redhat.vscode-xml)
        [redhat.vscode-yaml](vscode:extension/redhat.vscode-yaml)
        [ritwickdey.liveserver](vscode:extension/ritwickdey.liveserver)
        [searking.preview-vscode](vscode:extension/searking.preview-vscode)
        [sibiraj-s.vscode-scss-formatter](vscode:extension/sibiraj-s.vscode-scss-formatter)
        [sinclair.react-developer-tools](vscode:extension/sinclair.react-developer-tools)
        [zignd.html-css-class-completion](vscode:extension/zignd.html-css-class-completion)"
   
}

# Function Inspired by: https://github.com/rmmgc/vscode-extensions-bulk-install
function Get-ExtensionsFromFile {
    param ([string]$filePath)
    
    $extensions = @()
    
    if (-not (Test-Path $filePath)) {
        Write-Red "File, on path $filePath, could not be found. `n Aborting... `n `n  [ Aborted ] "
        exit 1
    }

    if ($filePath -notlike "*.txt") {
        Write-Red "File, on path $filePath, does not have correct format.`n Aborting... `n `n  [ Aborted ]"
        Write-Host " Make sure that provided file has $(Write-Green '.txt') extension/format."
        exit 1
    }

    $content = Get-Content $filePath
    $lineNumber = 0

    foreach ($line in $content) {
        $lineNumber++
        $modifiedLine = $line -replace '[^\x20-\x7E]', ''

        if ($line -ne $modifiedLine) {
            Write-Yellow "Non-printable character found in line $lineNumber. Removed non-printable characters."
        }

        $extensions += $modifiedLine.Trim()
    }

    return $extensions
}

# Function also Inspired by: https://github.com/rmmgc/vscode-extensions-bulk-install
function Install-Extensions {
    param ([string[]]$extensions)
    
    $installedExtensions = code --list-extensions

    foreach ($extensionName in $extensions) {
        if ([string]::IsNullOrEmpty($extensionName)) {
            continue  # Skip empty lines
        }

        Write-Host " Working on $(Write-Green $extensionName) extension."

        if ($installedExtensions -contains $extensionName) {
            Write-Host "$checkMark Extension already installed. Skipping further steps. `n"
            continue
        }

        Write-Host "Running: code --install-extension $extensionName."
        code --install-extension $extensionName

        if ($LASTEXITCODE -eq 0) {
            Write-Green "$checkMark Extension installed successfully.`n"
        }
        else {
            Write-Red "$crossMark Extension installation failed."
            Write-Host "[INFO] Check the logs above to get more information about the error.`n"
        }
    }
}
