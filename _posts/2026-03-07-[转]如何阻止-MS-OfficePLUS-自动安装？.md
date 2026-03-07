---
layout: post
date: 2026-03-07 15:23:47 +0800
title: "[转]如何阻止 MS OfficePLUS 自动安装？"
slug: "1772868227"
categories: 软件应用
tags: Office
---
* content
{:toc}

## 前言
Microsoft OfficePLUS 是一款微软与 iSlide 公司合作运营的 Office 插件，主要提供 PPT 插件和模板，官网地址为: https://www.officeplus.cn/

OfficePLUS 会通过 Microsoft Office 推送，在后台静默安装，很多用户在不知情的情况下就被装上了，但我们有办法可以阻止它。

<!--more-->

## 操作步骤
使用管理员权限打开命令提示符、PowerShell 或 Windows 终端，输入以下命令并回车：

```Powershell
reg add "HKLM\SOFTWARE\Microsoft\MSOfficePLUS" /v "InstallSuccess" /f
```

这个值的主要作用是让 Microsoft Edge 和 Microsoft Office 认为 OfficePLUS 已成功安装了，然后它们就不会再次推送安装了，原理就是这么简单 :tushe:

其它方法我们也在研究/监测当中。修改 Windows 区域并不是一个完美的解决方案，并且修改区域会导致 Office Tool Plus 无法获取最佳的服务器，进而导致大家在获取 Office Tool Plus 更新的时候显得速度有点慢。所以如果没什么问题的话，我们一般是不建议更改 Windows 区域设置的哦~
