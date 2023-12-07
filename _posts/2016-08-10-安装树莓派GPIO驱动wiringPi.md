---
layout: post
date: 2016-08-10 22:22:37 +0800
title: "安装树莓派GPIO驱动wiringPi"
slug: "1470838168"
categories: 软件应用
tags: 树莓派, Linux  
redirect_from:
  - /post/45.html
---
* content
{:toc}

Raspberry Pi有许多的GPIO（General Purpose Input Output：通用输入/输出），可以用来控制和读取数字电路中TTL电平的逻辑0和逻辑1。我们要使用RPi的GPIO首先要知其GPIO的定义，常用的有两种编号定义：WiringPi Pin和BCM GPIO。GPIO的驱动库有两种给大家，一种为C语言的WiringPi，另一种为python的RPi.GPIO。在此介绍如何使用wiringPi。
<!--more-->

首先安装GPIO驱动，使用C语言编写的wiringPi，可以在终端中直接使用。

可以使用下面的代码，也可以参考[官方教程](http://wiringpi.com/download-and-install/)。

```Shell
sudo apt-get install git-core gcc automake autoconf libtool make
git clone git://git.drogon.net/wiringPi
cd wiringPi
git pull origin
./build
```

测试是否安装成功

```Shell
gpio -v
```

查看针脚信息

```Shell
gpio readall
```

![](/upload/2016/08/10/1.jpg)

其中Physical列是针脚按从左到右、从上到下的顺序进行的编号，Mode是针脚当前的模式，wPi列标注的数字就是wiringPi使用的GPIO编号，跟name列一一对应，我们一般可以使用的端口就是名称是GPIO.*这些。

下面以控制LED灯为例进行讲解

将LED灯的信号端连接任意一个GPIO插口，如Pin36#，就是wPi针脚的27#，GND端连接GND。

输入以下命令控制LED灯开启

```Shell
#将27#wPi针脚的模式设置为输出
gpio mode 27 out
#使27#wPi针脚输出一个高电压
gpio write 27 1
```

此时LED灯就会亮起来了。

想要关闭LED灯，只需要再输入以下命令即可

```Shell
gpio write 27 0
```

wiringPi可以在终端中直接使用，所以也可以直接在Shell脚本中使用，因此可以有许多复杂的使用方法。可以使用man gpio命令查看各种功能的使用方法。