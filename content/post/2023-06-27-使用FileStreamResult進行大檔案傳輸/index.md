---
title: 使用FileStreamResult進行大檔案傳輸
author: Lynn
date: 2023-06-27
tags: ["Rust"]
---

來還技術債啦！！！

剛入職時接到的第一份工作是要匯出一個API回傳的資料，並處理成CSV的格式匯出讓使用者下載，因為格式單純所以那時也沒有使用任何CSV的套件，就單純回傳一個組好的物件。

那時資料量不多，所以也安安穩穩的度過了一年的時間，直到最近資料量暴增，於是發生了OOM 😆

但做的人並不是我，所以想說直接來練練手好了
<!--more-->

目前想到要處理大量資料的方式是這兩種
1. 批次取回資料
2. 使用Stream的方式

接著就做幾個API來模擬吧

前置作業: 
```
dotnet new sln -n All
dotnet new webapi -n data.source.api
dotnet new webapi -n file.download.api
dotnet sln All.sln add ./data.source.api/
dotnet sln All.sln add ./file.download.api
```
datasource.api
```
    [HttpGet]
    [Route("get/big-data")]
    public async Task DownloadFile()
    {
        var numberOfLines = 50000000;

        Response.ContentType = "text/csv";
        Response.Headers["Content-Disposition"] = "attachment; filename=output.csv";

        await foreach (var line in GenerateCsvLines(numberOfLines))
        {
            var buffer = Encoding.UTF8.GetBytes(line);
            await Response.Body.WriteAsync(buffer, 0, buffer.Length);
            await Response.Body.FlushAsync();
        }

    }

    private async IAsyncEnumerable<string> GenerateCsvLines(int numberOfLines)
    {
        // Add column headers
        var header = new StringBuilder();
        for (int i = 1; i <= 10; i++)
        {
            if (i > 1)
            {
                header.Append(',');
            }

            header.Append("column" + i);
        }
        yield return header.ToString() + Environment.NewLine;

        for (var i = 0; i < numberOfLines; i++)
        {
            var sb = new StringBuilder();
            for (var j = 0; j < 10; j++)
            {
                if (j > 0)
                {
                    sb.Append(',');
                }

                sb.Append(Guid.NewGuid());
            }

            yield return sb.ToString() + Environment.NewLine;
        }
    }
```
filedownload.api
```
   [HttpGet]
    [Route("api/download")]
    public async Task<IActionResult> DownloadFile()
    {
        var httpClient = new HttpClient();

        var url = "https://localhost:7124/DataSource/get-big-data/";

        var response = await httpClient.GetAsync(url, HttpCompletionOption.ResponseHeadersRead);

        if (!response.IsSuccessStatusCode)
        {
            return StatusCode((int)response.StatusCode);
        }

        var stream = await response.Content.ReadAsStreamAsync();

        var fileStreamResult = new FileStreamResult(stream, "text/csv")
        {
            FileDownloadName = "output.csv"
        };

        return fileStreamResult;
    }
```

`data-source`
![](./image/data-source.png)
`file-download`
![](./image/file-download.png)