$ProjectRoot = Split-Path $PSScriptRoot -Parent
$ProjectName = Split-Path $ProjectRoot -Leaf

$sut = Join-Path -Path $ProjectRoot -ChildPath "$ProjectName\Private\Get-LongestCommonSubstring.ps1"
. $sut

Describe 'Get-LongestCommonSubstring' {
    $testCases = @(
        @{
            First  = ''
            Second = 'Test'
            Label  = 'first'
        },
        @{
            First  = 'Test'
            Second = ''
            Label  = 'second'
        }
    )
    It 'When the <Label1> string is empty, it returns null' -TestCases $testCases {
        param($First, $Second)
        Get-LongestCommonSubstring $First $Second | Should -BeNullOrEmpty
    }

    $testCases = @(
        @{
            First    = 'Couch'
            Second   = 'ouch'
            Expected = 'ouch'
        },
        @{
            First    = 'The quick brown fox jumped over the lazy dog'
            Second   = "The slow brown fox couldn't quite make it over."
            Expected = ' brown fox '
        },
        @{
            First    = 'A shorter example'
            Second   = 'ter extra'
            Expected = 'ter ex'
        }
    )

    It 'Correctly identifies <First> and <Second> as <Expected>' -TestCases $testCases {
        param($First, $Second, $Expected)
        Get-LongestCommonSubstring $First $Second | Should -Be $Expected
    }
}
