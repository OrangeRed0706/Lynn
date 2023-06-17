---
title: LeetCode 20. Valid Parentheses (Easy)
author: Lynn
date: 2022-02-07 20:41:48
tags: ["LeetCode"]
---
Given a string s containing just the characters '(', ')', '{', '}', '[' and ']', determine if the input string is valid.

An input string is valid if:

Open brackets must be closed by the same type of brackets.
Open brackets must be closed in the correct order.
<!--more-->


Example :

```
Input: "()"
Output: true

Input: s = "()[]{}"
Output: true

Input: s = "(]"
Output: false
```
題目的要求是輸入一個字串，裡面的括號是成對的話回傳true沒有的話回傳false

這邊就使用到Stack了，Stack可以當作是一個集合，裡面的資料是後進先出。
[MSDN Stack類別](https://docs.microsoft.com/zh-tw/dotnet/api/system.collections.stack?view=net-6.0)


```
public class Solution {
    public bool IsValid(string s) {
            //宣告一個Dictionary，裡面新增括號
          Dictionary<char, char> dic = new Dictionary<char, char>();
            dic.Add('}', '{');
            dic.Add(']', '[');
            dic.Add(')', '(');
            //如果字串長度不是成對的直接return false
            if (s.Length % 2 == 1)
                return false;
            //宣告一個stack裡面放字元
            var stack = new Stack<char>();
            //遍歷每個字串每個字元
            for (int i = 0; i < s.Length; i++)
            {
                char c = s[i];
                //如果c的字元是dic value裡的左括號，新增對應的右括號進去
                if (dic.ContainsValue(c))
                {
                    stack.Push(c);
                }
                else
                {
                    //如果stack都完全沒東西return false
                    if (stack.Count == 0)
                    {
                        return false;
                    }
                    //如果stack最後進來的值跟c(右括號對右括號代表成對)
                    if (stack.Peek() == dic[c])
                    {
                        //移除最後進來的值
                        stack.Pop();
                    }else return false;
                    
                }
            }
            return stack.Count == 0;
    }
}
```
