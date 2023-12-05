---
layout: post
date: 2015-08-11 21:39:25 +0800
title: "使用Windows 10自带的Hyper-V虚拟机运行XP系统"
slug: "1439299264"
categories: 软件应用
tags: 虚拟机, Windows
redirect_from:
  - /post/34.html
---
* content
{:toc}

笔者以前一直使用Windows 7系统，Windows 7系统所有的XP Mode使用起来很方便，最近把系统升级到了Windows 10，发现在Windows 10中XP Mode已经取消了。百度后发现从Windows 8开始系统就自带Hyper-V虚拟机了，于是在控制面板中打开此功能准备设置一个虚拟机装XP系统。
<!--more-->

使用MSDN 原版XP SP3系统镜像安装完系统以后，发现虚拟机中有一些硬件驱动没有装，百度后发现在Windows 10中已经不再提供虚拟机管理工具的镜像了，而是需要使用Windows Update来自动安装驱动。我试了一下发现驱动装不上。只好去找Windows 8里的vmguest.iso镜像文件。最后还是谷歌大神比较吊，找到了此文件。下载地址：[http://pan.baidu.com/s/1bnDGFV5](http://pan.baidu.com/s/1bnDGFV5)

在虚拟机中载入此镜像文件，系统就会自动安装驱动了。重启之后发现有两个设备的驱动仍然没有安装，硬件ID分别是

VMBUS\{3375baf4-9e15-4b30-b765-67acb10d607b}

VMBUS\{4487b255-b88c-403f-bb51-d1f69cf17f87}

和

VMBUS\{f8e65716-3cb3-4a06-9a60-1889c5cccab5}

VMBUS\{99221fa0-24ad-11e2-be98-001aa01bbf6e}

这两个驱动就需要手动安装了。

在vmguest.iso镜像中有amd64和x86两个文件夹，其中各有一个Windows6.2-HyperVIntergrationServices-***.cab文件，根据自己真实操作系统的版本选择相应的文件，将其中的文件解压出来，然后在虚拟机中手动安装这两个驱动，安装完成后就是这样了

![](/upload/2015/08/11/1.png)
