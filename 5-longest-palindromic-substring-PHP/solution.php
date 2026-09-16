<?php

class Solution {

    /**
     * @param String $s
     * @return String
     */
    function longestPalindrome($s) {
        $length = strlen($s);
        $start = 0;
        $maxLength = 1;

        for ($center = 0; $center < $length; $center++) {
            foreach ([[$center, $center], [$center, $center + 1]] as [$left, $right]) {
                while ($left >= 0 && $right < $length && $s[$left] === $s[$right]) {
                    $palindromeLength = $right - $left + 1;
                    if ($palindromeLength > $maxLength) {
                        $start = $left;
                        $maxLength = $palindromeLength;
                    }

                    $left--;
                    $right++;
                }
            }
        }

        return substr($s, $start, $maxLength);
    }
}
