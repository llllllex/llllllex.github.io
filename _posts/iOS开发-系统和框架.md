---
title: iOS开发-系统和框架
date: 2021-09-16 11:14:28
tags:
---



现在的苹果系统是在某个unix的分支系统的基础上进行构建的（具体哪个我忘了），线程间通信使用端口消息，比较底层的框架是CoreXxx。

负责界面渲染的是CoreAnimation，这一套渲染框架是横跨iOS、macOS等的（tvOS和watchOS相关的开发我还没碰过没了解过，这块不清楚是不是一样）。

>   虽然叫CoreAnimation，但是实际上是负责界面渲染与绘制的框架，请不要被名字误导了。



在此基础上，不同的系统因为不同的交互方式，有一层负责交互任务处理的封装，在macOS的界面框架AppKit上叫`NSView`，在iOS的界面框架UIKit上叫做`UIView`，这一层封装负责处理各个平台不同的交互，渲染任务的处理还是由CoreAnimation负责处理——对应的类叫做`CALayer`。

对于SwiftUI来讲，他是DSL(Domain Specific Development Language)，从语法设计上可以直接类比XML，HTML，实际上第一层解析的实现和处理是转化为对应的命令式的Swift方法调用来处理的。在不同平台上，具体的SwiftUI的实现是通过不同平台的界面框架来实现的。



SwiftUI的基础代码架构是MVVM，因为它将View通过DSL完全独立开来，数据的引用（数据流、App状态数据，临时状态数据（e.g.控制流参数、界面临时状态））是通过依赖注入的方式加入到View的。

UIKit的基础代码架构是MVC，一个Controller和一个View是绑定在一起的，在不进行代码解耦的情况下，业务流，界面绘制，数据获取与处理等各种操作均在这个Controller层进行处理。View实际上是与Controller紧密结合在一起的。
