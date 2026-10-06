# 6. Zigzag Conversion

[https://leetcode.com/problems/zigzag-conversion/](https://leetcode.com/problems/zigzag-conversion/)

**Difficulty:** Medium

**Tags:**

- String


---

The string `"PAYPALISHIRING"` is written in a zigzag pattern on a given
number of rows like this: (you may want to display this pattern in a
fixed font for better legibility)

    P   A   H   N
    A P L S I I G
    Y   I   R

And then read line by line: `"PAHNAPLSIIGYIR"`

Write the code that will take a string and make this conversion given a
number of rows:

    string convert(string s, int numRows);

**Example 1:**

    Input: s = "PAYPALISHIRING", numRows = 3
    Output: "PAHNAPLSIIGYIR"

**Example 2:**

    Input: s = "PAYPALISHIRING", numRows = 4
    Output: "PINALSIGYAHRPI"
    Explanation:
    P     I    N
    A   L S  I G
    Y A   H R
    P     I

**Example 3:**

    Input: s = "A", numRows = 1
    Output: "A"

**Constraints:**

- `1 <= s.length <= 1000`
- `s` consists of English letters (lower-case and upper-case), `','` and
  `'.'`.
- `1 <= numRows <= 1000`


---

### Environment:`Go 1.23`

Support
[https://pkg.go.dev/github.com/emirpasic/gods@v1.18.1](https://pkg.go.dev/github.com/emirpasic/gods@v1.18.1){target="_blank"}
and
[https://pkg.go.dev/github.com/emirpasic/gods/v2@v2.0.0-alpha](https://pkg.go.dev/github.com/emirpasic/gods/v2@v2.0.0-alpha){target="_blank"}
library.
