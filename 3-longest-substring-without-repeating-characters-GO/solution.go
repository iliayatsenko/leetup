package main

func lengthOfLongestSubstring(s string) int {
	if len(s) == 0 {
		return 0
	}

	seen := make(map[rune]bool)
	maxLengthWithoutDups := 1
	curLengthWithoutDups := 1

OuterLoop:
	for baseIdx, baseChar := range s {
		seen[baseChar] = true
		for _, char := range s[baseIdx+1:] {
			if _, ok := seen[char]; ok {
				if curLengthWithoutDups > maxLengthWithoutDups {
					maxLengthWithoutDups = curLengthWithoutDups
				}
				seen = make(map[rune]bool)
				curLengthWithoutDups = 1
				continue OuterLoop
			}

			curLengthWithoutDups++
			seen[char] = true
			if curLengthWithoutDups > maxLengthWithoutDups {
				maxLengthWithoutDups = curLengthWithoutDups
			}
		}
	}

	return maxLengthWithoutDups
}
