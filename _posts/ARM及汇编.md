---
title: ARM及汇编
date: 2021-04-06 14:21:55
tags:
---



# ARM 及 汇编



> https://zhuanlan.zhihu.com/p/82490125





![](https://tva1.sinaimg.cn/large/008eGmZEly1gpa06f17azj30n10g9myn.jpg)





## 指令

### 数据传送指令

#### LDR/STR

1. x86 架构：

   寄存器之间 / 寄存器和内存见可以使用 MOV 指令 ；

   允许直接操作内存单元上的数据。

2. ARM架构：

   寄存器之间传送数据使用 MOV / 寄存器和内存之间使用 LDR ( load ) 和 STR ( store )；

   ![img](https://pic1.zhimg.com/80/v2-effe338f1536cce9bf286280cf021de4_1440w.jpg)

   内存单元上的数据不允许被直接操作，必须先放到寄存器中。



#### LTM / STM

一次加载 / 存储多个寄存器



#### LTP / STP ( armv8 x64 )

一次加载 / 存储**最多两个**寄存器

避免产生分散的突发传输( LTM / STM )，高效利用双 pipeline 特性。

> https://www.jianshu.com/p/62ea9cfecf80



