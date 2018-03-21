Set-StrictMode -Version Latest

# Module vars
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', 'ModulePath')]
$ModulePath = $PSScriptRoot

# Get public and private function definition files
$Public = @( Get-ChildItem $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )

# Dot source the files
foreach ($import in @($Public + $Private)) {
    try {
        . $import.FullName
    }
    catch {
        Write-Error "Failed to import function $($_.FullName): $_"
    }
}

# Export public functions
Export-ModuleMember -Function ($Public | Select-Object -ExpandProperty BaseName)
