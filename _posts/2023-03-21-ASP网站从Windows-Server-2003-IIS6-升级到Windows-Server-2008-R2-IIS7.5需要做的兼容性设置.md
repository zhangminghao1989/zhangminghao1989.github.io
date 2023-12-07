---
layout: post
date: 2023-03-21 23:56:41 +0800
title: "ASP网站从Windows Server 2003 IIS6 升级到Windows Server 2008 R2 IIS7.5需要做的兼容性设置"
slug: "1679414227"
categories: 软件应用
tags: Web, ASP, Windows
redirect_from:
  - /post/56.html
---
* content
{:toc}

在Windows Server 2003 的 IIS6 下正常运行的ASP网站，在升级到Windows Server 2008 R2 的 IIS7.5 以后大部分情况下是不能正常运行的，需要进行以下兼容性设置。
<!--more-->

1. 应用程序池的基本设置中“托管管道模式”设置为“经典(Classic)”。
2. 应用程序池的高级设置中“启用32位应用程序”设置为“True”。
3. IIS的“ASP”设置中“启用父路径”按需求可设置为“True”。
4. 为了安全性，对于不需要执行脚本的目录，可在该目录的功能视图中打开“处理程序映射”，在右边的“编辑功能权限”中取消“脚本”。
5. 对于需要写权限的文件，增加“IUSR”用户的写权限即可。

经此设置，使用老旧代码的ASP网站大部分情况下应该可以正常运行了。  
当然，你也可以选择代码重构以使用IIS7.5的新特性。
