---
layout: post
date: 2013-03-31 20:51:31 +0800
title: "[转]全面详解Linux日志管理技巧_使用shell向syslog日志文件写入信息"
slug: "1364727702"
categories: 网络
tags: Linux, DD-WRT, 路由器
redirect_from:
  - /post/25.html
---
* content
{:toc}

## 1.使用shell向syslog日志文件写入信息

应用程序使用syslog协议发送信息给Linux系统的日志文件(位于`/var/log`目录). Sysklogd提供两个系统工具: 一个是系统日志记录, 另一个是内核信息捕获. 通常大多程序都使用C语言或者syslog应用程序或库来发送syslog消息.  
<!--more-->
下面介绍如何使用shell向syslog日志文件写入信息:

### 1).使用Logger命令

logger命令是一个shell命令(接口). 你可以通过该接口使用syslog的系统日志模块 你还可以从命令行直接向系统日志文件写入一行信息.  
比如, 记录硬盘升级后的系统重启信息:  
```Shell
logger System rebooted for hard disk upgrade
```
然后你可以查看`/var/log/message`文件:  
```Shell
tail -f /var/log/message
```
输出为:  
```Shell
Jan 26 20:53:31 dell6400 logger: System rebooted for hard disk upgrade
```
你也可以通过脚本程序来使用`logger`命令. 看下面的实例:  
```Shell
#!/bin/bash
HDBS="db1 db2 db3 db4"
BAK="/sout/email"
[ ! -d $BAK ] && mkdir -p $BAK || :
/bin/rm $BAK/*
NOW=$(date +"%d-%m-%Y")
ATTCH="/sout/backup.$NOW.tgz"
[ -f $ATTCH ] && /bin/rm $ATTCH || :
MTO="you@yourdomain.com"
for db in $HDBS
do
FILE="$BAK/$db.$NOW-$(date +"%T").gz"
mysqldump -u admin -p'password' $db | gzip -9> $FILE
done
tar -jcvf $ATTCH $BAK
mutt -s "DB $NOW" -a $ATTCH $MTO < DBS $(date)
EOF
[ "$?" != "0" ] && logger "$0 - MySQL Backup failed" || :
```
如果mysql数据库备份失败, 上面最后一行代码将会写入一条信息到`/var/log/message`文件.

### 2).其它用法

如果你需要记录`/var/log/myapp.log`文件中的信息, 可以使用:  
```Shell
logger -f /var/log/myapp.log
```
把消息发送到屏幕(标准错误), 如系统日志:  
```Shell
logger -s "Hard disk full"
```
你可以参考man参考页获得更多的选项信息:  
```Shell
man logger
man syslogd
```

## 2.输出iptables日志到一个指定的文件

iptables的man参考页中提到: 我们可以使用`iptables`在linux内核中建立,维护和检查IP包过滤规则表.几个不同的表可能已经创建,每一个表包含了很多内嵌的链, 也可能包含用户自定义的链.  
iptables默认把日志信息输出到`/var/log/messages`文件.不过一些情况下你可能需要修改日志输出的位置.下面向大家介绍如何建立一个新的日志文件`/var/log/iptables.log`.通过修改或使用新的日志文件, 你可以创建更好的统计信息或者帮助你分析网络攻击信息.  

### 1).iptables默认的日志文件

例如, 如果你输入下面的命令, 屏幕将显示`/var/log/messages`文件中的iptables日志信息:  
```Shell
tail -f /var/log/messages
```
输出:  
```Shell
Oct 4 00:44:28 debian gconfd (vivek-4435): Resolved address "xml:readonly:/etc/gconf/gconf.xml.defaults" to a read-only configuration source at position 2
Oct 4 01:14:19 debian kernel: IN=ra0 OUT= MAC=00:17:9a:0a:f6:44:00:08:5c:00:00:01:08:00 SRC=200.142.84.36 DST=192.168.1.2 LEN=60 TOS=0x00 PREC=0x00 TTL=51 ID=18374 DF PROTO=TCP SPT=46040 DPT=22 WINDOW=5840 RES=0x00 SYN URGP=0
```

### 2).输出iptables日志信息到一个指定文件的方法

打开你的`/etc/syslog.conf`文件:  
```Shell
vi /etc/syslog.conf
```
在文件末尾加入下面一行信息  
```Shell
kern.warning /var/log/iptables.log
```
保存和关闭文件.  
重新启动syslogd(如果你使用Debian/Ubuntu Linux):  
```Shell
/etc/init.d/sysklogd restart
```
另外, 使用下面命令重新启动syslogd(如果你使用Red Hat/Cent OS/Fedora Core Linux):  
```Shell
/etc/init.d/syslog restart
```
现在确认你的iptables使用了log-level 4参数(前面有一个log-prefix标志).例如:  
```Shell
DROP everything and Log it
iptables -A INPUT -j LOG –log-level 4
iptables -A INPUT -j DROP
```
举一个例子, 丢弃和记录所有来自IP地址65.55.11.2的连接信息到`/var/log/iptables.log`文件.  
```Shell
iptables -A INPUT -s 64.55.11.2 -m limit --limit 5/m --limit-burst 7 -j LOG –log-prefix ‘** HACKERS **’ --log-level 4
iptables -A INPUT -s 64.55.11.2 -j DROP
```
命令解释:  
* --log-level 4 :记录的级别.级别4为警告(warning).  
* -log-prefix ‘*** TEXT ***’ :这里定义了在日志输出信息前加上TEXT前缀.TEXT信息最长可以是29个字符,这样你就可以在记录文件中方便找到相关的信息.  

现在你可以通过/var/log/iptables.log文件参考iptables的所有信息:  
```Shell
tail -f /var/log/iptables.log
```

原文：
>http://www.linuxidc.com/Linux/2007-05/4097.htm
