

##############################################################################
# DO NOT MODIFY THIS FILE!  Modify build.settings.ps1 instead.
##############################################################################

# This is an Invoke-Build build script.

$ProjectRoot = Split-Path $PSScriptRoot -Parent
$ProjectName = Split-Path $ProjectRoot -Leaf

# task . Init, Analyze, Test, Build, Install
task . Init, Analyze, Test, Build

# Load Settings file
$settingsFile = "$PSScriptRoot\build.settings.ps1"
if (-not (Test-Path $settingsFile)) {
    throw "Unable to locate settings file at path $settingsFile"
}
. "$settingsFile"

# Init other variables based on Settings

# Path where the compiled module will be placed
$OutputPath = "$ArtifactPath\$ProjectName"

########################################################################

task InstallDependencies {
    if (-not (Get-Module PSDepend -ErrorAction SilentlyContinue) -and -not (Import-Module PSDepend)) {
        Install-Module -Name PSDepend -Scope CurrentUser -Force
    }

    assert (Get-Module PSDepend) ("PSDepend module could not be found.")

    Invoke-PSDepend -Path "$PSScriptRoot\Requirements.psd1" -Install -Force
}

########################################################################

task Init {
    # https://github.com/RamblingCookieMonster/BuildHelpers/issues/10
    # Set-BuildEnvironment -Path $ProjectRoot -BuildOutput $OutputPath -Force
    . Set-BuildVariable -Path $ProjectRoot -Scope Script

    Write-Verbose "Build system details:`n$(Get-Variable 'BH*' | Out-String)"

    if (-not (Test-Path $ArtifactPath)) {
        New-Item -Path $ArtifactPath -ItemType Directory -Force | Out-Null
    }
}

task Clean Init, {
    if (Test-Path -Path $OutputPath) {
        Remove-Item -Path "$OutputPath/*" -Recurse -Force
    }

    New-Item -Path $OutputPath -ItemType Directory -Force | Out-Null
}

#region Analyze
########################################################################

task Analyze Init, {
    if (-not $EnableAnalyze) {
        Write-Verbose "Script analysis is not enabled."
        return
    }

    $scriptAnalyzerParams = @{
        Path     = "$ModuleRoot"
        Recurse  = $true
        Settings = "$ProjectRoot\PSScriptAnalyzerSettings.psd1"
        Verbose  = $false
    }

    Write-Verbose "Parameters for Invoke-ScriptAnalyzer:`n$($scriptAnalyzerParams | Out-String)"
    $scriptAnalysis = Invoke-ScriptAnalyzer @scriptAnalyzerParams
    $scriptAnalysis | ConvertTo-Json | Out-File "$ArtifactPath\ScriptAnalysis.json" -Force

    # We want to show all rules, but only fail the build if there are
    # errors or warnings
    if (-not $scriptAnalysis) {
        Write-Verbose "Invoke-ScriptAnalyzer returned no hits - everything is good!"
    }
    else {
        $scriptAnalysis | Format-Table -AutoSize
        $terminatingItems = $scriptAnalysis | Where-Object {'Error', 'Warning' -contains $_.Severity}
        if ($terminatingItems) {
            if (@($terminatingItems).Count -gt 1) {
                $msg = "PSScriptAnalyzer found $($terminatingItems.Count) failing rules."
            }
            else {
                $msg = 'PSScriptAnalyzer found 1 failing rule.'
            }

            throw $msg
        }
    }
}

########################################################################
#endregion

#region Test
########################################################################

# Test task is split in two so that if tasks fail, the engine can produce
# a test results file before failing the build
task Test Init, RunTests, ConfirmTestsPassed

task RunTests Init, {
    $pesterParams = @{
        Path         = $TestPath
        PassThru     = $true
        OutputFile   = $PesterXmlResultFile
        OutputFormat = "NUnitXml"
    }

    if ($CodeCoverageMinimum -and $CodeCoverageMinimum -gt 0) {
        $pesterParams['CodeCoverage'] = @(Get-ChildItem -Path $ModuleRoot -Filter '*.ps1' -Recurse | Select-Object -ExpandProperty FullName)
    }

    Write-Verbose "Parameters for Invoke-Pester:`n$($pesterParams | Out-String)"
    $testResults = Invoke-Pester @pesterParams
    $testResults | ConvertTo-Json -Depth 5 | Out-File $PesterJsonResultFile -Force

    # If running in a CI environment, publish tests results here
    if ($BHBuildEnvironment -eq 'AppVeyor') {
        Write-Verbose "Publishing Pester results"
        Add-TestResultToAppveyor $PesterXmlResultFile
    }
}

