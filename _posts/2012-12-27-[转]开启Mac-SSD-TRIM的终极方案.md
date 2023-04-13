---
layout: post
date: 2012-12-27 22:04:39 +0800
title: "[转]开启Mac SSD TRIM的终极方案"
slug: "1356616863"
categories: Mac
tags: Mac
---
* content
{:toc}

cnBeta介绍过开启Mac SSD TRIM的方案，但是没能成功。细细察看后，发现原因在于不同的系统和机型原来有不用的系统文件，不能套用。这里给出一个较全面的方案。
<!--more-->
Enable SSD TRIM for Mac, Ultimate Solution. TRIM终极方案 我的Mac机型是Mac mini Late 2012，把硬盘换成了SSD。试了多种打开SSD TRIM的教程，总不能成功，有一次还弄到系统无法启动。今天大盘开始盘整了，于是可以静下心来把那些教程仔细debug一遍，发现了问题所在，成功开启了SSD TRIM。

最重要的先讲：在做这个工作之前，用Time Machine备份机器。

 其次是怎么会弄到系统无法启动？原因是在改写IOAHCIBlockStorage这个文件的时候，把权限破坏了。一旦权限不对，系统会显示警告窗口，说无法加载IOAHCIBlockStorage。千万不要忽视这个警告，去重启机器，而是应该先修复权限。最简单最彻底的办法就是使用Disk Utility，选择系统盘，然后Repare Disk Permissions.

为什么有些教程会不起作用呢？这是因为不同的系统版本，如10.8.1、10.8.2，加上不同的机型，特别是新机型，系统文件有可能是不一样的。

如果教程不起作用，那就要先理解这些开启SSD TRIM办法的实质：其实就是把IOAHCIBlockStorage文件中硬盘型号的字符“APPLE SSD”这九个字节抹去，替换成全零字节。但是在整个文件中做全替换也不行，只能替换含义为硬盘型号字符的字节。

就因为各种系统和机型的文件不同，同时又要选择性地做替换，于是出现了不同的教程。这里介绍的终极方案，就是先查看你机器上的IOAHCIBlockStorage文件，然后修改教程中的一条命令，然后再执行那些命令。

![201501291422538674660576](https://user-images.githubusercontent.com/99892/231785005-30c298c9-c153-41ab-8c5e-714371719dd5.png)

用一个二进制编辑器（比如说“Hex Fiend”）打开位于/System/Library/Extensions/IOAHCIFamily.kext/Contents/PlugIns/IOAHCIBlockStorage.kext/Contents/MacOS/的IOAHCIBlockStorage文件，搜索十六进制“52 6F 74 61 74 69 6F 6E 61 6C 00”，也就是“Rotational”字串加上0结尾。整个文件我就只搜到一个匹配的。查看后面是不是9个字符的“APPLE SSD”，如果是的话，就看“APPLE SSD”接下来的字符是什么。图中是“Time To Ready”，记下这个字串的第一个字符，是“T”，他的十六进制是54。

接下来就修改那些教程中的命令，请看https://gist.github.com/3334193，点击“Download Gist”下载文件，然后双击打开，就会自动解压缩。修改文件enable_trim.sh中的(x00{1,20}x51)中的51为上文的54，修改完就是(x00{1,20}x54)，保存文件。解压的这个enable_trim.sh文件是没有执行权限的，那就在控制台运行“chmod 755 enable_trim.sh”，赋予执行权限。

在运行“./enable_trim.sh”之前，一定要保证你现在目录/System/Library/Extensions/IOAHCIFamily.kext/Contents/PlugIns/IOAHCIBlockStorage.kext/Contents/MacOS/中的IOAHCIBlockStorage文件一定是未经修改的原系统文件。执行完毕后，系统如果没有弹出什么提示框，那就万事大吉了。有兴趣的话，你还可以用Hex Fiend查看一下修改后的文件，和原文件相比，有啥不同。

![201501291422538690106200](https://user-images.githubusercontent.com/99892/231785157-0a0c314c-857c-4516-9f46-1d74c8f13883.png)

手工重启机器后，应该就是成功了。

![201608101470825319856686](https://user-images.githubusercontent.com/99892/231785241-f6a3cbb8-c397-45a8-ad6e-12a3fdb1005f.png)


>原文：http://www.cnbeta.com/articles/219752.htm
