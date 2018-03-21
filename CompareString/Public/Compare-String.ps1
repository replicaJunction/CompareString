function Compare-String {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,
            Position = 0,
            ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [String[]] $ReferenceString,

        [Parameter(Mandatory,
            Position = 1)]
        [ValidateNotNullOrEmpty()]
        [String] $DifferenceString,

        [Parameter()]
        [Switch] $HammingDistance,

        [Parameter()]
        [Switch] $LevenshteinDistance,

        [Parameter()]
        [Switch] $LongestCommonSubsequence,

        [Parameter()]
        [Switch] $LongestCommonSubstring
    )

    process {
        foreach ($str in $ReferenceString) {
            $result = [PSCustomObject] @{
                PSTypeName               = 'CompareStringResult'
                ReferenceString          = $str
                DifferenceString         = $DifferenceString
                FirstDifference          = $null
                HammingDistance          = $null
                LevenshteinDistance      = $null
                LongestCommonSubsequence = $null
                LongestCommonSubstring   = $null
            }

            $result.FirstDifference = Get-FirstDifferentChar $str $DifferenceString

            if ($HammingDistance) {
                $result.HammingDistance = Get-HammingDistance $str $DifferenceString
            }

            if ($LongestCommonSubsequence) {
                $result.longestCommonSubsequence = Get-LongestCommonSubsequence $str $DifferenceString
            }

            if ($LongestCommonSubstring) {
                $result.longestCommonSubstring = Get-LongestCommonSubstring $str $DifferenceString
            }

            if ($LevenshteinDistance) {
                $result.LevenshteinDistance = Get-LevenshteinDistance $str $DifferenceString
            }

            return $result
        }
    }
}
