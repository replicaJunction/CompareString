---
external help file: CompareString-help.xml
Module Name: CompareString
online version:
schema: 2.0.0
---

# Compare-String

## SYNOPSIS
Compares the contents of two strings

## SYNTAX

```
Compare-String [-ReferenceString] <String[]> [-DifferenceString] <String> [-HammingDistance]
 [-LevenshteinDistance] [-LongestCommonSubsequence] [-LongestCommonSubstring] [<CommonParameters>]
```

## DESCRIPTION
Compares the contents of two string variables.

Similar to PowerShell's own Measure-Object cmdlet, by default, this function only provides one metric: FirstDifference, the index of the first different character between the two strings. Several parameters are available to provide extended analysis of the two strings, but these analytics are only run when requested to provide the quickest possible time.

## EXAMPLES

### Example 1
```powershell
PS C:\> Compare-String 'PowerShell' 'WindowsPowerShell'


ReferenceObject          : PowerShell
DifferenceString         : WindowsPowerShell
FirstDifference          : 0
HammingDistance          :
LevenshteinDistance      :
LongestCommonSubsequence :
LongestCommonSubstring   :
```

This example demonstrates basic usage of the function. Since the strings differ at index 0, the FirstDifference value is 0.

### Example 2
```powershell
PS C:\> Compare-String 'PowerShell' 'PowerShell'


ReferenceObject          : PowerShell
DifferenceString         : PowerShell
FirstDifference          : -1
HammingDistance          :
LevenshteinDistance      :
LongestCommonSubsequence :
LongestCommonSubstring   :
```

This example illustrates comparing two identical strings. The FirstDifference property is set to -1, which indicates that no differences are found (similar to the IndexOf() method of the String class, which returns -1 if the substring is not found).

### Example 3
```powershell
PS C:\> Compare-String 'PowerShell 5.1' 'WindowsPowerShell' -LongestCommonSubstring


ReferenceObject          : PowerShell 5.1
DifferenceString         : WindowsPowerShell
FirstDifference          : 0
HammingDistance          :
LevenshteinDistance      :
LongestCommonSubsequence :
LongestCommonSubstring   : PowerShell
```

This example demonstrates the use of the -LongestCommonSubstring parameter. The longest substring contained in both objects is "PowerShell." Note that the FirstDifference value is still provided.

## PARAMETERS

### -DifferenceString
The second string to be used for comparison.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -HammingDistance
Indicates that the function calculates the [Hamming distance](https://en.wikipedia.org/wiki/Hamming_distance) between the two strings. The Hamming distance is roughly the same as the number of different characters between the two strings.

Note that the Hamming distance can only be computed between two strings of identical length.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LevenshteinDistance
Indicates that the function calculates the [Levenshtein distance](https://en.wikipedia.org/wiki/Levenshtein_distance) between the two strings. The Levenshtein difference is the number of single-character edits that will change one string into the other.

For strings of the same length, the Levenshtein distance will be identical to the Hamming distance, but the former is much quicker to calculate. If strings are known to be the same length, use the Hamming distance instead.

Unlike the Hamming distance, however, the Levenshtein distance can be computed between strings of unequal length, as a character addition or subtraction can be counted as a single-character edit.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LongestCommonSubsequence
Indicates that the function calculates the [longest common subsequence](https://en.wikipedia.org/wiki/Longest_common_subsequence_problem) within the two strings.

This is similar to the longest common substring, but does not require that the characters be adjacent within the string.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LongestCommonSubstring
Indicates that the function calculates the [longest common substring](https://en.wikipedia.org/wiki/Longest_common_substring_problem) within the two strings. This is the longest substring that is contained within both strings.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReferenceString
The first string to be used for comparison.

If pipeline input is provided, each item in the pipeline will be compared against the value of DifferenceString.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String[]

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

[String metric](https://en.wikipedia.org/wiki/String_metric)

[Hamming distance](https://en.wikipedia.org/wiki/Hamming_distance)

[Levenshtein distance](https://en.wikipedia.org/wiki/Levenshtein_distance)

[Longest common subsequence problem](https://en.wikipedia.org/wiki/Longest_common_subsequence_problem)

[Longest common substring problem](https://en.wikipedia.org/wiki/Longest_common_substring_problem)