---
title: 搬家啦，從Hexo到Medium再到Hugo
date: 2023-06-17
author: Lynn
tags: ["Hugo"]
---

當初架設Hexo Blog實在是什麼都不懂，什麼都照抄，直到開始做了專題後就完全忘記這Blog了，但他還是好好的在Github Page活著 :laughing: 

後來重灌電腦後就花了一點時間把環境安裝好，結果下了Command新增文章，部屬也會一直出問題，雖然只能在Local部屬，我環境也復原了，而且我記得指令明明很單純QQ

<!--more-->
建立文章
```
 hexo new post {title}
```
產生靜態網頁 && Deploy
```
hexo g -d
```

也因為這樣就被放置了長達一年，直到前幾天為了研究 [reveal.js](https://github.com/hakimel/reveal.js/) 這簡報軟體，不小心把之前自己部屬在Github Page的Hexo Blog蓋掉了，雖然沒在寫了但我也不想要他變空白，氣氣氣氣氣氣

中間也是有改使用Medium，但那個發文方式真的不友善，尤其像我習慣使用HackMD寫markdown筆記，會需要先匯出成Gist，在從Medium的Import story去Import markdown，重點是經過了這兩層的轉換，每次都需要在額外大修改，真的是很麻煩。

![](https://hackmd.io/_uploads/SJjiS4sD2.jpg)

**不過這些都不是文章沒更新的原因，歸根究柢就是我懶哈哈哈哈哈**

工作也一段時間了，雖然還只是一年的小菜雞，但要改善上面提到Hexo的缺點並不困難，Hexo的問題可以用Github action來去處理問題，就可以讓他不需要相依在Local的環境。

Medium的話還的沒什麼想法，他光是匯入後排版就有問題了，唉

回到標題，會選擇Hugo單純只是~~星星比較多~~，開玩笑的，因為他是用Go寫的，我想要多看一點其他語言，不然Hexo是台灣人寫的，而且中文資源又多，JS現在也不是什麼困難的東西，香到不行哈哈，雖說Go編譯得比較快，但在Blog根本不用考慮這種東西。

![](https://hackmd.io/_uploads/rkqpLIjPh.png)

在研究的時候有發現一些.Net的Blog框架，默默的決定之後的Side Project可以寫個.NET的Blog Engine，不過前端苦手阿QQ


## 事前安裝

廢話說完了，接下來步驟希望自己以後不會重新跑一次XD

先安裝Hugo，有很多安裝方式
```
choco install hugo-extended (我選這個)
scoop install hugo-extended
winget install Hugo.Hugo.Extended
docker pull klakegg/hugo
```
再來就是確保你有安裝Git && Go
[Go Install](https://go.dev/doc/install)
[Git Install](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
確定安裝好之後繼續執行以下Command
```
go install -tags extended github.com/gohugoio/hugo@latest
```
結束之後確認版本，**這很重要**，如果安裝成功結果會出現版本號碼
```
hugo version
```
![](https://hackmd.io/_uploads/rJfSCEiD3.png)

## 開始建立Blog

首先直接建立個新網站
```
hugo new site my_first_site
```
切換到目錄
```
cd my_first_site
```
Git初始化
```
git init
```

再來就是選擇自己喜歡的主題啦，這部分一定是會很花時間的，可以慢慢挑
https://themes.gohugo.io/ 

我選擇的是 [Cleanwhite](https://themes.gohugo.io/themes/hugo-theme-cleanwhite/) 

接著可以選擇直接把他Clone下來改，但這樣假如主題的開發者有更新了，那要同步想必是非常的麻煩，所以我是使用git submodule的方式來同步。

```
git submodule add https://github.com/zhaohuabing/hugo-theme-cleanwhite.git themes/hugo-theme-cleanwhite
```
接下來Build看看，會把網站先build在memory裡面，可以直接從local看到結果。
-t 後面接的是自己的主題名稱
```
hugo serve -t  hugo-theme-cleanwhite
```
![](https://hackmd.io/_uploads/BkoGSSiD2.png)

不過這樣實在太麻煩了，所以接著可以更新一下hugo.toml這個config檔案，加入
```
theme = "hugo-theme-cleanwhite"
```
![](https://hackmd.io/_uploads/HkKvBriwn.png)
這樣就可以開心hugo serve了~~
接下來建立新文章
```
hugo new post/firstPost.md
```
執行後他會告訴你路徑在"content\post\"裡面，接著就可以編輯文章並看到文章囉
要注意的是如果有draft這屬性，更新時必須要下serve -D來讓他build的時候不要忽略draft的檔案
![](https://hackmd.io/_uploads/BkgfUSiv3.png)

打一打發現好像有點太長了，接下來的更新就發在第二篇吧。