package main

import "testing"

func TestConvert(t *testing.T) {
	tests := []struct {
		name   string
		s      string
		numRows int
		want   string
	}{
		{
			name:    "Example 1",
			s:       "PAYPALISHIRING",
			numRows: 3,
			want:    "PAHNAPLSIIGYIR",
		},
		{
			name:    "Example 2",
			s:       "PAYPALISHIRING",
			numRows: 4,
			want:    "PINALSIGYAHRPI",
		},
		{
			name:    "Example 3",
			s:       "A",
			numRows: 1,
			want:    "A",
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got := convert(tt.s, tt.numRows)
			if got != tt.want {
				t.Errorf("convert(%q, %d) = %q, want %q", tt.s, tt.numRows, got, tt.want)
			}
		})
	}
}
