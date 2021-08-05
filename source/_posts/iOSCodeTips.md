---
title: iOSCodeTips
date: 2021-04-27 17:58:07
tags:
---

# iOS Code Tips ( acknowledge )

> https://nshipster.cn

## 编译器优化

### `__attribute__`

方法签名后，通过`__attribute__((<#标志#>))`来进行注释。

#### pure 和 const

e.g. 1

```objective-c
// pure 代表该函数除了使用了传入参数和/或全局变量外没有其他副作用。
- (NSString *)todayDisplayedText __attribute__((pure));
```

e.g. 2

```objective-c
// const 表明该函数出了传入参数外不依赖于任何东西，这个函数的结果可以被缓存起来。后面调用时若参数相同，可以直接返回缓存的结果。
// 在这个示例中，一个数的平方值计算总是固定的，不依赖于其他变量或指针。
int square(int n) __attribute__((const));
```

#### unused

> 当对一个函数增加了这个声明时，意味着这个函数可能不被使用，GCC不会对这个函数产生警告。

使用 `__unused` 关键字可以达到同样的效果，可以在方法实现中声明没有被使用的参数。通过了解这个上下文，编译器可以进行相应的优化。你更可能会在 delegate 的方法实现里使用 `__unused`，因为 protocols 为了支持更多可能的用例经常会提供必要的参数之外的上下文。

#### availability

e.g.

```objective-c
void f(void) __attribute__((availability(macosx, introduced=10.4, deprecated=10.6, obsolited=10.7)));
```

> availability 属性是一个用逗号分隔的列表，第一项是平台名称，然后是可选的生命周期当中重要的里程碑时间，最后是额外信息。

- availability 声明被引入的第一个版本
- deprecated 声明被废弃的第一个版本，意味着用户应当从这个 API 迁移到另外的方法
- obsoleted 声明被废弃的第一个版本，意味着被彻底删除不能使用了
- unavailable 声明在这个平台上从来就是不可用的
- message 额外的文本信息，Clang 在对于废弃和淘汰声明给出警告或者错误的时候会提供这些信息，可以用于指导用户进行 API 替换

> 在同一个声明上可以添加多个可用性属性，它们可能是针对不同平台的。只有当前和目标平台对应的平台可用性属性会发挥作用，其他的属性会被忽略掉。如果没有和当前目标苹果对应的可用性属性，整个可用性属性会被忽略。

##### 支持的平台

- `ios`: 苹果 iOS 操作系统。最低的部署目标通过 `-mios-version-min=*version*`或者 `-miphoneos-version-min=*version*` 命令行参数指定。
- `macosx`: 苹果 OS X 操作系统。最低的部署目标通过 `-mmacosx-version-min=*version*` 命令行参数指定。

#### overloadable

> Clang 在 C 语言中提供了 C++ 函数重载支持，通过 `overloadable` 这个属性实现。例如我们要提供多个不同重载版本的 `tgsin` 函数，它会调用合适的标准库函数，分别提供对 `float`，`double` 和 `long double` 精度的值计算 `sine`值。

```objective-c
#include <math.h>
float __attribute__((overloadable)) tgsin(float x) { return sinf(x); }
double __attribute__((overloadable)) tgsin(double x) {return sin(x); }
long double __attribute__((overloadable)) tgsin(long double x) { return sinl(x); }
```

注意:  `overloadable`只能用于函数。你可以通过使用 `id` 和 `void *` 这种泛型的返回值和参数类型，在一定程度上实现方法声明的重载。



## #pragma 代码整理

### #pragma mark - <#标签文本#>

e.g.

```objective-c
#pragma mark - <#title#>
```



### #pragma GCC warning "<#警告文本#>"

e.g.

```objective-c
#pragma GCC warning "TODO: implemente here"
```



### #pragma clang diagnostic push / ignored "" / pop

e.g.

```objective-c
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
// 需要被忽略参数循环饮用警告的代码
/*
self.completionBlock = ^{
	// ...
}
*/
#pragma clang diagnostic pop
```



## BOOL / bool / Boolean / NSCFBoolean

> https://nshipster.cn/bool/

| Name         | Typedef</tt>  | Header           | True Value     | False Value     |
| ------------ | ------------- | ---------------- | -------------- | --------------- |
| Bool         | signed char   | objc.h           | YES            | NO              |
| bool         | _Bool(int)    | stdbool.h        | true           | false           |
| Boolean      | unsigned char | MacTypes.h       | TRUE           | FALSE           |
| NSNumber     | __NSCFBoolean | Foundation.h     | @(YES)         | @(NO)           |
| CFBooleanRef | struct        | CoreFoundation.h | kCFBooleanTrue | kCFBooleanFalse |



## 指针 & 和 *

```objective-c
NSString * a;
```

a: 指向NSString实例对象a的指针（在使用时，对a的操作被解读为调用实例对象的get/set和其他实例方法调用）

*a: 实力对象a指向的数据

&a: 指针本身（指针数据）



## XIB 布局问题

通过xib 加载的文档在viewDidLoad中加载的时候并不会去布局frame ，只是拿到xib 中设置的大小属性，只有在 viewDidLayoutSubViews 里才会去根据布局去确定控件的最终尺寸(不过添加view 的操作不能放在这里，因为这个方法会调用多次)



## `NSOrderedSet`

### 继承关系

> `NSOrderedSet` 不是 `NSSet` 的子类。

`NSObject` <- `NSSet` <- `NSMutableSet`

`NSObject` <- `NSOrderdSet` <- `NSMutableOrderedSet`

### 注意事项

因为 `NSMutableOrderedSet` 既不是 `NSSet` 也不是 `NSMutableSet`，因此需要尽可能避免对 `NSOrderedSet` 的使用。这个类的主要使用场景在 CoreData。



## 代码整理和优化

1.   View 重用

     在 View 结构相同，内容可以根据有限的几种数据类型变化时，可以通过：

     1.   枚举值；

     2.   多个不同态的便利构造器（即使用`工厂方法`）；

     3.    ViewModel + 便利构造器

          来解耦数据代码和视图代码。





## 不常用属性

1.   `isViewLoaded`

     >   Use isViewLoaded to check if a view is currently loaded into memory.



