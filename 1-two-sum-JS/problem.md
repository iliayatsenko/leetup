# 1. Two Sum

[https://leetcode.com/problems/two-sum/](https://leetcode.com/problems/two-sum/)

**Difficulty:** Easy

**Tags:**

- Array

- Hash Table


---

You are given an array of integers `nums` and an integer `target`,
return *indices of the two numbers such that they add up to `target`*.

You may assume that each input would have ***exactly* one solution**,
and you may not use the *same* element twice.

You can return the answer in any order.

**Example 1:**

    Input: nums = [2,7,11,15], target = 9
    Output: [0,1]
    Explanation: Because nums[0] + nums[1] == 9, we return [0, 1].

**Example 2:**

    Input: nums = [3,2,4], target = 6
    Output: [1,2]

**Example 3:**

    Input: nums = [3,3], target = 6
    Output: [0,1]

**Constraints:**

- `2 <= nums.length <= 10`^`4`^
- `-10`^`9`^` <= nums[i] <= 10`^`9`^
- `-10`^`9`^` <= target <= 10`^`9`^
- **Only one valid answer exists.**

**Follow-up:** Can you come up with an algorithm that is less than
`O(n`^`2`^`)` time complexity?


---

### Environment:`Node.js 22.14.0`.

Your code is run with `--harmony` flag, enabling [new ES6
features](http://node.green/){target="_blank"}.

[lodash.js@4.17.21](https://lodash.com){target="_blank"} library is
included by default.

You may use data structures from
[datastructures-js](https://datastructures-js.info/docs){target="_blank"}
library. Version info:

    "@datastructures-js/binary-search-tree": "5.4.0"
    "@datastructures-js/deque": "1.0.8"
    "@datastructures-js/graph": "5.3.1"
    "@datastructures-js/heap": "4.3.7"
    "@datastructures-js/linked-list": "6.1.4"
    "@datastructures-js/priority-queue": "6.3.5"
    "@datastructures-js/queue": "4.3.0"
    "@datastructures-js/set": "4.2.2"
    "@datastructures-js/stack": "3.1.6"
    "@datastructures-js/trie": "4.2.3"

For Binary Search Tree, Trie, and Graph, please import them manually
when you need to use them, as their names conflict with certain
problems.
