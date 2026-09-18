<?php

require_once __DIR__ . '/solution.php';

use PHPUnit\Framework\TestCase;

// PHPUnit resolves the test class from the file name, so it has to stay solution_test
class solution_test extends TestCase
{
    private function isPalindrome($s) {
        return $s === strrev($s);
    }

    public function testExample1() {
        $solution = new Solution();
        $result = $solution->longestPalindrome("babad");
        
        $this->assertTrue(
            $this->isPalindrome($result),
            "Result '$result' is not a palindrome"
        );
        $this->assertEquals(
            3,
            strlen($result),
            "Expected length 3, got " . strlen($result)
        );
        $this->assertStringContainsString(
            $result,
            "babad",
            "Result '$result' is not a substring of 'babad'"
        );
    }

    public function testExample2() {
        $solution = new Solution();
        $result = $solution->longestPalindrome("cbbd");
        
        $this->assertEquals(
            "bb",
            $result,
            "Expected 'bb', got '$result'"
        );
    }
}
