package main

import "testing"

func TestExample1(t *testing.T) {
	s := "babad"
	result := longestPalindrome(s)
	if result != "bab" && result != "aba" {
		t.Errorf("expected 'bab' or 'aba', got '%s'", result)
	}
}

func TestExample2(t *testing.T) {
	s := "cbbd"
	result := longestPalindrome(s)
	if result != "bb" {
		t.Errorf("expected 'bb', got '%s'", result)
	}
}
