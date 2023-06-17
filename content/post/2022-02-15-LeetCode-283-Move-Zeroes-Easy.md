---
title: LeetCode 283. Move Zeroes (Easy)
date: 2022-02-15 23:38:17
tags: ["LeetCode"]
---
Given an integer array nums, move all 0's to the end of it while maintaining the relative order of the non-zero elements.

Note that you must do this in-place without making a copy of the array.

Example :
```
Input: nums = [0,1,0,3,12]
Output: [1,3,12,0,0]

Input: nums = [0]
Output: [0]
```
Constraints:
* 1 <= nums.length <= 104
* -231 <= nums[i] <= 231 - 1

Follow up: Could you minimize the total number of operations done?

<!--more-->

這題目感覺也是偏簡單，最後我用的步驟跟其他人比起來多一個迴圈XD

```
public class Solution {
    public void MoveZeroes(int[] nums) {
            int zero = 0;
            int index = 0;
            for (int i = 0; i < nums.Length; i++)
            {

                if (nums[i] != 0)
                {
                    nums[index] = nums[i];
                    index++;

                }
                else { zero++; }
            }
            for (int i = 0; i < zero; i++)
            {
                nums[index] = 0;
                index++;
            }
    }
}
```
看到覺得很佩服的寫法
```
public static void MoveZeros(int[] nums)
{
	if (nums == null || nums.Length <= 1)
		return;

	int curr = 0;
	int next = 1;

	while (next <= nums.Length - 1)
	{
		if (nums[curr] == 0)
		{
			if (nums[next] == 0)
			{
				next++;
				continue;
			}
			else
			{
				nums[curr] = nums[next];
				nums[next] = 0;
			}
		}
		curr++;
		next++;
	}
}
```