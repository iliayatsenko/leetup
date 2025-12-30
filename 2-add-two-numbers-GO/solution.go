package main

type ListNode struct {
	Val  int
	Next *ListNode
}

func addTwoNumbers(l1 *ListNode, l2 *ListNode) *ListNode {
	var carry int
	var addNodes func(l1, l2 *ListNode) *ListNode

	addNodes = func(l1, l2 *ListNode) *ListNode {
		result := &ListNode{}

		var l1Val, l2Val int
		if l1 != nil {
			l1Val = l1.Val
		} else {
			l1Val = 0
		}
		if l2 != nil {
			l2Val = l2.Val
		} else {
			l2Val = 0
		}

		val := l1Val + l2Val + carry

		if val >= 10 {
			carry = 1
			result.Val = val - 10
		} else {
			carry = 0
			result.Val = val
		}

		var l1Next, l2Next *ListNode
		if l1 != nil {
			l1Next = l1.Next
		} else {
			l1Next = nil
		}
		if l2 != nil {
			l2Next = l2.Next
		} else {
			l2Next = nil
		}

		if l1Next != nil || l2Next != nil || carry == 1 {
			result.Next = addNodes(
				l1Next,
				l2Next,
			)
		}

		return result
	}

	return addNodes(l1, l2)
}
