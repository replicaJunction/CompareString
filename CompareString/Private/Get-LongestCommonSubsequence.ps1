function Get-LongestCommonSubsequence {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [String] $S1,

        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [String] $S2
    )

    begin {
        # https://en.wikipedia.org/wiki/Longest_common_subsequence_problem

        # This solution uses the "dynamic programming solution" found on Wikipedia.
        function lcs_lengthTable([string] $S1, [string] $S2) {
            [int[][]] $c = New-Object -TypeName 'int[][]' -ArgumentList @(($S1.Length + 1), ($S2.Length + 1))

            foreach ($i in 0..$S1.Length) {
                $c[$i][0] = 0
            }

            foreach ($j in 0..$S2.Length) {
                $c[0][$j] = 0
            }

            foreach ($i in 1..$S1.Length) {
                foreach ($j in 1..$S2.Length) {
                    if ($S1[$i - 1] -eq $S2[$j - 1]) {
                        $c[$i][$j] = $c[$i - 1][$j - 1] + 1
                    }
                    else {
                        $c[$i][$j] = [Math]::Max($c[$i][$j - 1], $c[$i - 1][$j])
                    }
                }
            }

            return $c
        }

        function lcs_backtrack([int[][]] $c, [string] $S1, [string] $S2, [int] $i, [int] $j) {
            if ($i -eq 0 -or $j -eq 0) {
                return ''
            }

            if ($S1[$i - 1] -eq $S2[$j - 1]) {
                return (lcs_backtrack $c $S1 $S2 ($i - 1) ($j - 1)) + $S1[$i - 1]
            }

            if ($c[$i][$j - 1] -gt $c[$i - 1][$j]) {
                return lcs_backtrack $c $S1 $S2 $i ($j - 1)
            }
            else {
                return lcs_backtrack $c $S1 $S2 ($i - 1) $j
            }
        }
    }

    end {
        $c = lcs_lengthTable $S1 $S2
        return lcs_backtrack $c $S1 $S2 $S1.Length $S2.Length
    }
}
