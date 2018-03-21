$ProjectRoot = Split-Path $PSScriptRoot -Parent
$ProjectName = Split-Path $ProjectRoot -Leaf

$ModuleFile = Join-Path -Path $ProjectRoot -ChildPath "$ProjectName\$ProjectName.psd1"
Remove-Module -Name $ProjectName -Force -ErrorAction SilentlyContinue
Import-Module $ModuleFile

InModuleScope $ProjectName {
    Describe 'Compare-String' {
        Mock Get-FirstDifferentChar { 1 }
        Mock Get-HammingDistance { 2 }
        Mock Get-LevenshteinDistance { 3 }
        Mock Get-LongestCommonSubsequence { 4 }
        Mock Get-LongestCommonSubstring { 5 }

        Context 'Basic behavior' {
            $result = Compare-String 'a' 'b'

            It 'Only calculates the first different character when no switches are provided' {
                $result | Should -Not -BeNullOrEmpty
                $result.ReferenceString | Should -Be 'a'
                $result.DifferenceString | Should -Be 'b'
                $result.FirstDifference | Should -Be 1
                $result.HammingDistance | Should -Be $null -Because '-HammingDistance was not provided'
                $result.LevenshteinDistance | Should -Be $null -Because '-LevenshteinDistance was not provided'
                $result.LongestCommonSubsequence | Should -Be $null -Because '-LongestCommonSubsequence was not provided'
                $result.LongestCommonSubstring | Should -Be $null -Because '-LongestCommonSubstring was not provided'
            }

            It 'Uses helper function Get-FirstDifferentChar to calculate the first different character' {
                Assert-MockCalled Get-FirstDifferentChar -Scope Context -Exactly -Times 1
            }
        }

        Context 'Additional measurements' {
            $testCases = @(
                @{
                    Name           = 'Hamming distance'
                    ParamName      = 'HammingDistance'
                    Property       = 'HammingDistance'
                    Value          = 2
                    HelperFunction = 'Get-HammingDistance'
                },
                @{
                    Name           = 'Levenshtein distance'
                    ParamName      = 'LevenshteinDistance'
                    Property       = 'LevenshteinDistance'
                    Value          = 3
                    HelperFunction = 'Get-LevenshteinDistance'
                },
                @{
                    Name           = 'Longest common subsequence'
                    ParamName      = 'LongestCommonSubsequence'
                    Property       = 'LongestCommonSubsequence'
                    Value          = 4
                    HelperFunction = 'Get-LongestCommonSubsequence'
                },
                @{
                    Name           = 'Longest common substring'
                    ParamName      = 'LongestCommonSubstring'
                    Property       = 'LongestCommonSubstring'
                    Value          = 5
                    HelperFunction = 'Get-LongestCommonSubstring'
                }
            )

            It 'Calculates <Name> using a helper function when the <ParamName> switch is provided' -TestCases $testCases {
                param($ParamName, $Property, $Value, $HelperFunction)

                $splat = @{
                    ReferenceString  = 'a'
                    DifferenceString = 'b'
                }
                $splat[$ParamName] = $true

                $result = Compare-String @splat

                $result.$Property | Should -Be $Value -Because "$ParamName mock value is $Value"
                Assert-MockCalled $HelperFunction -Scope It -Exactly -Times 1
            }
        }
    }
}
