---
title: LeetCode 15. 3Sum (Medium)
date: 2022-02-11 20:18:53
tags: ["LeetCode"]
categories:
  - - LeetCode
---
Given an integer array nums, return all the triplets [nums[i], nums[j], nums[k]] such that i != j, i != k, and j != k, and nums[i] + nums[j] + nums[k] == 0.

Notice that the solution set must not contain duplicate triplets.

Example :
```
Input: nums = [-1,0,1,2,-1,-4]
Output: [[-1,-1,2],[-1,0,1]]

Input: nums = []
Output: []


Input: nums = [0]
Output: []
```

 <!--more-->
 
 
 
 ```
 public class Solution 
{
    public IList<IList<int>> ThreeSum(int[] nums)
    {
            IList<IList<int>> result = new List<IList<int>>();

            
            if (nums == null || nums.Length < 3)
            {
                return result;
            }
            
            Array.Sort(nums);

            for (int first = 0; first < nums.Length - 2; first++)
            {
                如果first是重複值就跳下一輪
                if (first > 0 && nums[first] == nums[first - 1])
                {
                    continue;
                }
                int second = first + 1;
                int third = nums.Length - 1;
                
                while (second < third)
                {
                    //second重複的話一樣跳下一輪
                    if (nums[second] == nums[second - 1] && second > first + 1)
                    {
                        second++;
                        continue;
                    }
                    int sum = nums[first] + nums[second] + nums[third];
                    if (sum == 0)
                    {
                        result.Add(new List<int>()
                        {
                            nums[first],nums[second],nums[third]
                        });
                        second++;
                        third--;
                    }
                    else if (sum < 0)
                    {
                        second++;
                    }
                    else
                    {
                        third--;
                    }
                }
            }
            return result;
    }
}

 ```
 ![](https://i.imgur.com/s1AiVbJ.png)