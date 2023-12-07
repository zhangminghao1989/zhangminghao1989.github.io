---
layout: post
date: 2019-12-29 23:25:12 +0800
title: "在Debian 10系统上搭建ERPNext系统"
slug: "1577628568"
categories: 软件应用
tags: Web, 软件应用, Linux, ERP
redirect_from:
  - /post/55.html
---
* content
{:toc}

本文介绍在Debian 10系统上搭建ERPNext系统的方法。
<!--more-->

本人收费提供ERPNext系统搭建、定制、运维服务，有需要的老板请与我联系。

## 硬件要求
| 网站数量 | 每个站点的用户 | 内存（GB） | 磁盘空间（GB） | 处理器 |
| --- | --- | --- | --- | ---
| 1 | 5-10 | 4 | 40 | 2
| 1 | 10-30 | 4 | 40 | 2
| 1-5 | 5-10 | 8 | 40 | 2
| 1-5 | 10-30 | 16 | 80 | 4
| 5-10 | 5-10 | 16 | 80 | 4
| 5-10 | 10-30 | 32 | 160 | 8

## 安装基础运行环境
```Shell
sudo apt-get install xvfb libfontconfig wkhtmltopdf
sudo apt-get install git python-dev python3-dev python-setuptools python-pip python3-setuptools python3-pip
```

## 安装MySQL
使用Debian默认的10.3版本

```Shell
sudo apt-get install mariadb-server
```

按提示设置root用户密码

```Shell
sudo mysql_secure_installation
```

设置使用密码登陆mysql

```Shell
sudo mysql -u root
```

然后在SQL终端中输入以下命令

```SQL
use mysql;
update user set plugin='' where User='root';
flush privileges;
exit;
```

安装MySQL开发文件

```Shell
sudo apt-get install default-libmysqlclient-dev
```

修改MySQL配置文件

```Shell
sudo nano /etc/mysql/my.cnf
```

添加以下内容

```
[mysqld]
character-set-client-handshake = FALSE
character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci
[mysql]
default-character-set = utf8mb4
```

重启MySQL

```Shell
sudo service mysql restart
```

## 安装其他运行环境
```Shell
sudo apt-get install redis-server
sudo apt-get install curl
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
nvm install 12
npm install -g yarn
```

## 安装ERPNext
```Shell
pip install frappe-bench
```

**注销并重新登陆**

安装Frapp并指定版本号为12

```Shell
bench init --frappe-branch version-12 frappe-bench
cd ~/frappe-bench
./env/bin/pip install -e apps/frappe/
./env/bin/pip3 install -e apps/frappe/
bench start
```

打开一个新的终端

```Shell
cd frappe-bench/
bench new-site erpnext.site
bench get-app --branch version-12 erpnext
./env/bin/pip install -e apps/erpnext/
./env/bin/pip3 install -e apps/erpnext/
```

创建一个名称为`erpnext.site`的工作台，按提示输入MySQL root用户密码，并设置ERPNext管理员密码。

```Shell
bench --site erpnext.site install-app erpnext
```

设置生产模式（即开机自动运行）

```Shell
cd ~/frappe-bench/
sudo apt-get install nginx
bench setup nginx
sudo ln -s `pwd`/config/nginx.conf /etc/nginx/sites-enabled/frappe-bench.conf
sudo rm /etc/nginx/sites-enabled/default
sudo nginx -s reload
sudo apt-get install supervisor
bench setup supervisor
sudo ln -s `pwd`/config/supervisor.conf /etc/supervisor/conf.d/frappe-bench.conf
```

设置自动备份

```Shell
bench setup backups
```

## 修复运行故障
### 修复PDF乱码
将Windows相关字体复制到`/usr/share/fonts`目录，然后执行

```Shell
fc-cache -fv
```

修复redis启动异常
```Shell
sudo su
echo "vm.overcommit_memory=1" >> /etc/sysctl.conf
echo "net.core.somaxconn=511" >> /etc/sysctl.conf
```
```Shell
sudo nano /etc/rc.local
```

添加以下内容

```Shell
#!/bin/sh
echo never > /sys/kernel/mm/transparent_hugepage/enabled
exit 0
```

设置运行权限并重启

```Shell
sudo chmod +x /etc/rc.local
sudo reboot
```

## 完成安装
用浏览器打开服务器80端口，按提示初始化网站即可。