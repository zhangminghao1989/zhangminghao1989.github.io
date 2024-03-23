---
layout: post
date: 2024-03-23 17:41:13 +0800
title: "QNAP 威联通NAS QTS-416使用非管理型UPS实现停电后自动关机"
slug: "1711186873"
categories: 软件应用
tags: NAS Linux
---
* content
{:toc}

本文脚本仅在威联通 QTS-416上测试通过，其他机型需自行修改适配。
<!--more-->
原理是使用NAS跑脚本ping路由器或者某个没断电可以正常网络联通的设备，如果断电，这个设备必然ping不通，超过一定次数，可判定为断电，调用脚本关机。

## 关机脚本

```Shell
#!/bin/bash

function usage()
{
echo "$ARG0 usage:
    $ARG0 -c check parameter
    $ARG0 -h help
    $ARG0 -d drill,not really shutdown
    "
}
# write qnap log
log=true
# UPS live minute
live_min=10
# nas shutdown cost minute
shutdown_min=5
# buffer minute
buffer_min=3
# ping check count
check_cnt=5
# ping check interval seconds
interval_sec=3
# ping ip,default can set router
ip=192.168.1.1
# script crontab iterval
task_interval_sec=60
# shutdown cost second= shutdown cost + buffer time
shutdown_buffer_cost_min=`expr $shutdown_min + $buffer_min`
#echo "shutdown_buffer_cost_min = $shutdown_buffer_cost_min"
shutdown_buffer_cost_sec=`expr $shutdown_buffer_cost_min \* 60`
#echo "shutdown_buffer_cost_sec = $shutdown_buffer_cost_sec"
# check cost = check interval * check_count
check_cost_max_sec=`expr $interval_sec \* $check_cnt`
#echo "check_cost_max_sec = $check_cost_max_sec"

# check can use seconds = live_min - shutdown_cost - one_crontab_interval
check_can_use_sec=`expr $live_min \* 60 - $shutdown_buffer_cost_sec - $check_cost_max_sec - $task_interval_sec`
#echo "check_can_use_sec = $check_can_use_sec"
DRILL=false
while getopts "dhc" opts
do
    case $opts in
    c)
        echo "shutdown cost(s)      = $shutdown_buffer_cost_sec s"
        echo "ping check cost(s)    = $check_cost_max_sec s"
        echo "ping check can use(s) = $check_can_use_sec s"
        if [ $check_cost_max_sec -gt $check_can_use_sec ]; then
            echo "alert:ping check cost time < ping can use time !!! may got not enought time to shutdown"
        else
            echo "parameter all OK!!!"
        fi
        exit;
    ;;
    h)
    usage; exit;
    ;;
    d)
        DRILL=true
    esac
done

# ping fail counter
fail_cnt=0
while [ $fail_cnt -le $check_cnt ]; do
    now=`date "+%Y-%m-%d %H:%M:%S"`
    if ping -c 1 $ip > /dev/null; then
        echo "$now $ip ping success"
        if [ $log = true ]; then
            log_tool -t 0 -N "Power Check" -G "NAS Power Status" -a "[Power Check] ping success" 4
        fi
        break
    else
        let fail_cnt++
        echo "$ip ping fail,count $fail_cnt"
        log_tool -t 0 -N "Power Check" -G "NAS Power Status" -a "[Power Check] $ip ping fail,fail count $fail_cnt" 4
        if [ $fail_cnt -ge $check_cnt ]; then
            echo "$now $ip ping fail,fail count $fail_cnt great than $check_cnt,start to shutdown NAS"
            if [ $log = true ]; then
                log_tool -t 1 -N "Power Check" -G "NAS Power Status" -a "[Power Check] ping fail count great than $check_cnt, shut down NAS" 2
            fi
            if [ $DRILL = true ]; then
                echo "drill end ,$ip check fail"
                exit;
            else
                /sbin/poweroff
            fi
            break
        fi
        sleep $interval_sec
    fi
done
```

* -h 可以查看帮助
* -d 演习模式，不会实际执行关机指令，可以测试下脚本是否跑通
* -c 会根据配置参数计算出是否有足够实际来做ping检测和关机操作，具体为：  
检测可用时间 = ups断电支持时间 - NAS关机时间 - 机动时间 - crontab时间间隔  
检测时间 = 检测间隔 * 一次ping时间  
如果 检测可用时间<检测时间，会提示，此时需要调整参数，保证NAS有足够时间关机  

## 需要配置的参数
```Shell
# 是否输出qnap日志，默认开
log=true
# 断电后，UPS预估关机耗时，单位分钟
live_min=10
# NAS关机预估耗时，单位分钟
shutdown_min=5
# 预留机动时间，单位分钟
buffer_min=3
# ping检查失败最大次数
check_cnt=5
# ping检查间隔
interval_sec=3
# ping的IP，一般为路由器
ip=192.168.1.1
# 脚本在crontab内的调用间隔，单位秒，根据crontab配置调整，只用于使用-c参数时计算时间，不影响实际执行效果
task_interval_sec=60
```

## crontab配置
crontab 配置方式详细可以参考[https://wiki.qnap.com/wiki/Add_items_to_crontab](https://wiki.qnap.com/wiki/Add_items_to_crontab)
```Shell
vi /etc/config/crontab
```
添加内容，按实际脚本路径修改命令。
```Shell
* * * * * /share/CACHEDEV1_DATA/homes/admin/powerchk.sh
```
重启crontab
```Shell
crontab /etc/config/crontab && /etc/init.d/crond.sh restart
```

参考文章：
> https://blog.csdn.net/asynct/article/details/103826950
