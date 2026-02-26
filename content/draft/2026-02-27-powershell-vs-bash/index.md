---
title: PowerShell vs Bash：我在 Windows/Linux 來回切換的指令對照筆記
author: Lynn
date: 2026-02-27
tags: ["PowerShell", "Bash", "CLI"]
---

最近我在 Windows 跟 Linux 的環境來回切，最常卡住的不是觀念，是手指肌肉記憶。明明想做同一件事，結果指令名字完全不一樣。這篇我把自己最常用的一批指令整理成對照表，順便補上我實際踩過的坑。

<!--more-->

## 為什麼我會整理這份對照

我一開始以為只要記 `ls/cd/cat` 幾個常用指令就夠了。結果真的在專案裡用起來，才發現查文字、看程序、背景執行、取代文字這些才是每天會碰到的事。

而且 PowerShell 的核心是「物件管線」，Bash 多數時候是「文字管線」。這個差異如果沒先有心理準備，很容易寫出看起來能跑、實際上會炸的腳本。

## 先講核心差異（避免一開始就踩坑）

- Bash：大多處理純文字輸出，工具間靠字串串接
- PowerShell：輸出是 .NET 物件，後續命令可直接吃屬性

我以前把 Bash 的習慣直接搬到 PowerShell，結果在 `grep/sed/awk` 這類情境一直卡住。後來改成「先判斷現在處理的是文字還是物件」，腳本穩很多。

## 常用指令對照（我最常用的 15 組）

| 情境 | Bash | PowerShell |
|---|---|---|
| 列出檔案 | `ls` | `Get-ChildItem` (`ls`) |
| 切換目錄 | `cd dir` | `Set-Location dir` (`cd`) |
| 顯示目前路徑 | `pwd` | `Get-Location` (`pwd`) |
| 看檔案內容 | `cat file` | `Get-Content file` (`cat`) |
| 搜尋文字 | `grep "text" file` | `Select-String "text" file` |
| 下載 URL | `curl https://...` | `Invoke-WebRequest -Uri https://...` |
| 建資料夾 | `mkdir logs` | `New-Item -ItemType Directory logs` |
| 刪檔案 | `rm app.log` | `Remove-Item app.log` |
| 複製檔案 | `cp a.txt b.txt` | `Copy-Item a.txt b.txt` |
| 移動/改名 | `mv a b` | `Move-Item a b` |
| 查看程序 | `ps` | `Get-Process` |
| 終止程序 | `kill 1234` | `Stop-Process -Id 1234` |
| 查歷史指令 | `history` | `Get-History` |
| 計時執行 | `time cmd` | `Measure-Command { cmd }` |
| 找檔案 | `find . -name '*.log'` | `Get-ChildItem -Recurse -Filter *.log` |

## 程式碼範例：同一件事在 Bash 與 PowerShell 的寫法

這段示範「找出 log 裡面含 ERROR 的行，統計數量」。

```bash
# Bash
count=$(grep -R "ERROR" ./logs | wc -l)
echo "ERROR count: $count"
```

```powershell
# PowerShell
$count = Select-String -Path ./logs/* -Pattern "ERROR" -SimpleMatch | Measure-Object
Write-Host "ERROR count: $($count.Count)"
```

我自己的做法是：如果要快速串工具，Bash 直覺又快；如果後面要再做欄位處理、格式化輸出，PowerShell 會比較穩。

## 我踩過的一個坑：把 sed 習慣硬搬到 PowerShell

一開始我在 PowerShell 直接找「一行取代全部文字」的 Bash 心智模型，結果處理換行跟編碼一直怪怪的。後來改成先 `Get-Content`，再用字串或 Regex 操作，最後 `Set-Content` 寫回去，問題才消失。

短句版：不要硬搬。

## 那到底怎麼選？

- 你主要在 Linux/macOS 做部署、自動化：Bash 會更順手
- 你主要在 Windows、生態偏 .NET：PowerShell 優勢很明顯
- 需要跨平台：我會把「核心邏輯」寫在應用程式，腳本只做薄薄一層 glue

懶人包：
- 快速文字處理與系統指令串接 → Bash
- 需要物件操作、和 .NET/Windows 深整合 → PowerShell
- 團隊同時用兩邊 → 保留一份對照表，降低切換成本

Reference:
- https://learn.microsoft.com/powershell/
- https://learn.microsoft.com/powershell/module/microsoft.powershell.utility/select-string
- https://www.gnu.org/software/bash/manual/bash.html
