package main

import (
	"testing"
)

// Helper function to create a linked list from an array
func createList(arr []int) *ListNode {
	if len(arr) == 0 {
		return nil
	}
	head := &ListNode{Val: arr[0]}
	current := head
	for i := 1; i < len(arr); i++ {
		current.Next = &ListNode{Val: arr[i]}
		current = current.Next
	}
	return head
}

// Helper function to convert a linked list to an array for easy comparison
func listToArray(l *ListNode) []int {
	var result []int
	for l != nil {
		result = append(result, l.Val)
		l = l.Next
	}
	return result
}

func TestAddTwoNumbers(t *testing.T) {
	tests := []struct {
		name     string
		l1       []int
		l2       []int
		expected []int
	}{
		{
			name:     "Example 1",
			l1:       []int{2, 4, 3},
			l2:       []int{5, 6, 4},
			expected: []int{7, 0, 8},
		},
		{
			name:     "Example 2",
			l1:       []int{0},
			l2:       []int{0},
			expected: []int{0},
		},
		{
			name:     "Example 3",
			l1:       []int{9, 9, 9, 9, 9, 9, 9},
			l2:       []int{9, 9, 9, 9},
			expected: []int{8, 9, 9, 9, 0, 0, 0, 1},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			l1 := createList(tt.l1)
			l2 := createList(tt.l2)
			got := addTwoNumbers(l1, l2)
			gotArr := listToArray(got)

			if len(gotArr) != len(tt.expected) {
				t.Errorf("addTwoNumbers() returned list of length %d, want %d", len(gotArr), len(tt.expected))
				return
			}

			for i := 0; i < len(gotArr); i++ {
				if gotArr[i] != tt.expected[i] {
					t.Errorf("addTwoNumbers() = %v, want %v", gotArr, tt.expected)
					return
				}
			}
		})
	}
}
