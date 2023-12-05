---
layout: post
date: 2015-09-20 22:26:18 +0800
title: "Linux环境下手动编译Shadowsocks服务端"
slug: "1442755264"
categories: 软件应用
tags: 科学上网, 网络, 软件应用, Linux
redirect_from:
  - /post/37.html
---
* content
{:toc}

由于某些原因，Shadowsocks的官方源有失效的危险，在这种情况下，学习手动编译就很有必要了。
<!--more-->

在终端中执行以下命令
```Shell
git clone https://github.com/shadowsocks/shadowsocks-libev.git
cd shadowsocks-libev
sudo apt-get install build-essential autoconf libtool libssl-dev
./configure && make
make install
```

如果官方源失效，也可在此下载  
[本地连接](http://share.zhangminghao.com/Shadowsocks/shadowsocks-libev-master.zip)  
[百度网盘](http://pan.baidu.com/s/1qWoWyoW)  
