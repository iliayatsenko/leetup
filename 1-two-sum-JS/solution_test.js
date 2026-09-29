const test = require('node:test');
const assert = require('node:assert/strict');
const solution = require('./solution');

const cases = [
  {
    name: 'Example 1',
    nums: [2, 7, 11, 15],
    target: 9,
    expected: [0, 1],
  },
  {
    name: 'Example 2',
    nums: [3, 2, 4],
    target: 6,
    expected: [1, 2],
  },
  {
    name: 'Example 3',
    nums: [3, 3],
    target: 6,
    expected: [0, 1],
  },
];

test('twoSum', async (t) => {
  for (const tt of cases) {
    await t.test(tt.name, () => {
      const result = solution.twoSum(tt.nums, tt.target);
      assert.deepEqual(
        new Set(result),
        new Set(tt.expected),
        `twoSum(${JSON.stringify(tt.nums)}, ${tt.target}): got ${JSON.stringify(result)}, expected ${JSON.stringify(tt.expected)}`
      );
    });
  }
});
