<?php

require_once __DIR__ . '/../solution.php';

use PHPUnit\Framework\TestCase;

class SolutionTest extends TestCase
{
    private $solution;

    protected function setUp(): void
    {
        $this->solution = new Solution();
    }

    public function testExample1(): void
    {
        $nums = [2, 7, 11, 15];
        $target = 9;
        $expected = [0, 1];

        $result = $this->solution->twoSum($nums, $target);

        sort($result);
        sort($expected);
        $this->assertEquals($expected, $result);
    }

    public function testExample2(): void
    {
        $nums = [3, 2, 4];
        $target = 6;
        $expected = [1, 2];

        $result = $this->solution->twoSum($nums, $target);

        sort($result);
        sort($expected);
        $this->assertEquals($expected, $result);
    }

    public function testExample3(): void
    {
        $nums = [3, 3];
        $target = 6;
        $expected = [0, 1];

        $result = $this->solution->twoSum($nums, $target);

        sort($result);
        sort($expected);
        $this->assertEquals($expected, $result);
    }
}