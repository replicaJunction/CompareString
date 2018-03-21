$ProjectRoot = Split-Path $PSScriptRoot -Parent
$ProjectName = Split-Path $ProjectRoot -Leaf

$sut = Join-Path -Path $ProjectRoot -ChildPath "$ProjectName\Private\Get-LevenshteinDistance.ps1"
. $sut

Describe 'Get-LevenshteinDistance' {
    $testCases = @(
        @{
            First  = ''
            Second = 'Test'
            Label1 = 'first'
            Label2 = 'second'
        },
        @{
            First  = 'Test'
            Second = ''
            Label1 = 'second'
            Label2 = 'first'
        }
    )
    It 'When the <Label1> string is empty, it returns the length of the <Label2> string' -TestCases $testCases {
        param($First, $Second)
        Get-LevenshteinDistance $First $Second | Should -Be 4
    }

    # This test case was taken from Wikipedia
    # https://en.wikipedia.org/wiki/Levenshtein_distance

    $testCases = @(
        @{
            First    = 'kitten'
            Second   = 'sitting'
            Expected = 3
        }
    )

    It 'Correctly identifies <First> and <Second> as <Expected>' -TestCases $testCases {
        param($First, $Second, $Expected)
        Get-LevenshteinDistance $First $Second | Should -Be $Expected
    }
}
