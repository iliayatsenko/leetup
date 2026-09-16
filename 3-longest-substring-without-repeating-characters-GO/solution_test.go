package main

import (
	"testing"
)

func TestLengthOfLongestSubstring(t *testing.T) {
	tests := []struct {
		name     string
		s        string
		expected int
	}{
		{
			name:     "Example 1",
			s:        "abcabcbb",
			expected: 3,
		},
		{
			name:     "Example 2",
			s:        "bbbbb",
			expected: 1,
		},
		{
			name:     "Example 3",
			s:        "pwwkew",
			expected: 3,
		},
		{
			name:     "Empty string",
			s:        "",
			expected: 0,
		},
		{
			name:     "Single character",
			s:        "a",
			expected: 1,
		},
		{
			name:     "Duplicate in the middle",
			s:        "abba",
			expected: 2,
		},
		{
			name:     "Window restarts after duplicate",
			s:        "dvdf",
			expected: 3,
		},
		{
			name:     "Longest window after repeated prefix",
			s:        "tmmzuxt",
			expected: 5,
		},
		{
			name:     "Space is a character",
			s:        "a b a",
			expected: 3,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got := lengthOfLongestSubstring(tt.s)
			if got != tt.expected {
				t.Errorf("lengthOfLongestSubstring(%q) = %d, want %d", tt.s, got, tt.expected)
			}
		})
	}
}
