function Get-FirstDifferentChar {
    [CmdletBinding()]
    [OutputType([int])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [String] $S1,

        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [String] $S2
    )

    end {
        if ($S1 -eq $S2) {
            return -1
        }

        $shorter = $S1
        $longer = $S2

        if ($S1.Length -gt $S2.Length) {
            $shorter = $S2
            $longer = $S1
        }

        foreach ($i in 0..($shorter.Length - 1)) {
            if ($S1[$i] -ne $S2[$i]) {
                return $i
            }
        }

        # Don't need to handle the case where they are equal length and identical up to this point,
        # because then they are equal and handled by the first bit of this function.

        return $S1.Length
    }
}
