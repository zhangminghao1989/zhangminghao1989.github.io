---
layout: post
date: 2015-09-24 23:21:59 +0800
title: "[转]Windows Vista/7/8更新后不再支持SafeDisk与SecuROM游戏"
slug: "1443100864"
categories: 软件应用
tags: Windows
redirect_from:
  - /post/39.html
---
* content
{:toc}

Windows 10当前已经不再支持如SafeDisc和某些版本的SecuROM这样的DRM数字版权管理系统，而且微软最近还发布了针对Windows Vista、7、8的升级，专门用于禁用对这类DRM的支持，也就是说使用SafeDisc和SecuROM的游戏没法在新系统上玩了。好在现在已经有方 法打开这种限制。

微软之所以做出这样的决定，是基于系统安全方面的考虑，据说会增加安全风险，所以所有采用了SafeDisc DRM和部分SecuROM版本的游戏都是不能在Windows 10系统中运行的。并且这条限制也已经加入到了Windows Vista/7/8的身上。

不过这次，微软同时也提供了一些打开这种支持的方法，专门为那些还想在电脑上玩老游戏的用户准备。不过微软也特别强调说，打开对SafeDisc和SecuROM的支持以后，设备会陷入到安全风险中，在你享受完游戏之后就请尽快将之关闭吧。

解开DRM支持的限制有两种方法，其一是以管理员模式运行命令行（开始-运行，输入cmd.exe，注意采用管理员模式运行），在命令行中输入“sc start secdrv”（不包含引号）。如果要关闭支持，还是进入命令行输入“sc stop secdrv”。

还有一种方法是修改注册表，具体操作方式可点击[这里](https://support.microsoft.com/en-us/kb/3086255)访问微软的官方网站（kb3086255）。

原文：
>http://www.cnbeta.com/articles/432957.htm