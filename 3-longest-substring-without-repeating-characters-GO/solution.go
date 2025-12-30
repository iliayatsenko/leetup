package main

func lengthOfLongestSubstring(s string) int {
	substrings := make([]string, 0)

	for i, char := range s {

	seen := make(map[rune]bool)
	maxLengthWithoutDups := 0
	curLengthWithoutDups := 0

	for _, char := range s {
		if _, ok := seen[char]; ok {
			if curLengthWithoutDups > maxLengthWithoutDups {
				maxLengthWithoutDups = curLengthWithoutDups
			}
			seen = make(map[rune]bool)
			seen[char] = true
			curLengthWithoutDups = 1
			continue
		}

		curLengthWithoutDups++
		seen[char] = true
		if curLengthWithoutDups > maxLengthWithoutDups {
			maxLengthWithoutDups = curLengthWithoutDups
		}
	}

	return maxLengthWithoutDups
}
