---
title: LeetCode 451. Sort Characters By Frequency (Medium)
author: Lynn
date: 2022-02-14 22:30:20
tags: ["LeetCode"]
---
Given a string s, sort it in decreasing order based on the frequency of the characters. The frequency of a character is the number of times it appears in the string.

Return the sorted string. If there are multiple answers, return any of them.

 Example:
 ```
 Input: s = "tree"
Output: "eert"
Explanation: 'e' appears twice while 'r' and 't' both appear once.
So 'e' must appear before both 'r' and 't'. Therefore "eetr" is also a valid answer.

Input: s = "cccaaa"
Output: "aaaccc"
Explanation: Both 'c' and 'a' appear three times, so both "cccaaa" and "aaaccc" are valid answers.
Note that "cacaca" is incorrect, as the same characters must be together.

Input: s = "Aabb"
Output: "bbAa"
Explanation: "bbaA" is also a valid answer, but "Aabb" is incorrect.
Note that 'A' and 'a' are treated as two different characters.
 ```
 <!--more-->
Constraints:
* 1 <= s.length <= 5 * 105
* s consists of uppercase and lowercase English letters and digits.

計算字串內個別字元的個數大小，再排序後回傳
```
public class Solution {
    public string FrequencySort(string s) {
            if (s == null || s.Length <= 1) 
            {
                return s;
            }
            var map = new Dictionary<char, int>();
            var cs = s.ToCharArray();
            //把裡面的值塞進Dictionary裡面統計
            for (int i = 0; i < cs.Length; i++)
            {
                if (map.ContainsKey(cs[i]))
                {
                    map[cs[i]]++;
                } else
                {
                    map.Add(cs[i], 1);
                }
            }
            //先依照出現次數排序
            var sort = map.OrderByDescending(x => x.Value);
            var result = new StringBuilder();
            //還原字串
            foreach (var item in sort)
            {
                for (int i = 0;i <item.Value;i++)
                {
                    result.Append(item.Key);
                }
            }
            return result.ToString();        
    }
}
```


###### tags: `LeetCode`