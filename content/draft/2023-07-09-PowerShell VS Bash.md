---
title: PowerShell VS Bash
author: Lynn
date: 2023-06-25
tags: ["PowerShell","Bash"]
---

<!--more-->



下載內容（等價於 curl）
Bash: curl http://example.com
PowerShell: Invoke-WebRequest -Uri http://example.com (別名：iwr http://example.com)

搜索檔案中的文字（等價於 grep）
Bash: grep "mytext" myfile.txt
PowerShell: Get-Content myfile.txt | Select-String "mytext" (別名：gc myfile.txt | sls "mytext")

變數指派
Bash: var="value"
PowerShell: $var = "value"

條件語句和迴圈語句
Bash: if [ $a -gt $b ]; then echo $a; fi 和 for i in {1..5}; do echo $i; done
PowerShell: if ($a -gt $b) { Write-Host $a } 和 for ($i=1; $i -le 5; $i++) { Write-Host $i }

列出目錄內的檔案和資料夾（等價於 ls）
Bash: ls
PowerShell: Get-ChildItem (別名：ls 或 dir)

切換目錄（等價於 cd）
Bash: cd directory
PowerShell: Set-Location directory (別名：cd directory 或 sl directory)

顯示當前工作目錄（等價於 pwd）
Bash: pwd
PowerShell: Get-Location (別名：pwd 或 gl)

創建目錄（等價於 mkdir）
Bash: mkdir directory
PowerShell: New-Item -ItemType Directory directory (別名：mkdir directory 或 ni directory)

刪除檔案（等價於 rm）
Bash: rm file
PowerShell: Remove-Item file (別名：rm file 或 ri file)

顯示檔案內容（等價於 cat）
Bash: cat file
PowerShell: Get-Content file (別名：cat file 或 gc file)

搜尋與替換（等價於 sed）
Bash: sed 's/search/replace/g' file
PowerShell: (Get-Content file).Replace("search", "replace") | Set-Content file

列出正在執行的程序（等價於 ps）
Bash: ps
PowerShell: Get-Process (別名：ps 或 gps)

殺掉一個程序（等價於 kill）
Bash: kill PID
PowerShell: Stop-Process -ID PID (別名：kill PID 或 spps PID)


印出環境變數（等價於 echo）
Bash: echo $PATH
PowerShell: Write-Host $env:PATH (別名：echo $env:PATH)

將輸出重定向到檔案
Bash: command > file
PowerShell: command | Out-File -FilePath file (別名：command > file)

在背景執行程序
Bash: command &
PowerShell: Start-Job { command }

檢視檔案的頭部或尾部內容（等價於 head 和 tail）
Bash: head file 或 tail file
PowerShell: Get-Content -Path file -First 10 或 Get-Content -Path file -Last 10 (別名： gc -Path file -First 10 或 gc -Path file -Last 10)

排序輸出或檔案內容（等價於 sort）
Bash: sort file
PowerShell: Get-Content -Path file | Sort-Object (別名：gc -Path file | sort)
統計字元、單詞、行數（等價於 wc）

Bash: wc file
PowerShell: 由於 PowerShell 沒有內建的 wc 等效命令，你需要自行組合命令來實現類似的功能，例如使用 Measure-Object 來計算行數，Get-Content file | Measure-Object -Line


查看歷史命令（等價於 history）
Bash: history
PowerShell: Get-History (別名：h)

搜尋歷史命令
Bash: history | grep "keyword"
PowerShell: Get-History | Select-String "keyword" (別名：h | sls "keyword")

計時（等價於 time）
Bash: time command
PowerShell: Measure-Command { command }
查找檔案（等價於 find）

Bash: find . -name 'file'
PowerShell: Get-ChildItem -Path . -Recurse -Filter 'file' (別名：ls -Recurse -Filter 'file')

列出檔案的權限和詳情（等價於 ls -l）
Bash: ls -l
PowerShell: Get-ChildItem -Path . | Format-List (別名：ls | fl)

複製檔案或資料夾（等價於 cp）
Bash: cp source destination
PowerShell: Copy-Item -Path source -Destination destination (別名：cp source destination)

移動或重命名檔案或資料夾（等價於 mv）
Bash: mv source destination
PowerShell: Move-Item -Path source -Destination destination (別名：mv source destination)

檢視檔案類型（等價於 file）
Bash: file file
PowerShell: Get-Item -Path file | Format-List * (別名：ls file | fl *)

列出環境變數
Bash: printenv
PowerShell: Get-ChildItem env: (別名：ls env:)

Reference:
* https://www.techbang.com/posts/106699-ill-get-it-after-the-rest-of-the-article-today-instead-of-c
* https://www.thurrott.com/windows/282471/microsoft-is-rewriting-parts-of-the-windows-kernel-in-rust
* https://learn.microsoft.com/zh-tw/windows/dev-environment/rust/setup?WT.mc_id=DT-MVP-4015686
* https://doc.rust-lang.org/book/