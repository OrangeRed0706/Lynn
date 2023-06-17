---
title: LeetCode 1. Two Sum (Easy)
author: Lynn
date: 2022-02-06 12:11:12
tags: ["LeetCode"]
---

https://leetcode.com/problems/two-sum/ 
題目的要求是給予一個int陣列和目標值，回傳目標值是陣列中哪兩個索引中加起來的。

Example :
```
Input: nums = [2,7,11,15], target = 9
Output: [0,1]
Explanation: Because nums[0] + nums[1] == 9, we return [0, 1].
```

想了想可以直接用兩個For迴圈暴力解掉，考慮到複雜度的問題這邊改用Dictinary的方式解題，Dictionary是由Key和Value組成，但是Key是不能重複的。

我自己覺得這題的關鍵點在 left = target - num[i] ; 這一行

<!-- more-->
```
public class Solution {
    public int[] TwoSum(int[] nums, int target) {
            //宣告Dictionary temp 由兩個int組合
            Dictionary<int, int> temp = new Dictionary<int, int>();
            for (int i = 0; i < nums.Length; i++)
            {
                //把target的值減陣列裡面的元素的值只派給left
                int left = target - nums[i];
                //假如Dictionary裡面有left值，return回去兩值的索引值
                if (temp.ContainsKey(left))
                {
                    return new int[] { temp[left], i };
                }
                //如果temp裡面不存在nums裡的值，temp加入(key(值)、value(索引值))
                if (!temp.ContainsKey(nums[i]))
                {
                    temp.Add(nums[i], i);
                }
            }
            return null;
    }
}
```

###### tags: `LeetCode`
