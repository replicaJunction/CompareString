$ProjectRoot = Split-Path $PSScriptRoot -Parent
$ProjectName = Split-Path $ProjectRoot -Leaf

$sut = Join-Path -Path $ProjectRoot -ChildPath "$ProjectName\Private\Get-HammingDistance.ps1"
. $sut

Describe 'Get-HammingDistance' {
    Mock Write-Warning

    It 'When strings of different lengths are provided, it returns -1 and writes a warning message' {
        Get-HammingDistance 'test' 'longer' | Should -Be -1 -Because '-1 represents inability to compute'
        Assert-MockCalled Write-Warning -Scope It
    }

    # These test cases were taken from Wikipedia
    # https://en.wikipedia.org/wiki/Hamming_distance

    $testCases = @(
        @{
            First    = 'karolin'
            Second   = 'kathrin'
            Expected = 3
        },
        @{
            First    = 'karolin'
            Second   = 'kerstin'
            Expected = 3
        },
        @{
            First    = '1011101'
            Second   = '1001001'
            Expected = 2
        },
        @{
            First    = '2173896'
            Second   = '2233796'
            Expected = 3
        }
    )

    It 'Correctly identifies <First> and <Second> as <Expected>' -TestCases $testCases {
        param($First, $Second, $Expected)
        Get-HammingDistance $First $Second | Should -Be $Expected
    }
}
