$ProjectRoot = Split-Path $PSScriptRoot -Parent
$ProjectName = Split-Path $ProjectRoot -Leaf

$sut = Join-Path -Path $ProjectRoot -ChildPath "$ProjectName\Private\Get-LongestCommonSubsequence.ps1"
. $sut

Describe 'Get-LongestCommonSubsequence' {
    $testCases = @(
        @{
            First    = 'XMJYAUZ'
            Second   = 'MZJAWXU'
            Expected = 'MJAU'
        }
    )

    It 'Correctly identifies <First> and <Second> as <Expected>' -TestCases $testCases {
        param($First, $Second, $Expected)
        Get-LongestCommonSubsequence $First $Second | Should -Be $Expected
    }
}
