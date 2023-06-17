---
title: LeetCode 136. Single Number (Easy)
date: 2022-02-09 23:15:05
tags: ["LeetCode"]
categories: ["LeetCode"]
---
Given a non-empty array of integers nums, every element appears twice except for one. Find that single one.

You must implement a solution with a linear runtime complexity and use only constant extra space.

Example:
```
Input: nums = [2,2,1]
Output: 1

Input: [4,1,2,1,2]
Output: 4
```

<!--more-->

找出陣列中只出現過一次的數字，這題直覺性的應該會使用Directory，首先判斷Key存不存在，如果存在value + 1，不存在的話把數字新增至Key裡面並且給予值 1，最後判斷Directory裡面Value等於1的值，回傳Key就好了。

```
public class Solution {
    public int SingleNumber(int[] nums) {
            Dictionary<int, int> dic = new Dictionary<int, int> { };
            for (int i = 0; i < nums.Length; i++)
            {
                if (dic.ContainsKey(nums[i]))
                {
                    dic[nums[i]]++;
                }else
                {
                    dic.Add(nums[i], 1);
                }
            }

            if (dic.ContainsValue(1))
            {
                return dic.FirstOrDefault(x => x.Value == 1).Key;
            }
            else
            {
                return 0;
            }
    }
}
```