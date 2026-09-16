<?php

require_once __DIR__ . '/../solution.php';

use PHPUnit\Framework\TestCase;

class SolutionTest extends TestCase
{
    private Solution $solution;

    protected function setUp(): void
    {
        $this->solution = new Solution();
    }

    public function testExample1(): void
    {
        $actual = $this->solution->longestPalindrome('babad');

        $this->assertContains($actual, ['bab', 'aba'], "Expected 'bab' or 'aba', got '$actual'");
    }

    public function testExample2(): void
    {
        $actual = $this->solution->longestPalindrome('cbbd');

        $this->assertSame('bb', $actual, "Expected 'bb', got '$actual'");
    }
}
