---
layout: post
date: 2013-03-18 18:19:01 +0800
title: "在DD-WRT路由器上设置DNSmasq使用smarthosts翻墙并自动更新"
slug: "1363600188"
categories: 网络
tags: DD-WRT,科学上网,路由器
redirect_from:
  - /post/23.html
---
* content
{:toc}

SmartHosts是一个托管在谷歌代码上的项目，您可以轻松利用此项目使用到一份稳定的Hosts文件。
<!--more-->

这份Hosts文件可以帮助您顺利打开一些网站，提高某些国外服务的打开或下载速度。

本文主要介绍在DD-WRT路由器上如何设置，使DNSmasq可以使用SmartHosts项目的hosts表，并每日自动更新。

## 首先介绍直接使用SmartHosts项目的dnsmasq.conf文件。

1.打开服务页面，在DNSMasq 附加选项框中输入以下内容并保存

```Shell
conf-file=/tmp/smarthosts.conf
```

作用是设置导入SmartHosts的DNSmasq配置文件路径

2.在管理-命令页面的指令解释器中输入

```Shell
touch /tmp/smarthosts.conf
```

然后保存为启动指令。目的是在启动过程中自动创建一个空白的配置文件供DNSmasq导入，否则将会产生bug，造成的后果包括不能上网、无法在路由器端使用wget命令

3.在指令解释器中输入

```Shell
#!/bin/sh
touch /tmp/smarthosts.conf.tmp
until [ "`cat /tmp/smarthosts.conf.tmp|grep -c address=/`" != 0 ];do
sleep 15
wget http://smarthosts.googlecode.com/svn/trunk/dnsmasq.conf -O /tmp/smarthosts.conf.tmp
done
mv /tmp/smarthosts.conf.tmp /tmp/smarthosts.conf
stopservice dnsmasq && startservice dnsmasq
```

保存为自定义指令。这段代码的作用是自动下载最新的SmartHosts项目的DNSmasq配置文件，并自动检查是否下载成功，如果不成功每隔15秒重新下载一次并检查，直到下载成功为止，然后自动载入该配置文件。

4.在指令解释器中输入

```Shell
/tmp/custom.sh
```

保存为防火墙指令，作用是运行上一步生成的自定义指令。

全部操作完成以后重启路由器，稍等两分钟即可自动完成DNSmasq的配置。可使用以下命令检测是否成功下载到配置文件

```Shell
cat /tmp/smarthosts.conf
```

 如果显示的和SmartHosts项目的DNSmasq配置文件一样则表示配置成功。

5.配置每天凌晨3点自动更新
首先必须在管理页面中启用Cron，然后在Cron 附加任务中输入以下内容并保存。

```Shell
0 3 * * * root /tmp/custom.sh
```

 如果想更改更新周期，请自行查阅Cron计划任务的配置方法

## 由于SmartHosts项目的dnsmasq.conf文件更新比较缓慢，下面介绍直接使用更新较快的Hosts文件的方法

1.打开服务页面，在DNSMasq 附加选项框中输入

```Shell
addn-hosts=/tmp/smarthosts.hosts
```

2.在管理-命令页面的指令解释器中输入

```Shell
touch /tmp/smarthosts.hosts
```

然后保存为启动指令。

3.在指令解释器中输入

```Shell
touch /tmp/smarthosts.hosts.tmp
until [ "`cat /tmp/smarthosts.hosts.tmp|grep -c SmartHosts`" != 0 ];do
sleep 15
wget http://smarthosts.googlecode.com/svn/trunk/hosts -O /tmp/smarthosts.hosts.tmp
done
mv /tmp/smarthosts.hosts.tmp /tmp/smarthosts.hosts
stopservice dnsmasq && startservice dnsmasq
```

保存为自定义指令。

4.在指令解释器中输入

```Shell
/tmp/custom.sh
```

保存为防火墙指令

5.配置每天凌晨3点自动更新
首先必须在管理页面中启用Cron，然后在Cron 附加任务中输入以下内容并保存。

```Shell
0 3 * * * root /tmp/custom.sh
```
