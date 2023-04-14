---
layout: post
date: 2023-04-14 17:08:21 +0800
title: "[转]刷新第三方版本DD-WRT&TOMATO后大内存激活命令"
slug: "1359826848"
categories: 网络
tags: DD-WRT,路由器,Tomato,网络
redirect_from:
  - /post/18.html
---
* content
{:toc}

现在用第三方的人越来越多了,新人更加多.同时现在改内存的人也更多了。对于修改内存后需要的激活命令方面的资料又很少.总找不到解决办法.为了能让大家更方便,为此整理一下内存命令贴。
<!--more-->

首先是7231-4P   64M（这机器是我最开始天天折腾的机器）的内存命令，此命令使用的是2*32=64M（方案为 两个32M 16位的芯片）激活命令。

```shell
nvram set sdram_init=0x0008
nvram set sdram_config=0x0033
nvram set sdram_ncdl=0x0000
nvram commit
```

32M 的命令  2*16=32

```shell
nvram set sdram_init=0x0008
nvram set sdram_ncdl=0x0000
nvram commit
```

500GP  DDR 内存 128M 的命令 2*64M=128

```shell
nvram set sdram_init=0x0011
nvram set sdram_ncdl=0
nvram commit
reboot
```

---

从上面的例子，然后我们再对照一下下面的列表

![1](https://user-images.githubusercontent.com/99892/232001435-69a72094-ebf3-47f3-8d3d-9e8237399089.jpg)

---

有没发现之前的那些命令中有东西跟上面的列表相同？上面中间部分，就是命令用到的参数。 

大家找自己的命令时，认准Type  是DDR 还是SDR，同时还认准 Organization   是单芯片 还是双芯片“X2”。

>原文：[http://itbbs.pconline.com.cn/network/10899549.html](http://itbbs.pconline.com.cn/network/10899549.html)
