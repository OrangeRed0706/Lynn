---
title: Reverse Proxy 的新選擇 - Yarp
author: Lynn
date: 2022-12-04 00:00:00
tags: ["Reverse Proxy"]
---

Yarp怎麼來的？
從官網所述，Yarp的誕生是因為微軟的內部團隊都存在著反向代理的需求，而這些有需求的人聚在一起開發一個共同的Solution - Yarp


跟其他同類型的Reverse Proxy相比
![](https://i.imgur.com/xfNJccs.png)
<!--more-->
![](https://i.imgur.com/JRB1XvB.png)
![](https://i.imgur.com/Lts4Lwa.png)
![](https://i.imgur.com/27cufFd.png)
來源：https://msit.powerbi.com/view?r=eyJrIjoiYTZjMTk3YjEtMzQ3Yi00NTI5LTg5ZDItNmUyMGRlOTkwMGRlIiwidCI6IjcyZjk4OGJmLTg2ZjEtNDFhZi05MWFiLTJkN2NkMDExZGI0NyIsImMiOjV9


![](https://i.imgur.com/IrnK3aD.png)
來源 https://github.com/microsoft/reverse-proxy/issues/40 (2020)

其實可以看到效能是很優異的，雖然跟NGINX比起來有點落差，記憶體也吃了500M左右 :laughing: 
與其他Reverse Proxy相比他的優點是
1. 使用C#開發
2. 設定簡單易懂（最基本的只要Config給一給）
3. 目前是微軟的開源專案

針對 .NET的開發者而言，我覺得光是使用C#開發這點就很值得用了，相較之下學習成本更低也更友善，但Nginx和Envoy相比之下更泛用，我認為以方便和學習性而言Yarp是個很值得使用的Reverse Proxy。

# Yarp的組成

Yarp的Config主要是由Routes和Cluster組成
## Routes
包含路徑的參數和相關聯的Cluster，有幾個參數必須要有
* RouteID - 不可重複的名稱
* ClusterId - 指向對應的Cluster
* Match - 限制Route的內容必須符合
## Clusters
Cluster的部分通常是對應著Route，設置的選項很多，主要是包含著目的地的名稱和位址，剩下常見LoadBalanc和HealthCheck也是在這邊設定
下面是簡單的Config範例


## Example
再來就是簡單的範例，首先最基本的是要安裝Yarp.ReverseProxy
![](https://i.imgur.com/5OYpim5.png)
再來起一台WebHost，並且DI相關的Service
```
var builder = WebApplication.CreateBuilder(args);
var services = builder.Services;
var config = builder.Configuration;

services.AddReverseProxy().LoadFromConfig(config.GetSection("ReverseProxy"));

var app = builder.Build();
app.MapReverseProxy();
app.Run();
```
再來是Config設定
```
  "ReverseProxy": {
    "Routes": {
      "route1": {
        "ClusterId": "cluster1",
        "Match": {
          "Path": "/api/{**catch-all}"
        }
      }
    },
    "Clusters": {
      "cluster1": {
        "Destinations": {
          "LoadBalancingPolicy": "RoundRobin",
          "Destination1": {
            "Address": "https://localhost:7180/"
          },
          "Destination2": {
            "Address": "https://localhost:7289/"
          }
        }
      }
    }
  }
```
接下來準備另外兩台要被代理的Host，讓他們只回簡單的Hellp API
```
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();
app.MapGet("api/hello", () => "Hello API 1");
app.Run();
==============================================================
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();
app.MapGet("api/hello", () => "Hello API 2");
app.Run();
```
最後看看Log，可以發現同樣的Route他兩台都有代理到，代表LoadBalancing的設定有成功啦
![](https://i.imgur.com/tPRhHoJ.png)

雖然大部分的反向代理Server都是用config來設定，但我們總會希望多一點彈性，甚至是說讓他也可以做discovery service這件事，所以Yarp有提供給我們用程式去做，但在這邊除了上面列的其實還可以想一想彼此的優缺點，用config的好處是什麼？用程式的方式好處又是什麼？各自的缺點和後續帶來的影響是什麼？

接下來就把剛剛設定的config改成用Code的方式。

因為這邊的程式比較多，為了避免很難看懂，就直接上圖了（其實是因為排版麻煩）
首先繼承 IProxyConfigProvider，他會要我們實現GetConfig這個方法
![](https://i.imgur.com/WYgNHbu.png)
再來就是實作的部分，就只是把剛剛appsetting.json的內容搬進來而已
![](https://i.imgur.com/ZdGcymG.png)
![](https://i.imgur.com/SbX05an.png)
![](https://i.imgur.com/t6EK1Y6.png)
Program的部分就照樣
```
var builder = WebApplication.CreateBuilder(args);
var services = builder.Services;
services.AddTransient<IProxyConfigProvider, ProxyConfigProvider>();
services.AddReverseProxy();

var app = builder.Build();
app.MapReverseProxy();
app.Run();
```
![](https://i.imgur.com/pxOa6fT.png)
驗證結束