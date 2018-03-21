$ProjectRoot = Split-Path $PSScriptRoot -Parent
$ProjectName = Split-Path $ProjectRoot -Leaf

$sut = Join-Path -Path $ProjectRoot -ChildPath "$ProjectName\Private\Get-FirstDifferentChar.ps1"
. $sut

Describe 'Get-FirstDifferentChar' {
    It 'When two identical strings are provided, it returns -1' {
        Get-FirstDifferentChar 'test' 'test' | Should -Be -1 -Because '-1 represents identical strings'
    }

    $testCases = @(
        @{
            First    = 'Foo'
            Second   = 'Bar'
            Expected = 0
        },
        @{
            First    = '12345'
            Second   = '12354'
            Expected = 3
        },
        @{
            First    = 'String'
            Second   = 'String with more characters'
            Expected = 6
        },
        @{
            First    = 'Empty string test'
            Second   = ''
            Expected = 0
        }
    )

    It 'Correctly identifies <First> and <Second> as <Expected>' -TestCases $testCases {
        param($First, $Second, $Expected)
        Get-FirstDifferentChar $First $Second | Should -Be $Expected
    }
}
