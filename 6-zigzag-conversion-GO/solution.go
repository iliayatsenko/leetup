package main

func convert(s string, numRows int) string {
	zigzag := make([][]byte, numRows)
	for rowIdx := range zigzag {
		zigzag[rowIdx] = make([]byte, len(s))
	}

	direction := "down"
	i, j := 0, 0

	for charIdx := 0; charIdx < len(s); charIdx++ {
		zigzag[i][j] = s[charIdx]
		if direction == "down" {
			if i < numRows-1 {
				i++
			} else {
				direction = "up"
				j++
				i--
			}
		} else {
			if i == 0 {
				i++
				direction = "down"
			} else {
				i--
				j++
			}
		}
	}

	var result []byte
	for i := 0; i < len(zigzag); i++ {
		for j := 0; j < len(zigzag[i]); j++ {
			if zigzag[i][j] != 0 {
				result = append(result, zigzag[i][j])
			}
		}
	}

	return string(result)
}
