---
title: Proxy基本介紹 - 正向代理與反向代理
date: 2022-11-30 00:00:00
tags: ["Network"]
---

正向代理(forward proxy)

代理這個詞有點抽象，用現實的比喻就像，我們(Client)透過班代(Proxy)去跟老師說話，班代是我們的正向代理
![](https://i.imgur.com/PTgibRB.png)

這樣有什麼好處呢？

<!--more-->
1. 隱藏Clinet端
Server不會知道請求是從哪個Client來的，他只知道Proxy給他什麼。
2. 提高瀏覽速度
有些內容可以Cache在Proxy上，這樣你瀏覽同一個網站的時候，內容就是從Proxy來讀取而不是Server，但假設Proxy的瀏覽人數比較多造成頻寬不夠，也是有可能比較慢的
3. 過濾內容
因為中間透過了Proxy等於隔了一道類似防火牆的東西，可以過濾兩邊的內容。
4. 突破/限制訪問的區域限制
有些地方會限制網路存取，透過Proxy就可以存取，例如透過Proxy訪問內部網路。

但這些優點其實也會是缺點，因為透過了Proxy，假設這個Proxy是惡意的那怎麼辦？
不但個資會被收集，甚至可能包含惡意內容，而大多免費的Proxy可能常被人利用來攻擊導致IP被各大網站封鎖，或是你以為他安全但他實際上是透明代理（不隱藏你的真實IP）

到這邊或許會有個疑問，那我們平常上網是不是也可以設定Proxy？
當然是可以的，結尾有簡單的設定教學，讓這篇看起來不要這麼抽象XD

---
反向代理(Reverse Proxy)

Forward Proxy了解後，那接著Reverse Proxy相對的就更容易理解了，Forward Proxy是為了隱藏Cient端，那Reverse Proxy呢？就是隱藏Server端囉。

拿剛剛的例子來說，班代跟老師溝通後，有些事情老師可能去詢問其他同事，那這時候老師對班代來說就是Reverse Proxy，因為班代只知道老師而已。

假設班代一直詢問老師，那老師一定覺得很煩，這時候聰明的老師就會想了幾種方法，例如把常見的問題記下來(Cache)，把問題有效率的丟給別的老師(Load Balance)，畢竟是自己的同事，問題內容還是要做一些過濾(Policy)，老師的口齒比較清晰，可以給班代精簡的回應(Compression)。

解釋幾個剛剛代理沒提到的優點
1. Load Balance
把請求依照指定的策略分配給不同Server去處理，減輕Server的負擔。
3. Compression
把回應的內容壓縮，增加使用者瀏覽的速度。

反向代理的缺點
1. 他是在OSI第七層應用層上，也就是說你一個協定的服務你就必須做一台，所以通常被拿來在Web應用上面。
2. 反向代理會需要連結Client端和Server端，相對之下負載會比較大，所以必須要有備援機制，避免一切都依靠一台反向代理。

下面是我們比較常見拿來做Reverse Proxy的Server
1. Nginx
2. Apache
3. HAproxy
4. IIS
5. Envoy
6. Yarp

---
簡單設定Proxy

先看自己本身的IP，可以發現我目前對外的IP是 114.3x.30.xxx 
![](https://i.imgur.com/WPLmul2.png)

接下來我們來用用看Proxy
Proxy哪裡來？ 為了方便當然是先Google找啦，但記得注意安全性。
https://www.freeproxylists.net/zh/?c=&pt=&pr=HTTPS&a%5B%5D=0&a%5B%5D=1&a%5B%5D=2&u=90
我從上面看到了這個Proxy IP
![](https://i.imgur.com/SxSsUOY.png)
接著到系統 => 網路設定 => 代理的部分
![](https://i.imgur.com/oetVcyd.png)
設定完之後重新看一次IP
![](https://i.imgur.com/V2w8dp9.png)
變更成功啦！