task ConfirmTestsPassed Init, RunTests, {
    [xml] $xml = Get-Content -Path $PesterXmlResultFile -Raw

    # Fail build if any unit tests failed
    $failures = $xml.'test-results'.failures
    assert ($failures -eq 0) ('Failed unit tests: {0}' -f $failures)

    # Fail build if code coverage is under required amount
    if (-not $CodeCoverageMinimum -or $CodeCoverageMinimum -le 0) {
        Write-Verbose "Code coverage is not enabled"
    }
    else {
        $json = Get-Content -Path $PesterJsonResultFile -Raw | ConvertFrom-Json

        $overallCoverage = [Math]::Round(($json.CodeCoverage.NumberOfCommandsExecuted /
                $json.CodeCoverage.NumberOfCommandsAnalyzed), 4)

        assert ($overallCoverage -gt $CodeCoverageMinimum) ('Build requirement of {0:P2} code coverage was not met (analyzed coverage: {1:P2}' -f
            $overallCoverage, $CodeCoverageMinimum)
    }
}

########################################################################
#endregion

#region Build
########################################################################

task Build Init, UpdateManifestVersion, CopyFiles, UpdateManifestFunctions

task UpdateManifestVersion Init, {
    # Get manifest contents and look for the current build number
    $manifestContent = (Get-Content $BHPSModuleManifest -Raw).Trim()
    if ($manifestContent -notmatch '(?<=ModuleVersion\s+=\s+'')(?<ModuleVersion>.*)(?='')') {
        throw "Module version was not found in manifest file $BHPSModuleManifest"
    }
    $script:ModuleVersion = [Version] ($Matches.ModuleVersion)

    # For writing, we need to reference variables with the script: prefix.
    # For reading, this prefix isn't necessary.

    if ($BHBuildNumber -gt 0) {
        Write-Verbose "Using build number $BHBuildNumber from CI"
        $script:BuildNumber = $BuildNumber
    }
    else {
        $script:BuildNumber = $ModuleVersion.Revision + 1
        Write-Verbose "Using build number $BuildNumber from existing manifest"
    }

    $newVersion = New-Object -TypeName System.Version -ArgumentList $ModuleVersion.Major, $ModuleVersion.Minor, $ModuleVersion.Build, $BuildNumber

    Write-Verbose "Updating module manifest version from $ModuleVersion to $newVersion"
    Update-Metadata -Path $BHPSModuleManifest -PropertyName ModuleVersion -Value $newVersion
}

task CopyFiles Init, Clean, {
    # Copy items to release folder
    Get-ChildItem $ModuleRoot | Copy-Item -Destination $OutputPath -Recurse -Force
}

task UpdateManifestFunctions Init, CopyFiles, {
    $outputManifestFile = Join-Path $OutputPath "$ProjectName.psd1"
    Set-ModuleFunctions -Name $outputManifestFile
}

########################################################################
#endregion

#region platyPS - Build Help
########################################################################

task CreateHelp {
    Import-Module -Name "$ModuleRoot\$ProjectName.psd1" -Force
    $splat = @{
        Module         = $ProjectName
        OutputFolder   = "$ProjectRoot\docs\en-US"
        Locale         = "en-US"
        WithModulePage = $true
        Force          = $true
    }

    New-MarkdownHelp @splat
}

task BuildHelp Init, Build, {
    if (-not $EnableBuildHelp) {
        Write-Verbose "Building help via platyPS is not enabled."
        return
    }

    Import-Module -Name "$OutputPath\$ProjectName.psd1"
    $languages = Get-ChildItem "$ProjectRoot\docs" | Select-Object -ExpandProperty Name
    foreach ($lang in $languages) {
        Write-Verbose "Generating help for language [[ $lang ]]"
        Update-MarkdownHelp -Path "$ProjectRoot\docs\$lang" | Out-Null
        New-ExternalHelp -Path "$ProjectRoot\docs\$lang" -OutputPath "$OutputPath\$lang" -Force | Out-Null
    }
}

########################################################################
#endregion

#region Install / Publish
########################################################################

task Install Init, Build, Analyze, Test, BuildHelp, {
    foreach ($path in $InstallPaths) {
        $thisModulePath = Join-Path -Path $path -ChildPath $ProjectName
        if (Test-Path $thisModulePath) {
            Remove-Item -Path $thisModulePath -Recurse -Force
        }
        New-Item -Path $thisModulePath -ItemType Directory | Out-Null

        Write-Verbose "Installing to path [[ $path ]]"

        Get-ChildItem $OutputPath | Copy-Item -Destination $thisModulePath -Recurse -Force
    }
}

task Publish Init, Build, Analyze, Test, {
    if (-not $PublishRepos) {
        Write-Verbose "No repositories were defined in the `$PublishRepos variable in settings file [[ $settingsFile ]]."
        Write-Verbose "To publish the module, define one or more repositories here."
    }

    foreach ($repo in $PublishRepos) {
        try {
            Publish-Module -Path $OutputPath -Repository $repo -ErrorAction Stop
        }
        catch {
            Write-Error "Failed to publish to repo ${repo}: $_"
        }
    }
}
########################################################################
#endregion
