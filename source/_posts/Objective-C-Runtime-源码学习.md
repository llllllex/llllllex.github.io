---
title: Objective-C Runtime 源码学习
date: 2021-09-06 16:46:37
tags:
---



# Objective-C Runtime源码学习

## 项目结构

-   `Public Headers`
-   `Private Headers`
-   `Project Headers`
-   `Source` ( Implementation )
-   `Obsolete Headers`
-   `Obsolete Source`



## 重点概念及数据结构

1.   objc_object

     >   Represents an instance of a class.

     ```c
     struct objc_object {
         Class _Nonnull isa  OBJC_ISA_AVAILABILITY;
     };
     ```

     

2.   id

     >   A pointer to an instance of a class.

     ```c
     typedef struct objc_object *id;
     ```

     

