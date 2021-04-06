---
title: terminalTips
date: 2021-04-06 11:16:22
tags:
---



# Terminal Tips

## 常用系统命令

```shell
shutdown -r now // 重启
shutdown now    // 关机

pmset -g                   // 显示电源管理设置信息
sudo pmset displaysleep 15 // 设置显示器无活动15分钟后关闭
sudo pmset sleep 30        // 计算机无活动30分钟后休眠
```



## 快捷键

1. Command + L：清空一行
2. Command + K：清空全部

## 使用 sudo 快速执行上一条命令

```shell
sudo !!
```

> 如果由于你忘了使用sudo而导致命令行返回一个错误，只需输入sudo !!就可以用sudo来执行上一条指令。



