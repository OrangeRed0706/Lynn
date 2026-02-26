---
title: NLog 寫入 Fluentd：從本機檔案改成集中化日誌的設定紀錄
author: Lynn
date: 2026-02-27
tags: [".NET", "NLog", "Fluentd", "Logging"]
---

最近把一個 .NET 服務的日誌收斂到 Fluentd，我原本以為只要把 target 換掉就好，結果第一輪直接沒資料進來。這篇記錄我最後可用的設定，以及幾個最容易踩的坑。

<!--more-->

## 問題背景

本機開發時我習慣先寫檔案，排錯很直覺。不過服務一多，跨機器追事件會很痛苦，所以我改成 NLog 直接送 Fluentd，再由 Fluentd 往後送 Elasticsearch 或其他儲存。

## 基礎觀念（先釐清責任邊界）

- NLog：負責在應用程式端產生日誌並格式化
- Fluentd：負責收資料、清洗資料、分流到後端

我把 NLog 當成「送件端」，Fluentd 當成「轉運中心」。這樣看設定比較不會亂。

## 安裝套件

```bash
dotnet add package NLog
dotnet add package NLog.Web.AspNetCore
dotnet add package NLog.Targets.Fluentd
```

## NLog 設定範例

這段設定做三件事：
1) 保留 console 方便本機看
2) 增加 fluentd target
3) 帶上 service/environment 等欄位，方便後續查詢

```xml
<?xml version="1.0" encoding="utf-8" ?>
<nlog xmlns="http://www.nlog-project.org/schemas/NLog.xsd"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

  <extensions>
    <add assembly="NLog.Targets.Fluentd" />
  </extensions>

  <targets>
    <target name="console" xsi:type="Console"
            layout="${longdate}|${level:uppercase=true}|${logger}|${message} ${exception:format=tostring}" />

    <target name="fluentd" xsi:type="Fluentd"
            tag="app.backend"
            host="127.0.0.1"
            port="24224"
            requireAckResponse="true">
      <field name="timestamp" layout="${date:universalTime=true:format=o}" />
      <field name="level" layout="${level}" />
      <field name="logger" layout="${logger}" />
      <field name="message" layout="${message}" />
      <field name="exception" layout="${exception:format=tostring}" />
      <field name="service" layout="order-api" />
      <field name="environment" layout="dev" />
      <field name="traceId" layout="${aspnet-traceidentifier}" />
    </target>
  </targets>

  <rules>
    <logger name="*" minlevel="Info" writeTo="console,fluentd" />
  </rules>
</nlog>
```

## Fluentd 設定範例

```conf
<source>
  @type forward
  port 24224
  bind 0.0.0.0
</source>

<match app.backend>
  @type stdout
</match>
```

先輸出到 stdout 是我常用的第一步，因為能最快確認資料到底有沒有進 Fluentd。

## 驗證結果（我用這組檢查）

1. 啟動 Fluentd
2. 啟動 API 並打幾支 endpoint
3. Fluentd console 可看到 `app.backend` tag 的事件

我這次在 macOS + .NET 8 + Fluentd 1.16 測試，事件都能在 1 秒內出現。這個延遲拿來做一般應用追蹤已經夠用。

## 我踩到的坑

一開始我 `host` 寫成容器名稱，但 API 實際跑在主機上，DNS 根本解析不到，最後當然一筆都沒送到。改成正確的 host（或在 docker network 內統一命名）就正常了。

另一個坑是 tag 打錯。Fluentd `match` 沒對到時，畫面看起來像「系統正常但沒資料」，很容易誤判。

## NLog 直寫檔案 vs 送 Fluentd

| 面向 | 直寫檔案 | 送 Fluentd |
|---|---|---|
| 本機除錯速度 | 快 | 中等 |
| 跨服務追查 | 弱 | 強 |
| 結構化欄位 | 需另外處理 | 天然適合 |
| 維運複雜度 | 低 | 較高 |
| 擴充到多後端 | 較麻煩 | 容易 |

我現在的做法是兩個都留：本機階段看 console/檔案，上線環境走 Fluentd。

懶人包：
- 單服務、低流量、只求快 → 先用檔案
- 多服務、要集中查詢與告警 → 直接上 Fluentd
- 遷移期最穩的方式 → console + fluentd 雙寫

Reference:
- https://github.com/fluent/NLog.Targets.Fluentd
- https://docs.fluentd.org/input/forward
- https://nlog-project.org/config/
