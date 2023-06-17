---
title: LeetCode 771. Jewels and Stones (Easy)
date: 2022-02-12 21:31:07
tags: ["LeetCode"]
categories: ["LeetCode"]
---
You're given strings jewels representing the types of stones that are jewels, and stones representing the stones you have. Each character in stones is a type of stone you have. You want to know how many of the stones you have are also jewels.

Letters are case sensitive, so "a" is considered a different type of stone from "A".


Example :
```
Input: jewels = "aA", stones = "aAAbbbb"
Output: 3

Input: jewels = "z", stones = "ZZ"
Output: 0
```

<!--more-->

Constraints:

* 1 <= jewels.length, stones.length <= 50
* jewels and stones consist of only English letters.
* All the characters of jewels are unique.

這題偏簡單，搜尋一次stones裡面的所有字元，如果jewels裡有包含的話count++
可能還有其他解法會更快
```
public class Solution {
    public int NumJewelsInStones(string jewels, string stones) {
            int count = 0;
            for (int i = 0; i<stones.Length;i++)
            {
                if (jewels.IndexOf(stones[i])!= -1)
                {
                    count++;
                }
            }
            return count;
    }
}

```
![](https://i.imgur.com/5RRrt6v.png)

```
public class Solution {
    public int NumJewelsInStones(string jewels, string stones) {
            if (jewels == null || jewels == string.Empty || stones == null || stones == string.Empty)
                return 0;
            int res = 0;
            HashSet<char> set = new HashSet<char>();

            foreach (var c in jewels)
                set.Add(c);

            foreach (var c in stones)
                if (set.Contains(c))
                    res++;

            return res;
    }
```
![](https://i.imgur.com/hUfvEpZ.png)
原本以為用雜湊之後快很多，結果發現不是XDD
重點是在提早跳出這段而已，看來能盡早return真的很重要
```
            if (jewels.Length ==0 || stones.Length ==0)
                return 0;
```

```
public class Solution {
    public int NumJewelsInStones(string jewels, string stones) {
            if (jewels.Length ==0 || stones.Length ==0)
                return 0;
            int count = 0;
            for (int i = 0; i<stones.Length;i++)
            {
                if (jewels.IndexOf(stones[i])!= -1)
                {
                    count++;
                }
            }
            return count;
    }
}
```
![](https://i.imgur.com/e9jydbM.png)
