---
layout: post
date: 2017-10-26 23:17:59 +0800
title: "在Debian中启用sudo"
slug: "1509026968"
categories: Linux
tags: Linux, 软件应用
redirect_from:
  - /post/52.html
---
* content
{:toc}

刚安装好的Debian默认是没有sudo功能的，用以下方法可开启sudo功能。
<!--more-->

## 一、安装sudo
```Shell
su
apt-get install sudo
```

## 二、将用户加入sudo组
将需要启用sudo功能的用户加入sudo组（user为用户名）。

```Shell
adduser user sudo
```

至此user已可以正常使用sudo

## 三、配置文件解析
使用`visudo`命令可以修改sudo的配置文件`/etc/sudoers`文件，而且会自动检查配置文件语法，保存时会显示保存为`/etc/sudoers.tmp`文件，直接保存即可，无需修改文件名。

根据我的测试，对同一个用户生效的规则，后面的规则会覆盖前面的规则，在编写配置文件时需要注意。

我们来看看sudoers配置中的root用户，root用户可以做任何事情：

```Shell
root ALL=(ALL:ALL) ALL
```

* root指root用户
* 第一个ALL表示此规则适用于从所有主机登录的root用户
* 第二个ALL表示root用户可以作为所有用户运行命令
* 第三个ALL表示root用户可以作为所有组运行命令
* 第四个ALL表示此规则适用于所有命令

允许用户组使用sudo

```Shell
%sudo ALL=(ALL:ALL) ALL
```

此处%sudo指sudo用户组，由于此条配置的存在，所以将任意用户直接加入sudo用户组即可使该用户使用sudo命令。

允许特定用户使用sudo命令而不需要密码

```Shell
user ALL(ALL:ALL) NOPASSWD:ALL
```

其中最后一个ALL可以修改为指定程序路径，则此用户使用sudo运行指定程序时不需要密码。如果该用户同时是sudo用户组的成员，则此条配置必须在`%sudo ALL=(ALL:ALL) ALL`后面才可生效。

## 四、实例应用
在WinSCP中使普通用户以root权限登录

### 1.获取sftp程序路径

```Shell
sudo cat /etc/ssh/sshd_config | grep sftp
```

结果：

```Shell
Subsystem sftp /usr/lib/openssh/sftp-server
```

### 2.配置sudo

使用visudo修改配置文件，使sftp-server可以免密码使用sudo运行

```Shell
user ALL=(ALL:ALL) NOPASSWD:/usr/lib/openssh/sftp-server
```

如果user在sudo用户组内，则此条配置必须在`%sudo ALL=(ALL:ALL) ALL`后面才能生效。

将`Defaults requiretty`这一行注释掉，这一步的目的是关闭可交互终端需求。

### 3.修改WinSCP设置

使用SFTP协议，在“高级设置-环境-SFTP-SFTP服务器”中输入`sudo /usr/lib/openssh/sftp-server`保存即可。

参考
>https://serversforhackers.com/c/sudo-and-sudoers-configuration
