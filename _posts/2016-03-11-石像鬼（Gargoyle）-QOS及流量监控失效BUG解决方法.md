---
layout: post
date: 2016-03-11 23:45:03 +0800
title: "石像鬼（Gargoyle） QOS及流量监控失效BUG解决方法"
slug: "1457709664"
categories: 网络
tags: OpenWRT, 路由器, 网络
redirect_from:
  - /post/41.html
---
* content
{:toc}

最近在使用石像鬼（Gargoyle） 1.9.0的时候发现QOS流量监控有的时候会不能用，此时QOS功能也会发生异常，数据包不能正常分类，所有的数据包都被分成默认类别了。经过多次重置，终于发现产生此问题的原因是什么了。
<!--more-->

产生此BUG的原因在于使用了官方的简体中文语言包，该语言包中的qos.js文件存在问题，会使QOS（下载）设置中的MinRTT功能不能启用，数据包分类异常，同时会使流量监控功能失效。

解决方法很简单，只要只要使用英文语言包的同名文件进行替换，即可恢复正常。

懒人只需在终端中输入以下命令即可：

```Shell
cp -f /www/i18n/English-EN/qos.js /www/i18n/SimplifiedChinese-ZH-CN/qos.js
```