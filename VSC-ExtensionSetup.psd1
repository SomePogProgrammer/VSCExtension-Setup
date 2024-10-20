@{
    # Version of the module
    ModuleVersion = '1.0.1'

    # Root module file
    RootModule = 'VSC-ExtensionSetup.ps1'
    
    # Module GUID | Unique Identifier
    GUID = '582503d8-97d9-4fe5-988d-11e07221ef28'

    # List of additional .psm1 modules to load
    NestedModules = @(
        'Modules/Colors.psm1',
        'Modules/Help.psm1',
        'Modules/Extensions.psm1',
        'Modules/Checks.psm1'
    )

    # Author of the module
    Author = 'SomePogProgrammer/SomeProgrammer (Quincy.M.Dack)'

    # Company or vendor information
    CompanyName = 'Quincy.M.Dack'

    # Description of the module
    Description = 'PowerShell module for installing bulk vsc extensions, by default the ones recommended for devs.'

    # Functions to export
    FunctionsToExport = @("VSC_ExtensionSetup")

    # External files to include in the module
    FileList = @(
        'Modules/Colors.psm1',
        'Modules/Help.psm1',
        'Modules/Extensions.psm1',
        'Modules/Checks.psm1',
        'VSC-ExtensionSetup.ps1'
    )

    # Required PowerShell version
    PowerShellVersion = '5.1'
    # File version information

    AliasesToExport = '*'

    # Private data (optional)
    PrivateData = @{
        PSData = @{
            # Tags for searching the module in repositories
            Tags = @('VSCode', 'Extensions', 'PowerShell', 'WebDeveloper')

            # License information (can be replaced with your specific license)
            LicenseUri = 'https://github.com/SomePogProgrammer/VSCExtension-Setup?tab=License-1-ov-file#'

            # Project URI or homepage
            ProjectUri = 'https://github.com/SomePogProgrammer/VSCExtension-Setup'

            # Release notes (optional)
            ReleaseNotes = 'Initial release of VSC-ExtensionSetup module.'
        }
    }
}

