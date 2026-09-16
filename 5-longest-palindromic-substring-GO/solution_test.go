package main

import "testing"

func TestLongestPalindromeExample1(t *testing.T) {
	got := longestPalindrome("babad")
	if got != "bab" {
		t.Errorf("longestPalindrome(\"babad\") = %q, want %q", got, "bab")
	}
}

func TestLongestPalindromeExample2(t *testing.T) {
	got := longestPalindrome("cbbd")
	if got != "bb" {
		t.Errorf("longestPalindrome(\"cbbd\") = %q, want %q", got, "bb")
	}
}
