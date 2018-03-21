function Get-HammingDistance {
    [CmdletBinding()]
    [OutputType([int])]
    param(
        [Parameter(Mandatory)]
        [String] $S1,

        [Parameter(Mandatory)]
        [String] $S2
    )

    end {
        # https://en.wikipedia.org/wiki/Hamming_distance

        if ($S1.Length -ne $S2.Length) {
            Write-Warning "Strings [[ $S1 ]] and [[ $S2 ]] are different lengths. Hamming distance cannot be computed."
            return -1
        }

        $distance = 0
        foreach ($i in 0..($S1.Length - 1)) {
            if ($S1[$i] -ne $S2[$i]) {
                Write-Debug "Hamming distance: [[ $($S1[$i]) ]] != [[ $($S2[$i]) ]]"
                $distance += 1
            }
            else {
                Write-Debug "Hamming distance: [[ $($S1[$i]) ]] == [[ $($S2[$i]) ]]"
            }
        }

        return $distance
    }
}
