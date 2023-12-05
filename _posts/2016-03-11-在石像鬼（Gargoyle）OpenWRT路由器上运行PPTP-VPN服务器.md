---
layout: post
date: 2016-03-11 23:34:05 +0800
title: "在石像鬼（Gargoyle）OpenWRT路由器上运行PPTP VPN服务器"
slug: "1457702464"
categories: 网络
tags: 路由器, 网络, OpenWRT
redirect_from:
  - /post/40.html
---
* content
{:toc}

官方原版的石像鬼（Gargoyle）OpenWRT固件中默认是没有PPTP VPN服务器程序的，其官方软件库中也没有，要想在其上安装PPTP VPN服务，可以使用OpenWRT的官方软件库。

下面以目前最新的Gargoyle 1.9.0版本为例进行操作：

1、安装服务端程序
PPTP VPN服务端需要以下插件

pptpd

kmod-mppe

ppp

在终端中运行以下命令安装：

Bash
opkg update
opkg install pptpd kmod-mppe ppp
Gargoyle 1.9.0基于OpenWRT 15.05，其内置的插件源包括了OpenWRT的官方插件源，所以大部分插件都可以和OpenWRT一样直接安装，但是在OpenWRT 15.05的官方源中没有pptpd插件，因此我们需要在OpenWRT 14.07的源中寻找pptpd。当然也可以使用其他版本的源，但不建议使用开发版本（Snapshot）的源，可能会出现莫名其妙的BUG。

打开网页https://downloads.openwrt.org/barrier_breaker/14.07/

找到自己的设备所在的分支，在其中的/generic/packages/oldpackages/目录中可以找到，

例如https://downloads.openwrt.org/barrier_breaker/14.07/ar71xx/generic/packages/oldpackages/pptpd_1.4.0-1_ar71xx.ipk

在终端中运行以下命令安装（根据你自己的源进行修改）：

Bash
wget https://downloads.openwrt.org/barrier_breaker/14.07/ar71xx/generic/packages/oldpackages/pptpd_1.4.0-1_ar71xx.ipk
opkg install pptpd_1.4.0-1_ar71xx.ipk
至此所需插件安装完毕。

2、配置服务端
修改/etc/config/pptpd文件，如果没有就创建此文件

Bash
config service 'pptpd'
	option enabled '1'
	option localip '192.168.11.1'        //VPN服务器网关
	option remoteip '192.168.11.20-30'   //VPN客户端地址
	option mppe '1'                      //开启mppe加密（聊胜于无）
	option nat '1'                       //开启NAT转发
	option internet '1'                  //允许访问internet

config login
	option username 'user1'              //用户1
	option password 'passwd'             //密码

config login
	option username 'user2'              //用户2
	option password 'passwd'             //密码
VPN服务器网关地址可以与路由器局域网地址不同。

如果需要VPN客户端与局域网内客户端互连、VPN客户端连接外网等功能的，则需要设置静态路由表及防火墙，在此不赘述。



设置允许外网接入VPN，修改/etc/config/firewall文件，在其中添加以下内容：

Bash
config rule
	option name 'pptp'
	option target 'ACCEPT'
	option src 'wan'
	option proto 'tcp'
	option dest_port '1723'

config rule
	option name 'gre'
	option target 'ACCEPT'
	option src 'wan'
	option proto '47'


3、启动VPN服务器
在终端中运行以下命令：

Bash
/etc/init.d/pptpd enable
/etc/init.d/pptpd start
