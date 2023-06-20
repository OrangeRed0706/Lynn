---
title: C# Boxing && Unboxing
author: Lynn
date: 2023-06-20
tags: [".NET"]
---

這兩段程式碼看起來有差嗎？
```
var count = 0;
//1
Console.WriteLine($"Hello World {count}");
//2
Console.WriteLine($"Hello World {count.ToString()}");
```
<!--more-->

雖然在程式碼結構上差異不大，但在內部的運作上，這兩者實際上有很大的差別。

下面是一個簡單實際執行的效能測試：
版本 : .NET Core 3.1
```
void Main()
{
	var count = 1000000;
	Case1Testing(count);
	Case2Testing(count);
}

void Case1Testing(int count)
{
	var st = new Stopwatch();
	st.Start();
	for (int i = 0; i < count; i++)
	{
		var str = $"Hello World {i.ToString()}";
	}
	st.Stop();
	Console.WriteLine($"Case1 花費: {st.ElapsedMilliseconds}ms");
}

void Case2Testing(int count)
{
	var st = new Stopwatch();
	st.Start();
	for (int i = 0; i < count; i++)
	{
		var str = $"Hello World {i}";
	}
	st.Stop();
	Console.WriteLine($"Case2 花費: {st.ElapsedMilliseconds}ms");
}

//Output:
//Case1 花費: 48ms
//Case2 花費: 112ms
```
雖然看起來相差了兩倍，但實際上這是了一百萬次的結果，但為什麼會有這種差異呢？

這就是這篇文章的標題啦~ 「Boxing」與「Unboxing」

一般的Value Type是存在Stack，而Reference Type在Stack指向的位置是Heap的位址，所以在Valut Type需要轉換成Reference Type的時候就會觸發Boxing這個過程

