<?php

require_once __DIR__ . '/solution.php';

use PHPUnit\Framework\TestCase;

// PHPUnit resolves the test class from the file name, so it has to stay solution_test
class solution_test extends TestCase
{
    /**
     * @dataProvider provideCases
     */
    public function testTwoSum($nums, $target, $expected) {
        $solution = new Solution();
        $result = $solution->twoSum($nums, $target);
        
        $this->assertEquals($expected, $result, 
            sprintf("Input: nums = %s, target = %d; Expected %s, got %s",
                json_encode($nums),
                $target,
                json_encode($expected),
                json_encode($result)
            )
        );
    }

    public static function provideCases() {
        return [
            'Example 1' => [[2, 7, 11, 15], 9, [0, 1]],
            'Example 2' => [[3, 2, 4], 6, [1, 2]],
            'Example 3' => [[3, 3], 6, [0, 1]],
        ];
    }
}
