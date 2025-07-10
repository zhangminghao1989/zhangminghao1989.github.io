---
layout: post
date: 2016-08-25 22:42:47 +0800
title: "在Linux终端环境中使用Socks5代理"
slug: "1472134168"
categories: 软件应用
tags: Linux, 科学上网, 软件应用
redirect_from:
  - /post/48.html
---
* content
{:toc}

在Linux终端环境中只支持http代理，本文介绍两种使用Socks5代理的方法。
<!--more-->

## 一、使用Proxychains
### 1.安装Proxychains

在终端中输入以下命令

```Shell
git clone https://github.com/rofl0r/proxychains-ng.git
cd proxychains-ng
./configure --prefix=/usr --sysconfdir=/etc
make
sudo make install
sudo make install-config
```

### 2.配置Proxychains

修改/etc/proxychains.conf文件

```
[ProxyList]
# 将代理服务器添加到此处
# 格式:
#  socks5   192.168.67.78   1080  lamer   secret
#  http       192.168.89.3     8080  justu    hidden
#  socks4   192.168.1.49     1080
#  http       192.168.39.93   8080 
#  支持的代理种类: http, socks4, socks5
#  支持的验证模式: "basic"-http  "user/pass"-socks
socks5 127.0.0.1 1080
```

### 3.使用Proxychains

当前Proxychains的版本是4.11，所以编译的二进制程序名是proxychains4，按以下格式使用

```Shell
proxychains4  wget www.google.com
```

## 二、设置全局代理

1.使用Privoxy将Socks5代理转换为http代理

详细步骤参考[使用树莓派建立公共Http代理服务器](https://www.zhangminghao.com/2016/08/24/1472047768/)

2.输入以下命令

```Shell
export http_proxy=127.0.0.1:8118
export https_proxy=127.0.0.1:8118
export ftp_proxy=127.0.0.1:1080
```

http和https协议走Privoxy的http代理，ftp协议可以走socks代理

3.设置为默认代理

将上述命令添加到个人文件夹的`.bashrc`文件末端，就可以使每次开启终端都自动设置代理。

4.部分程序需要单独设置，如git
