function Get-LevenshteinDistance {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [String] $S1,

        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [String] $S2
    )

    end {
        # https://en.wikipedia.org/wiki/Levenshtein_distance

        # This is not the most efficient implementation of this algorithm. Complexity is at least
        # O(n^2), where n is the length of either string.

        if (-not $S1) {
            return $S2.Length
        }

        if (-not $S2) {
            return $S1.Length
        }

        $distance = 0

        if ($S1[-1] -eq $S2[-1]) {
            $distance = 0
        }
        else {
            $distance = 1
        }

        $s1Modified = $S1.Substring(0, $S1.Length - 1)
        $s2Modified = $S2.Substring(0, $S2.Length - 1)

        $d1 = (Get-LevenshteinDistance $s1Modified $S2) + 1
        $d2 = (Get-LevenshteinDistance $S1 $s2Modified) + 1
        $d3 = (Get-LevenshteinDistance $s1Modified $s2Modified) + $distance

        return [Math]::Min([Math]::Min($d1, $d2), $d3)
    }
}
