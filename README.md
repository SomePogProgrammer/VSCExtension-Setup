# VSC-ExtensionSetup

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
.\Main.ps1                     # Uses hardcoded extensions
.\Main.ps1 <ExtensionsFilePath>  # Uses extensions from the specified file
