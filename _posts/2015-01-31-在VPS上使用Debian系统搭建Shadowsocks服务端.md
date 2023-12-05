---
layout: post
date: 2015-01-31 21:21:09 +0800
title: "在VPS上使用Debian系统搭建Shadowsocks服务端"
slug: "1422709264"
categories: 软件应用
tags: Linux, 网络, 科学上网, 软件应用
redirect_from:
  - /post/31.html
---
* content
{:toc}

Shadowsocks是一款轻量级socks5代理软件，下面介绍在VPS上搭建shadowsocks服务端的方法：  
<!--more-->

首先必须登入你的VPS的终端界面，不同的服务商有不同的登入方式，常见的是用SSH协议，Windows下推荐PuTTY和WinSCP两种客户端，PuTTY可在终端运行命令，WinSCP可以进行文件管理，不建议使用WinSCP运行命令。

## 1、添加shadowsocks源

debian 6系统运行以下命令：

```Shell
add-apt-repository 'deb http://shadowsocks.org/debian squeeze main'
```

debian 7系统运行以下命令：

```Shell
add-apt-repository 'deb http://shadowsocks.org/debian wheezy main'
```

添加shadowsocks证书

```Shell
wget -O- http://shadowsocks.org/debian/1D27208A.gpg | apt-key add -
```

## 2、安装shadowsocks服务端

目前主流的shadowsocks服务端是

* shadowsocks-libev
* shadowsocks-nodejs
* shadowsocks-Python
* shadowsocks-go

但是在小内存的vps还是要尽量节省内存，所以推荐Debian系统搭建Shadowsocks服务端。

```Shell
apt-get update
apt-get install shadowsocks-libev
```

## 3、配置shadowsocks服务端

使用WinSCP或Vi编辑shadowsocks配置文件/etc/shadowsocks-libev/config.json，输入以下内容并保存：

```Shell
{
"server":"vps的ip",
"server_port":8388,   #服务器端口，与SSH端口不一样
"local_port":1080,
"password":"password", #认证密码
"timeout":60,
"method":"aes-256-cfb" #加密方式，常用的是aes-256-cfb
}
```

客户端请使用和服务端同样的配置。

## 4、控制shadowsocks服务端

运行以下命令可启动shadowsocks服务端：

```Shell
/etc/init.d/shadowsocks-libev start
```

运行以下命令可停止shadowsocks服务端：

```Shell
/etc/init.d/shadowsocks-libev stop
```

运行以下命令可重新启动shadowsocks服务端：

```Shell
/etc/init.d/shadowsocks-libev restart
```

## 5.安装chacha20加密算法

运行以下命令安装chacha20加密算法

```Shell
apt-get install m2crypto
wget https://github.com/jedisct1/libsodium/releases/download/1.0.11/libsodium-1.0.11.tar.gz
tar zxvf libsodium-1.0.11.tar.gz
cd libsodium-1.0.11
./configure
make && make check
make install
```