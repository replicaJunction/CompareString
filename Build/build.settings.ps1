

###############################################################################
# Customize these properties and tasks for your module.
###############################################################################

# These variables are already available:
#
# $ProjectRoot - Root directory of the project workspace
# $ProjectName - Name of this project. Should be the same as the module name.

# Source directory for the module files
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$ModuleRoot = "$ProjectRoot\$ProjectName"

# Directory where build artifacts will be placed, including the "compiled" module and report files.
# Note - if you change this, you may want to change the path in the .gitignore file as well.
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$ArtifactPath = "$ProjectRoot\Artifacts"

# Path(s) where the module will be installed when running the Install task.
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$InstallPaths = @(
    # "$env:USERPROFILE\Documents\WindowsPowerShell\Modules"
    # "C:\PowerShell\Modules"
)


####################
# Script analysis
####################

# Set to false to disable use of PSScriptAnalyzer to analyze for best practices.
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$EnableAnalyze = $true


####################
# Pester settings
####################

# Root directory where tests are found
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$TestPath = "$ProjectRoot\Tests"

# Pester output file, in NUnitXml format
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$PesterXmlResultFile = "$ArtifactPath\PesterResults.xml"

# Pester output file, in JSON format. This will contain code coverage specs.
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$PesterJsonResultFile = "$ArtifactPath\PesterResults.json"

# Minimm acceptable code coverage percentage. Set to 0 to disable checking
# code coverage.
# This should be expressed as a decimal - 0.12 for 12%, 0.89 for 89%, etc.
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$CodeCoverageMinimum = 0.00


####################
# platyPS settings
####################

# Set to false to disable use of platyPS for building help documents.
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$EnableBuildHelp = $true


#####################
# Publish settings
#####################

# Repository(/ies) where the module should be published.
# If set to null or an empty array, the publish step will be skipped.
# Note that these repos must already exist on the system - this script
# will not create them.
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$PublishRepos = @()

########################################################################

# To define a code hook, use -Before or -After and specify the task
# name. You can add a task that runs before or after any named task
# in the build script.

# task PreInstall -Before Install {
#     Write-Host 'Pre-install task!'
# }

# task PostInstall -After Install {
#     Write-Host 'Post-install task!'
# }
