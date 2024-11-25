---
title: iOS_Learning_Notes
date: 2021-08-18 16:43:57
tags:
---



# iOS Learning Notes



## LLVM

### Clang

#### STEP

1.   预处理 pre-process：

     include 扩展、标记化处理、去除注释、条件编译、宏删除、宏替换。对`C`输出`.i`, 对`C++`输出 `.ii`, 对 OC 输出 `.mi`, 对`Objective-C++ `输出 `.mii`；

2.   词法分析 lexical analysis：

     lexer 将代码切成一个个 token，比如大小括号，等于号还有字符串等。是计算机科学中将字符序列转换为标记序列的过程；

3.   语法分析（Semantic Analysis）：验证语法是否正确，然后将所有节点组成抽象语法树 AST 。由 Clang 中 Parser 和 Sema 配合完成；

4.   静态分析（Static Analysis）：使用它来表示用于分析源代码以便自动发现错误；

5.   中间代码生成（Code Generation）：开始 IR 中间代码的生成了，CodeGen 会负责将语法树自顶向下遍历逐步翻译成 LLVM IR。
