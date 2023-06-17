---
title: LeetCode 70. Climbing Stairs (Easy)
date: 2022-02-08 22:45:13
tags: ["LeetCode"]
---
You are climbing a staircase. It takes n steps to reach the top.

Each time you can either climb 1 or 2 steps. In how many distinct ways can you climb to the top?

Example :
```
Input: n = 2
Output: 2
Explanation: There are two ways to climb to the top.
1. 1 step + 1 step
2. 2 steps

Input: n = 3
Output: 3
Explanation: There are three ways to climb to the top.
1. 1 step + 1 step + 1 step
2. 1 step + 2 steps
3. 2 steps + 1 step
```
<!--more-->
題目的要求是算排列組合，給一個n階梯，一次只能踏 1 或 2步，算出所有的組合。
n = 1 , result = 1
n = 2 , result = 1 + 1
n = 3 , result = 2 + 1
n = 4 , result = 3 + 2
n = 5 , result = 5 + 3
發現公式是
f(n) = f(n-1) + f(n-2)
```
public class Solution {
    public int ClimbStairs(int n) {
            if (n == 1 || n==2)
            {
                return n;
            }
            int prev = 1;
            int cur = 2;
            for (int i = 3; i <= n; i++)
            {
                int temp = cur;
                cur = cur + prev;
                prev = temp;
            }
            return cur;
    }
}
```
![](https://i.imgur.com/DU7fAvZ.png)
