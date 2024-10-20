# VSC-ExtensionSetup

*Note, this Readme file was partialy created with ChatGPT (I got lazy 🤣), so if there are any issues or something was unclear, then feel free to contact me via my buisness email, and I'll do my best to fix them.*

VSC-ExtensionSetup is a PowerShell script designed to bulk install Visual Studio Code extensions for developers, particularly those focused on software and web development. This tool simplifies the process of setting up a development environment by automating the installation of recommended extensions.

## Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Commands](#commands)
- [Creating an Extensions File](#creating-an-extensions-file)
- [Help](#help)
- [License](#license)

## Features

- **Bulk Install**: Install multiple extensions at once, either from a hardcoded list or from a specified text file.
- **List Extensions**: Easily view the list of pre-hardcoded extensions.
- **User-Friendly**: Simple commands and structured output make it easy to use.

## Requirements

- PowerShell (version 5.1 or later)
- Visual Studio Code

## Installation

1. Clone this repository or download the ZIP file.
2. Extract the files if downloaded as a ZIP.
3. Open PowerShell and navigate to the extracted directory.
4. Run the following command to install required extensions (if any additional setup is needed, it will be mentioned in future updates).

## Usage

To run the script, you can use the following commands:

```powershell
VSC-ExtensionSetup                       # Uses suggested extensions
VSC-ExtensionSetup <ExtensionsFilePath>  # Uses extensions from the specified file (overrides suggestion/default)
    ---------------------------
     Format is: 
        [author.extensionName]
     Example: extensions.txt
        bradlc.vscode-tailwindcss
        brandonfowler.exe-runner
        christian-kohler.npm-intellisense
        ...
```
## Commands
```powershell
 --help                        Display this help message
 --list                        List all pre-hardcoded extensions
  <ExtensionsFilePath>         Path to a .txt file containing a list of extensions
```

# Creating an Extensions File

If you want to just bulk install other extensions and use this for that, that's okay!

**To create a custom extensions file:**

 - Create a new text file (e.g., extensions.txt).
 - Add one extension ID per line, formatted as follows:
 ```txt
    author.extensionName
    # Example
    bradlc.vscode-tailwindcss
 ```
 *A sample.txt file is in the repo for further example*

*If you want to add onto the extensions, you can also create an extension file.*

Including this file will override the default ⚠️

To avoid that:
 Either:
    - Run the command without args first, then add a file path. (recommended)
    or
    - Use the --list command and add it manually to your file.


# Help

You can use the `--help` command as follows:
```powershell
    command --help
```

If you want to know the default extensions you can do:
```powershell
    command --list 
```


*Still don't understand? Contact me at my [buisness email](mailto:quincy.m.dack@gmail.com). (Please ensure the email subject has this module name in it.)*

# License
This project is licensed under an edited MIT License. You are free to use and modify the code (not sell it). For any inquiries, feel free to contact the author.
(Refer to the project's liscense for full terms)
---------------

For any additional information, issues, or feature requests, please open an issue on the GitHub repository.


Stuck, report something privately, or want to reach out to me? Email me on my buisness [buisness email](mailto:quincy.m.dack@gmail.com)
