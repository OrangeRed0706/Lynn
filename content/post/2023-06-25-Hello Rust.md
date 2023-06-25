---
title: Hello Rust
author: Lynn
date: 2023-06-25
tags: ["Rust"]
---

Rust是一種偏向系統級的程式語言。主要目的是為了高效能和安全的應用程序而設計，於2010年在Mozilla研究所發表，並於2015年達到穩定版本。\
詳細內容就看Wiki吧 \
 https://zh.wikipedia.org/wiki/Rust

對這語言好奇的原因是因為連Window的Kernel都準備用Rust來取代C++了，單論效能Rust在具有額外安全保證的程式碼會比C++慢一些，但假設C++也做了一些手工檢查，兩者的效能其實是相似的。
<!--more-->

https://www.thurrott.com/windows/windows-11/282995/first-rust-code-shows-up-in-the-windows-11-kernel

如果之後會在Github、GitLab上看到，那不如有空先來熟悉一下，所以就來試試看`Rust` \
對Rust的所有權概念也是蠻好奇的XD
## 安裝Rust
在Window上Rust會需要[Microsoft C++ Build Tools](https://visualstudio.microsoft.com/zh-hant/visual-cpp-build-tools/)，假設有安裝`Visual Studio`那其實已經包含在裡面了，不愧是地表最強IDE！！！

不要誤會，寫Rust是使用`Visual Studio Code`而不是`Visual Studio`，他在這邊只扮演著整合包的角色。

接下來要安裝Rust，可以直接點以下連結下載 \
https://www.rust-lang.org/tools/install \
Mac、Linux也可以用Command的方式安裝，WSL其實也可以，但以下是learn.microsoft的原文:

Rust works very well on Windows; so there's no need for you to go the WSL route (unless you plan to locally compile and test on Linux). Since you have Windows, we recommend that you just run the rustup installer for 64-bit Windows. Also install the Microsoft C and C++ (MSVC) toolchain by running rustup default stable-msvc. You'll then be all set to write apps for Windows using Rust.

所以我決定相信微軟，就直接在Window上安裝吧！
```
rustc --version

##output:
##rustc 1.70.0 (90c541806 2023-05-31)
```

## Hello World

每個語言的起手都差不多，先創一個資料夾
```
> mkdir hello-world-rust
```
創一個`main.rs`的檔案，編輯內容寫第一個Function
```
fn main() {
    println!("Hello, world!");
}
```
編譯
```
> rustc main.rs
```
執行
```
> .\main.exe
Hello,world
```

## Hello Cargo

再來是Cargo，他是Rust的套件管理器，用來下載和管理依賴關係，可以把他理解成dotnet tools
起手式一樣
```
> cargo new hello-cargo
> cd hello-cargo
```
可以看到裡面包含了`Cargo.toml`和`.git` `src`兩個Folder，還有一個`Cargo.toml`檔案紀錄著一些專案的相關資訊
```
[package]
name = "hello-cargo"
version = "0.1.0"
edition = "2021"

# See more keys and their definitions at https://doc.rust-lang.org/cargo/reference/manifest.html

[dependencies]
```

接著會發現`src/main.rs`內已經包含了Hello world的Example，實在是很貼心 \

接著建構專案，假設是Release可加上`--release`
```
> cargo build
```
會發現多了一個`target`的folder，在`target/debug`存放著編譯好的執行檔
```
> .\target\debug\hello-cargo.exe
hello world
```
畢竟是套件管理器，所以執行的時候理所當然也要方便點 \
`cargo run` 編譯並產生執行檔
```
> cargo run
    Finished dev [unoptimized + debuginfo] target(s) in 0.00s
     Running `target\debug\hello-cargo.exe`
Hello, world!
```
`cargo check` 單純檢查確保編譯通過但不產生執行檔
```
> cargo check
    Checking hello-cargo v0.1.0 (G:\Rust\hello-cargo)
    Finished dev [unoptimized + debuginfo] target(s) in 0.05s
```

到目前為止算是完成Hello world啦，不得不說教學文件真的非常完善，希望接下來可以做一點好玩的東西XD

Reference:
* https://www.techbang.com/posts/106699-ill-get-it-after-the-rest-of-the-article-today-instead-of-c
* https://www.thurrott.com/windows/282471/microsoft-is-rewriting-parts-of-the-windows-kernel-in-rust
* https://learn.microsoft.com/zh-tw/windows/dev-environment/rust/setup?WT.mc_id=DT-MVP-4015686
* https://doc.rust-lang.org/book/