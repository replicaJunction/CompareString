function Get-LongestCommonSubstring {
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

    end {
        # https://en.wikipedia.org/wiki/Longest_common_substring_problem

        if (-not $S1) {
            Write-Verbose "Reference string [[ $S1 ]] is null or empty."
            return $null
        }

        if (-not $S2) {
            Write-Verbose "Difference string [[ $S2 ]] is null or empty."
            return $null
        }

        [int[][]] $l = New-Object -TypeName 'int[][]' -ArgumentList @($S1.Length, $S2.Length)
        $maxLength = 0
        $lastSubstring = 0
        $sb = New-Object -TypeName 'System.Text.StringBuilder'

        foreach ($i in 0..($S1.Length - 1)) {
            foreach ($j in 0..($S2.Length - 1)) {
                if ($S1[$i] -ne $S2[$j]) {
                    $l[$i][$j] = 0
                }
                else {
                    if ($i -eq 0 -or $j -eq 0) {
                        $l[$i][$j] = 1
                    }
                    else {
                        $l[$i][$j] = 1 + $l[$i - 1][$j - 1]
                    }

                    if ($l[$i][$j] -gt $maxLength) {
                        # We found a longer substring than the one we were tracking

                        $maxLength = $l[$i][$j]
                        $thisSubstring = $i - $l[$i][$j] + 1
                        if ($lastSubstring -eq $thisSubstring) {
                            # "New" longest substring is the same as the old one, but with another character added
                            [void] $sb.Append($S1[$i])
                            Write-Debug "Adding to existing longest substring index $i (current value [[ $sb ]])"
                        }
                        else {
                            # New longest substring is completely different
                            $lastSubstring = $thisSubstring
                            [void] $sb.Clear()
                            [void] $sb.Append(($S1.Substring($lastSubstring, ($i + 1) - $lastSubstring)))
                            Write-Debug "Found new longest substring (current value [[ $sb ]])"
                        }
                    }
                }
            }
        }

        return $sb.ToString()
    }
}