![](https://learn.microsoft.com/zh-tw/dotnet/csharp/programming-guide/types/media/boxing-and-unboxing/boxing-operation-i-o-variables.gif)

```
var i = 123;
object o = i; //boxing
```
那Unboxing呢? 反過來將Reference Type轉換成Value Type就會發生
![](https://learn.microsoft.com/zh-tw/dotnet/csharp/programming-guide/types/media/boxing-and-unboxing/unboxing-conversion-operation.gif)
```
var i = 123;      
object o = i;     // boxing
var j = (int)o;   // unboxing
```

在.NET官方有明確指出，boxing和unboxing是非常耗費運算資源的，因為在boxing時會需要建立一個新的箱子(物件)，比單純Assign的速度多了整整20倍，而unboxing也比Assign多了4倍的時間。

所以基本上在有效能考量的程式裡面，需要盡量避免這種況狀發生。

第二個問題來了，剛剛有特別標註環境是 net core 3.0，如果換到6.0以後
```
void Main()
{
	var count = 1000000;
	Case1Testing(count);
	Case2Testing(count);
}

void Case1Testing(int count)
{
	var st = new Stopwatch();
	st.Start();
	for (int i = 0; i < count; i++)
	{
		var str = $"Hello World {i.ToString()}";
	}
	st.Stop();
	Console.WriteLine($"Case1 花費: {st.ElapsedMilliseconds}ms");
}

void Case2Testing(int count)
{
	var st = new Stopwatch();
	st.Start();
	for (int i = 0; i < count; i++)
	{
		var str = $"Hello World {i}";
	}
	st.Stop();
	Console.WriteLine($"Case2 花費: {st.ElapsedMilliseconds}ms");
}

//Output:
//Case1 花費: 30ms
//Case2 花費: 47ms
```

為什麼會快這麼多?
其實是C# 10有對字串插補做效能改進
可以用LinqPad等其他工具看到net core 3.0 一開始被編譯出來的版本，是使用String.Format
```
//1
Case1Testing
  Stopwatch st = new Stopwatch ();
   st.Start ();
   int i = 0;
   while (i < count)
   {
        string.Concat ("Hello World ", i.ToString ());
        i++;
   }
   st.Stop ();
   Console.WriteLine (string.Format ("Case1 花費: {0}ms", st.ElapsedMilliseconds));

//2
Case2Testing
Stopwatch st = new Stopwatch ();   
   st.Start ();
   int i = 0;
   while (i < count)
   {
        string.Format ("Hello World {0}", i);
        i++;
   }
   st.Stop ();
   Console.WriteLine (string.Format ("Case2 花費: {0}ms", st.ElapsedMilliseconds));
```
但 6.0 C# 10的版本呢?
```
//1
Case1Testing 
 Stopwatch st = new Stopwatch ();
   st.Start ();
   int i = 0;
   while (i < count)
   {
        string.Concat ("Hello World ", i.ToString ());
        i++;
   }
   st.Stop ();
   DefaultInterpolatedStringHandler defaultInterpolatedStringHandler = new DefaultInterpolatedStringHandler (12, 1);
   defaultInterpolatedStringHandler.AppendLiteral ("Case1 花費: ");
   defaultInterpolatedStringHandler.AppendFormatted (st.ElapsedMilliseconds);
   defaultInterpolatedStringHandler.AppendLiteral ("ms");
   Console.WriteLine (defaultInterpolatedStringHandler.ToStringAndClear ());
//2
Case2Testing    
  Stopwatch st = new Stopwatch ();
   st.Start ();
   int i = 0;
   DefaultInterpolatedStringHandler defaultInterpolatedStringHandler;
   while (i < count)
   {
        defaultInterpolatedStringHandler = new DefaultInterpolatedStringHandler (12, 1);
        defaultInterpolatedStringHandler.AppendLiteral ("Hello World ");
        defaultInterpolatedStringHandler.AppendFormatted (i);
        defaultInterpolatedStringHandler.ToStringAndClear ();
        i++;
   }
   st.Stop ();
   defaultInterpolatedStringHandler = new DefaultInterpolatedStringHandler (12, 1);
   defaultInterpolatedStringHandler.AppendLiteral ("Case2 花費: ");
   defaultInterpolatedStringHandler.AppendFormatted (st.ElapsedMilliseconds);
   defaultInterpolatedStringHandler.AppendLiteral ("ms");
   Console.WriteLine (defaultInterpolatedStringHandler.ToStringAndClear ());
```
可以看到他改用了DefaultInterpolatedStringHandler 的方法，但我們只能知道他速度變快了，不曉得實際上對CPU和Memory的影響如何。

所以寫了一段壓力測試來跑跑看
```
void Main()
{
	var summary = BenchmarkRunner.Run<StringBenchmarks>();
}

[MemoryDiagnoser]
public class StringBenchmarks
{
	public int value = 0;
	[GlobalSetup]
	public void Setup()
	{
	}

	[Benchmark(Description = "Interpolation Without ToString")]
	public string StringInterpolationNoToString()
	{
		return $"Hello World {value}";
	}

	[Benchmark(Description = "Interpolation With ToString")]
	public string StringInterpolationToString()
	{
		return $"Hello World {value.ToString()}";
	}

	[Benchmark(Description = "String.Format Without ToString")]
	public string StringFormat()
	{
		return string.Format("Hello World {0}", value);
	}

	[Benchmark(Description = "String.Format With ToString")]
	public string StringFormatToString()
	{
		return string.Format("Hello World {0}", value.ToString());
	}
}
```
Output：
```
// * Summary *
BenchmarkDotNet=v0.13.5, OS=Windows 11 (10.0.22621.1848/22H2/2022Update/SunValley2)
AMD Ryzen 7 3800X, 1 CPU, 16 logical and 8 physical cores
.NET SDK=7.0.302
  [Host] : .NET Core 3.1.32 (CoreCLR 4.700.22.55902, CoreFX 4.700.22.56512), X64 RyuJIT AVX2

|                           Method |      Mean |    Error |   StdDev |   Gen0 |   Gen1 | Allocated |
|--------------------------------- |----------:|---------:|---------:|-------:|-------:|----------:|
| 'Interpolation Without ToString' | 113.37 ns | 0.485 ns | 0.454 ns | 0.0086 |      - |      72 B |
|    'Interpolation With ToString' |  31.18 ns | 0.670 ns | 1.306 ns | 0.0057 |      - |      48 B |
| 'String.Format Without ToString' | 116.08 ns | 2.237 ns | 2.198 ns | 0.0086 |      - |      72 B |
|    'String.Format With ToString' | 122.94 ns | 2.388 ns | 5.859 ns | 0.0057 | 0.0002 |      48 B |


// * Summary *
BenchmarkDotNet=v0.13.5, OS=Windows 11 (10.0.22621.1848/22H2/2022Update/SunValley2)
AMD Ryzen 7 3800X, 1 CPU, 16 logical and 8 physical cores
.NET SDK=7.0.302
  [Host] : .NET 6.0.18 (6.0.1823.26907), X64 RyuJIT AVX2

|                           Method |     Mean |    Error |   StdDev |   Gen0 | Allocated |
|--------------------------------- |---------:|---------:|---------:|-------:|----------:|
| 'Interpolation Without ToString' | 39.14 ns | 0.318 ns | 0.281 ns | 0.0057 |      48 B |
|    'Interpolation With ToString' | 15.81 ns | 0.334 ns | 0.610 ns | 0.0057 |      48 B |
| 'String.Format Without ToString' | 46.94 ns | 0.361 ns | 0.320 ns | 0.0086 |      72 B |
|    'String.Format With ToString' | 46.63 ns | 0.434 ns | 0.362 ns | 0.0057 |      48 B |
```
可以看到共通點就是StringFormat還是比較慢啦，但明顯也跟著版本更新速度變快了。
而字串插捕加上手動避免boxing的僅僅只有15.81ns，但Memory的分配看起來都差不多，推測是因為字串太單純，導致不太明顯，所以更改了以下的壓測程式碼
```
void Main()
{
	var summary = BenchmarkRunner.Run<StringBenchmarks>();
}

[MemoryDiagnoser]
public class StringBenchmarks
{
	public int value = 1234567890;
	[GlobalSetup]
	public void Setup()
	{
	}

	[Benchmark(Description = "Interpolation Without ToString")]
	public string StringInterpolationNoToString()
	{
		return $"Hello World {value} {value} {value} {value} {value}";
	}

	[Benchmark(Description = "Interpolation With ToString")]
	public string StringInterpolationToString()
	{
		return $"Hello World {value.ToString()}{value.ToString()}{value.ToString()}{value.ToString()}{value.ToString()}";
	}

	[Benchmark(Description = "String.Format Without ToString")]
	public string StringFormat()
	{
		return string.Format("Hello World {0}{1}{2}{3}{4}", value,value,value,value,value);
	}

	[Benchmark(Description = "String.Format With ToString")]
	public string StringFormatToString()
	{
		return string.Format("Hello World {0}{1}{2}{3}{4}", value.ToString(),value.ToString(),value.ToString(),value.ToString(),value.ToString());
	}
}
```
Output：

```
// * Summary *
BenchmarkDotNet=v0.13.5, OS=Windows 11 (10.0.22621.1848/22H2/2022Update/SunValley2)
AMD Ryzen 7 3800X, 1 CPU, 16 logical and 8 physical cores
.NET SDK=7.0.302
  [Host] : .NET Core 3.1.32 (CoreCLR 4.700.22.55902, CoreFX 4.700.22.56512), X64 RyuJIT AVX2
|                           Method |     Mean |   Error |   StdDev |   Gen0 |   Gen1 | Allocated |
|--------------------------------- |---------:|--------:|---------:|-------:|-------:|----------:|
| 'Interpolation Without ToString' | 368.3 ns | 6.71 ns |  8.23 ns | 0.0410 |      - |     344 B |
|    'Interpolation With ToString' | 208.2 ns | 3.16 ns |  4.83 ns | 0.0553 | 0.0002 |     464 B |
| 'String.Format Without ToString' | 342.5 ns | 6.86 ns | 14.77 ns | 0.0401 |      - |     336 B |
|    'String.Format With ToString' | 394.1 ns | 3.82 ns |  3.57 ns | 0.0544 | 0.0005 |     456 B |


// * Summary *
BenchmarkDotNet=v0.13.5, OS=Windows 11 (10.0.22621.1848/22H2/2022Update/SunValley2)
AMD Ryzen 7 3800X, 1 CPU, 16 logical and 8 physical cores
.NET SDK=7.0.302
  [Host] : .NET 6.0.18 (6.0.1823.26907), X64 RyuJIT AVX2
|                           Method |     Mean |   Error |  StdDev |   Gen0 | Allocated |
|--------------------------------- |---------:|--------:|--------:|-------:|----------:|
| 'Interpolation Without ToString' | 124.9 ns | 2.51 ns | 4.65 ns | 0.0191 |     160 B |
|    'Interpolation With ToString' | 143.6 ns | 2.92 ns | 6.66 ns | 0.0467 |     392 B |
| 'String.Format Without ToString' | 197.3 ns | 3.86 ns | 4.45 ns | 0.0401 |     336 B |
|    'String.Format With ToString' | 267.3 ns | 3.37 ns | 3.15 ns | 0.0544 |     456 B |
```
這樣差距就有出來了，可以發現在 .Net 6 插補字串 ToSting()避免boxing會比不ToString()多分配了將近兩倍的記憶體，但只快了19ns左右，雖然這些都微乎其微，真正有需要的時候可以列入考量。


Reference:
https://learn.microsoft.com/zh-tw/dotnet/framework/performance/performance-tips?WT.mc_id=DT-MVP-4015686
https://learn.microsoft.com/zh-tw/dotnet/csharp/programming-guide/types/boxing-and-unboxing?WT.mc_id=DT-MVP015686