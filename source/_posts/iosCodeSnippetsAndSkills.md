---
title: iosDevSnippetsAndSkills
date: 2021-04-06 11:14:33
tags:
---



# iOS 零散知识点和示例代码块

> 部分内容来源：
>
> [NSHipster]:https://nshipster.cn/





## RunLoop

![](https://tva1.sinaimg.cn/large/008eGmZEly1goxcx5zeedj30u00fmq4q.jpg)





## 内存 & Debug

### 寄存器

fp 寄存器存储了上一帧的地址，类似一个链表的起始地址，通过 fp 不断回溯可以将整个 Backtrace 函数调用栈进行串联。



## 有没有办法将参数的**NSDictionary**附加到**NSURLRequest**而不是手动创建字符串？

[https://cloud.tencent.com/developer/ask/106457](https://cloud.tencent.com/developer/ask/106457)

```objective-c
NSURLComponents *url = [[NSURLComponents alloc] initWithURL:request.URL resolvingAgainstBaseURL:YES];
NSMutableArray *queryItems = NSMutableArray.new;
[params enumerateKeysAndObjectsUsingBlock:^(NSString *name, NSString *value, BOOL *stop) {
   [queryItems addObject:[NSURLQueryItem queryItemWithName:name 
                          value:[value stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet]
                         ]
   ];
}];
url.queryItems = queryItems;
request.URL = url.URL;
```



## 获取屏幕尺寸的两种方法

```objective-c
   CGSize screenSize = UIApplication.sharedApplication.delegate.window.bounds.size;
```



```objective-c
   CGSize screenSize = UIScreen.mainScreen.bounds.size;
```



## Date+Extensions: 判断/获取时间戳/时间差

```swift
extension Date {
   /**
    *  是否为今天
    */
   func isToday() -> Bool{
      let calendar = Calendar.current
      let unit: Set<Calendar.Component> = [.day,.month,.year]
      let nowComps = calendar.dateComponents(unit, from: Date())
      let selfCmps = calendar.dateComponents(unit, from: self)
      
      return (selfCmps.year == nowComps.year) &&
      (selfCmps.month == nowComps.month) &&
      (selfCmps.day == nowComps.day)
      
   }

   /**
    *  是否为昨天
    */
   func isYesterday() -> Bool {
      let calendar = Calendar.current
      let unit: Set<Calendar.Component> = [.day,.month,.year]
      let nowComps = calendar.dateComponents(unit, from: Date())
      let selfCmps = calendar.dateComponents(unit, from: self)
      if selfCmps.day == nil || nowComps.day == nil {
         return false
      }
      let count = nowComps.day! - selfCmps.day!
      return (selfCmps.year == nowComps.year) &&
         (selfCmps.month == nowComps.month) &&
         (count == 1)
   }
   
   ///只有年月日的字符串
   func dataWithYMD() -> String {
      let fmt = DateFormatter()
      fmt.dateFormat = "yyyy-MM-dd"
      let selfStr = fmt.string(from: self)
      let result = fmt.date(from: selfStr)!
      print(result)
      return selfStr
   }
   
   ///获取当前年月日的时间戳
   func timeIntervalWithYMDDate() -> TimeInterval {
      let fmt = DateFormatter()
      fmt.dateFormat = "yyyy-MM-dd"
      let selfStr = fmt.string(from: self)
      let result = fmt.date(from: selfStr)!
      return result.timeIntervalSinceReferenceDate + 24 * 60 * 60
   }
   /**
    *  是否为今年
    */
   func isThisYear() -> Bool {
       let calendar = Calendar.current
       let nowCmps = calendar.dateComponents([.year], from: Date())
       let selfCmps = calendar.dateComponents([.year], from: self)
       let result = nowCmps.year == selfCmps.year
       return result
   }
   /**
    *  获得与当前时间的差距
    */
   func deltaWithNow() -> DateComponents{
      let calendar = Calendar.current
      let cmps = calendar.dateComponents([.hour,.minute,.second], from: self, to: Date())
      return cmps
   }
}
```



## 正则表达式

### 基本语法

特殊的符号"^"与"$",分别表示一个字符串的开始与结束。

"^dog":表示以"dog"开头的字符串（"dog product","dog123","dog" ）

类似于:- (BOOL)hasPrefix:(NSString *)aString;

"dog$":表示以dog为结尾的字符串（"Product Manager is a dog", "it is a dog"）

类似于:- (BOOL)hasSuffix:(NSString *)aString;

"^apple$":表示以"apple"开头且以"apple"结尾的字符串

"banana":表示任何包含"banana"的字符串

类似于 iOS8的新方法- (BOOL)containsString:(NSString *)aString,搜索子串用的。



"*","+","?":分别表示"没有或更多([0, +∞)取整数)","一个或更多([1,+∞)取整数)","没有或一个([0,1]取整数)"

"ab*":表示一个"a"后面按跟着0个或者N个"b"("a","ab","abbbf",这里并没有说是以b结尾)

"ab+":表示一个"a"后面跟着至少一个"b"("ab","abb")

"ab?":表示一个"a"后面跟着一个或者0个"b"("a","abc","af")

"a?b+$":表示字符串末尾有0个或者1个"a"或1个"a"跟着1个或者多个"b"("ab","b","bbb","abbbb",......)



可以用大括号括起来（{}），表示一个重复的具体范围。例如

"ab{4}":表示一个"a"跟着4个"b","abbbb"

'''ab{1,}':表示一个"a"跟着至少1个"b",("ab","abb",....)

"ab{3,4}":表示一个"a"跟着3个或者4个"b"("abbb","abbbb")

所以"*"等于{0,},"+"等于{1,},"?"等于{0,1}。

注意：可以没有上线，但是不能没有下线{,5}为错误写法。



"|"表示“或”操作

"a|b":表示一个字符串中含有"a"或者"b"

"(a|bcd)ef":表示"aef"或者"bcdef"

"(a|b)*c":表示"a"或者"b"后面跟着0或者多个"c"("a","b","ac","accccc","bc","bcccc")

方括号”[ ]“表示在括号内的众多字符中，选择1-N个括号内的符合语法的字符作为结果，例如

"[ab]":表示一个字符串含有"a"或"b"，等价于"a|b"

"[a-d]":表示一个字符串包含a-d中的一个，等价于"a|b|c|d"或者"[abcd]"

"^[a-zA-Z]":表示以字母开头的字符串。

"[0-9]a":表示"a"前面有一个数字。

"[a-zA-Z0-9]$":表示一个字符串以字母或者数字结尾。

".":表示除了"\n","\r"之外的任意单个字符串。

"a.[a-z]":表示一个"a"后面你跟着一个任意一个字符串和一个小写字母。

"^.{5}$":表示任意一个长度是5的字符串。



“\num” 其中num是一个正整数。表示”\num”之前的字符出现相同的个数，例如

"(.)\1":表示两个连续相同的字符。

"10\{1,2\}":表示"1"后面跟着1个或者2个"0"("10","100")

"0\{3,\}":表示至少有3个连续的"0"("000","0000")



在方括号里用’^'表示不希望出现的字符，’^'应在方括号里的第一位。

"@[^a-zA-Z]@":表示两个"@"之间不应该有字母。



常用的正则：

"\d":匹配一个数字字符，等价于"[0-9]".

"\D":匹配一个非数字字符，等价于"[^0-9]"

"\w":匹配包括下划线的任何单词字符，等价于"[a-zA-Z0-9_]"

"\W":匹配任何非单词字符，等价于"[^a-zA-Z0-9_]"



iOS中书写正则表达式，碰到转义字符，多加一个“\”,例如：

全数字字符：@”^\\d\+$”



### 常用正则

(1) 验证电话号码：（”^(\\d{3,4}-)\\d{7,8}$”） 　

(2) 验证Email地址：(“^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\.\\w+([-.]\\w+)*$”)； 　　

(3) 整数或者小数：^[0-9]+([.]{0,1}[0-9]+){0,1}$ 　　

(4) 只能输入数字：”^[0-9]*$”。 　　

(5) 只能输入由26个英文字母组成的字符串：”^[A-Za-z]+$”。 

(6) 验证是否含有^%&’,;=?$\”等字符：”[^%&',;=?$\x22]+”。 　

(7) 只能输入汉字：”^[\u4e00-\u9fa5]{0,}$”。 　　

(8) 验证一年的12个月：”^(0?[1-9]|1[0-2])$”正确格式为：”01″～”09″和”10″～”12″。 　　

(9) 验证一个月的31天：”^((0?[1-9])|((1|2)[0-9])|30|31)$”正确格式为；”01″～”09″、”10″～”29″和“30”~“31”。 　　

(10) 获取日期正则表达式：\\d{4}[年|\-|\.]\\d{\1-\12}[月|\-|\.]\\d{\1-\31}日? 注：可用来匹配大多数年月日信息。 　　

(11) 匹配空白行的正则表达式：\n\s*\r 注：可以用来删除空白行 

(12) 匹配帐号是否合法(字母开头，允许5-16字节，允许字母数字下划线)：^[a-zA-Z][a-zA-Z0-9_]{4,15}$ 注：表单验证时很实用 

(13) 匹配腾讯QQ号：[1-9][0-9]{4,14} 注：腾讯QQ号从10 000 开始 　　

(14) 匹配中国邮政编码：[1-9]\\d{5}(?!\d) 注：中国邮政编码为6位数字 　　

(15) 匹配ip地址：((2[0-4]\\d|25[0-5]|[01]?\\d\\d?)\.){3}(2[0-4]\\d|25[0-5]|[01]?\\d\\d?)。



1. 验证用户名和密码：”^[a-zA-Z]\w{5,15}$” 　　

2. 验证电话号码：（”^([\\d{3,4}-)\\d{7,8}$] 　　eg：021-68686868 0511-6868686； 　　

3. 验证手机号码：”^1[3|4|5|7|8][0-9]\\d{8}$”； 　　

4. 验证身份证号（15位或18位数字）：”\\d{14}[[0-9],0-9xX]”

5. 验证Email地址：(“^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\.\\w+([-.]\\w+)*$”);

6. 只能输入由数字和26个英文字母组成的字符串：(“^[A-Za-z0-9]+$”) ; 

7. 整数或者小数：^[0-9]+([.]{0,1}[0-9]+){0,1}$ 　　

8. 只能输入数字：”^[0-9]*$”。 　　

9. 只能输入n位的数字：”^\\d{n}$”。 　　

10. 只能输入至少n位的数字：”^\\d{n,}$”。 　　

11. 只能输入m~n位的数字：”^\\d{m,n}$”。 　　

12. 只能输入零和非零开头的数字：”^(0|[1-9][0-9]*)$”。 　　

13. 只能输入有两位小数的正实数：”^[0-9]+(.[0-9]{2})?$”。 　

14. 只能输入有1~3位小数的正实数：”^[0-9]+(\.[0-9]{1,3})?$”。 

15. 只能输入非零的正整数：”^\+?[1-9][0-9]*$”。 　　

16. 只能输入非零的负整数：”^\-[1-9][]0-9″*$。 　　

17. 只能输入长度为3的字符：”^.{3}$”。 　　

18. 只能输入由26个英文字母组成的字符串：”^[A-Za-z]+$”。 　

19. 只能输入由26个大写英文字母组成的字符串：”^[A-Z]+$”。 

20. 只能输入由26个小写英文字母组成的字符串：”^[a-z]+$”。 

21. 验证是否含有^%&’,;=?$\”等字符：”[^%&',;=?$\x22]+”。 

22. 只能输入汉字：”^[\u4e00-\u9fa5]{0,}$”。 　　

23. 验证URL：”^http://([\\w-]+\.)+[\\w-]+(/[\\w-./?%&=]*)?$”。 　　

24. 验证一年的12个月：”^(0?[1-9]|1[0-2])$”正确格式为：”01″～”09″和”10″～”12″。 　　

25. 验证一个月的31天：”^((0?[1-9])|((1|2)[0-9])|30|31)$”正确格式为；”01″～”09″、”10″～”29″和“30”~“31”。 　　

26. 获取日期正则表达式：[\\d{4]}[年|\-|\.]\\d{\1-\12}[月|\-|\.]\\d{\1-\31}日? 　　评注：可用来匹配大多数年月日信息。 　　

27. 匹配双字节字符(包括汉字在内)：[^\x00-\xff] 　　评注：可以用来计算字符串的长度（一个双字节字符长度计2，ASCII字符计1） 　　

28. 匹配空白行的正则表达式：\n\s*\r 　　评注：可以用来删除空白行 　　

29. 匹配HTML标记的正则表达式：<(\S*?)[^>]*>.*?</>|<.*? /> 　　评注：网上流传的版本太糟糕，上面这个也仅仅能匹配部分，对于复杂的嵌套标记依旧无能为力 　　

30. 匹配首尾空白字符的正则表达式：^\s*|\s*$ 　　评注：可以用来删除行首行尾的空白字符(包括空格、制表符、换页符等等)，非常有用的表达式 

31. 匹配网址URL的正则表达式：[a-zA-z]+://[^\s]* 　　评注：网上流传的版本功能很有限，上面这个基本可以满足需求 　　

32. 匹配帐号是否合法(字母开头，允许5-16字节，允许字母数字下划线)：^[a-zA-Z][a-zA-Z0-9_]{4,15}$ 　　评注：表单验证时很实用 　　

33. 匹配腾讯QQ号：[1-9][0-9]{4,14} 　　评注：腾讯QQ号从10 000 开始 

34. 匹配中国邮政编码：[1-9]\\d{5}(?!\d) 　　评注：中国邮政编码为6位数字 　　

35. 匹配ip地址：((2[0-4]\\d|25[0-5]|[01]?\\d\\d?)\.){3}(2[0-4]\\d|25[0-5]|[01]?\\d\\d?)。 　　下面给出正则表达式的元字符（来自百度百科）



### 简单应用

- 验证是不是QQ号

```objective-c
   NSString *pattern = @"[1-9][0-9]{4,14}";
   NSPredicate * pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
   BOOL isMatch = [pre evaluateWithObject:self.enterText.text];
```



## 网络状态码

- 1XX 提示信息：请求正在处理中
- 2XX 成功错误码：请求已被接受处理
- 3XX 重定向：完成请求需要附加操作
- 4XX 客户端错误：请求资源有误或者请求不合法，服务器无法处理
- 5XX 服务器错误：服务器处理请求出错

### 常见状态码

- 200 OK
- 302 Found 暂时重定向
- 301 Move Permanently永久重定向
- 304 Not Modified 没有内容更新，使用缓存
- 400 Bad Request 客户端请求与语法错误
- 403 Forbidden 服务器拒绝提供服务
- 404 Not Found 请求资源不存在
- 500 Internal Server Error服务器发生了不可预期的错误
- 503 Server Unavailable 服务器当前不能处理客户端的请求，一段时间后可能恢复正常



## HTTP 请求过程

一个完整的HTTP请求过程如下：

1. 用户在浏览器输入URL
2. 域名解析（DNS的寻址）
3. TCP三次握手
4. 握手成功后建立TCP通道，发起HTTP请求
5. 服务器响应HTTP请求，返回对应的响应报文
6. 客户端开始解析渲染



## URL 和 URI

- URI：统一资源标识符
- URL：统一资源定位符

URI是一个用于标识互联网资源名称的字符串，最常见的形式是统一资源定位符（URL），经常指定为非正式的网址。更罕见的用法是统一资源名称（URN），其目的是通过提供一种途径。用于在特定的命名空间资源的标识，以补充网址。

即URL和URN 都是 URI的子集，URI是一种抽象的概念，URL是URI的一种常见的具象表达形式。



## 缩放图片避免内存消耗过大

原有缩放方法如下

```objective-c
- (UIImage *)scaleImage:(UIImage *)image newSize:(CGSize)newSize {
   UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
   [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
   UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
   UIGraphicsEndImgeContext();
   
   return newImage;
}
```

处理大分辨率图片时，往往容易出现OOM，原因是-[UIImage drawInRect:]在绘制时，先解码图片，再生成原始分辨率大小的bitmap，这是很耗内存的。解决方法是使用更低层的ImageIO接口，避免中间bitmap产生。

```objective-c
+ (UIImage *)scaledImageWithData:(NSData *)data withSize:(CGSize)size scale:(CGFloat)scale orientation:(UIImageOrientation)orientation {
   CGFloat maxPixelSize = MAX(size.width, size.height);
   CGImageSourceRef sourceRef = CGImageSourceCreateWithData((__bridge CFDataRef)data, nil);
   NSDictionary *options = @{(__bridge id)kCGImageSourceThumnailFromImageAlways:(__bridge id)kCFBooleanTrue,
   (__bridge id)kCGImageSourceThumbnailMaxPixelSize:[NSNumber numberWithFloat:maxPixelSize]};
   
   CGImageRef imageRef = CGImageSourceCreateThumnailAtIndex(sourceRef, 0, (__bridge CFDictionaryRef)options);
   UIImage *resultImage = [UIImage imageWithCGImage:imageRef scale:scale orientation:orientation];
   CGImageRelease(imageRef);
   CFRelease(sourceRef);
   
   return resultImage;
}
```



## LocationManager - Combine Version

```swift
import CoreLocation
import MapKit

final class LocationManager: NSObject, ObservableObject {
  var locationManager = CLLocationManager()
  @Published var region: MKCoordinateRegion
  @Published var authorized = false

  override init() {
    let place = WondersOfTheWorld().places.randomElement() ?? WondersOfTheWorld().places[0]
    region = MKCoordinateRegion(center: place.location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
    super.init()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    if locationManager.authorizationStatus == .authorizedWhenInUse {
      authorized = true
      locationManager.startUpdatingLocation()
    }
  }

  func requestAuthorization() {
    locationManager.requestWhenInUseAuthorization()
  }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    if locationManager.authorizationStatus == .authorizedWhenInUse {
      authorized = true
      locationManager.startUpdatingLocation()
    }
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let latest = locations.first else {
      return
    }
    region = MKCoordinateRegion.init(center: latest.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
    print("Region: \(region)")
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    guard let clError = error as? CLError else {
      return
    }
    switch clError {
    case CLError.denied:
      print("Access denied")
    default:
      print("LocationManager didFailWithError: \(clError.localizedDescription)")
    }
  }
}
```



## 断言

>  使用preconditionFailure（_：file：line :)或fatalError（_：file：line :)而不是assertionFailure（_：file：line :)可以使您的应用在release配置下崩溃。

Ref: https://www.jianshu.com/p/91213ee3cecf



## 字符串国际化中，格式化字符串多参数位置调整

e.g.

/* Message in alert dialog when something fails */

"%@ Error! %@ failed!" = "%2$@ blah blah, %1$@ blah!";

上例中，两个参数在翻译后的字符串中，前后位置调换。



## 使用 xib 时的 AutolLayout 和 frame 设置

开起AutoLayout后

方法调用顺序：viewDidLoad -> viewWillLayoutSubviews（这个函数在执行时加载文件对应的xib中设置的约束）-> viewDidLayoutSubviews

因此在viewDidLoad和viewWillLayoutSubviews中设置frame都是无效的，frame会在加载layout约束时重新计算。

想要更改frame有两个方法：

1. 在viewDidLayoutSubviews中设置frame；
2. 将约束control-drag到代码中，通过IBOutlet设置对应属性。通过这个方式可以在viewDidLoad和viewWillLayoutSubviews中进行设置。

>  Tip：如果要对frame进行修改并产生动画，需要在动画block内的代码块最后调用[被修改frame的view.super layoutIfNeeded];



## 用 NSKeyedArchiver 和 NSKeyedUnarchiver 实现多层数据结构的完全复制

### 示例：

```objective-c
NSMutableString *str1 = @“1”;
NSMutableString *str2 = @“2”;

NSMutabelArray *arr1 = [NSMutableArray arrayWithObjects:str1, str2, nil];
NSMutableArray *arr2 = [NSMutableArray arrayWithObjects:str1, str2, arr1, nil];

NSMutableArray *arr3 = [[NSMutableArray alloc] initWithArray:arr2 copyItems:YES];

NSMutableString *str3 = [arr1 objectAtIndex:0];
[str3 appendString:@“1”];

NSLog(@"arrM2--%@",arrM2);
NSLog(@"arrM3--%@",arrM3);
```

### 结果：

```
2017-03-14 00:55:57.604 深复制和完全复制[6080:438490] arrM2--(
    11,
    2,
        (
        11,
        2
    )
)
2017-03-14 00:55:57.606 深复制和完全复制[6080:438490] arrM3--(
    1,
    2,
        (
        11,
        2
    )
)
```

### 分析：

外层数据深拷贝，内层数据依然是浅拷贝（只拷贝指针）。

### 修复：

```objective-c
NSMutableArray *arr3 = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:arr2]];
```



## ARC - MRC 引用计数模式设置

Project设置 -> Build Settings -> Apple LLVM x.x - Language - Objective C -> Weak References in Manual Retain Release: 

NO: MRC

YES: ARC



## tintColorDidChange

当弹出一个alert或者action sheet时，iOS7会自动将后面视图的tint color变暗。此时，我们可以在自定义视图中重写tintColorDidChange方法来执行我们想要的操作。



## UIView 不能接受事件处理的情况

1. alpha < 0.01
2. userInteractionEnable = NO
3. hidden = YES



## 如何重写自己的 hash 方法

hash方法是NSObject中声明的，默认实现是返回对象的内存地址。

那么hash方法的最佳实践到底是什么呢?
 大神[Mattt Thompson](https://link.jianshu.com/?t=http://nshipster.com/authors/mattt-thompson/)在[Equality](https://link.jianshu.com/?t=http://nshipster.com/equality/)中给出的结论就是

In reality, a simple XOR over the hash values of critical properties is sufficient 99% of the time(对关键属性的hash值进行位异或运算作为hash值)

比如对于Person类的hash方法实现如下

```objective-c
- (NSUInteger)hash {
  
   return [self.name hash] ^ [self.birthday hash];
}
```



## xib 动画

Xib中的控件，通过约束更改尺寸/位置等属性后，需要调用控件的父视图的layoutIfNeed方法。

如果是使用UIView的animateWith…动画方法，需要在动画block内部的最后调用该方法。



## ios 开发 loaded the "ViewController" nib but the view outlet was not set.'

遇到loaded the "ViewController" nib but the view outlet was not set.'时，解决办法为：http://blog.sina.com.cn/s/blog_8f38d3410101a1rb.html，需要将Files's Owner中的view变量做一下关联。

但是，有时候做关联时并没有看到view变量，这时，需要设置一下Files's Owner的class，之后就可以做关联了。详情参考：https://stackoverflow.com/questions/10750082/loaded-the-controller-nib-but-the-view-outlet-was-not-set



## How to avoid clipboard warning as possibly as you can

Always check **UIPasteboard.hasStrings** before reading **UIPasteboard.string**, you can **potentially** save one clipboard warning.

——from ying Chong



## 怎么使用 GeometryReader 传入的 GeometryProxy 类型的参数，又不会因为在视图层级中加入 GeometryReader 导致占用了全部的可用屏幕空间，导致布局出现错误。

![](https://tva1.sinaimg.cn/large/008eGmZEly1goxgunt0cmj30ay07taa2.jpg)

```swift
struct Graph: View {
  @State private var width = UIScreen.main.bounds.width // just initial constant
  var body: some View {
      HStack(spacing: 0) {
        Color.red.frame(width: width / 3, height: 80)
        Color.blue.frame(width: width / 3, height: 120)
        Color.green.frame(width: width / 3, height: 180)
      }.background(GeometryReader { gp -> Color in
        let frame = gp.frame(in: .local)
        DispatchQueue.main.async {
            self.width = frame.size.width // << dynamic, on layout !!
        }
        return Color.clear
      })
  }
}
```





## 收到键盘通知后自动调整 scrollview 的 contentOffset

```objective-c
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    CGFloat kbH = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.classes.count inSection:0];
    CGRect p = [self.baseTableView rectForRowAtIndexPath:indexPath];
    CGRect rectInSelfview = [self.baseTableView convertRect:p toView:self.view];
    CGFloat cellBottomY = rectInSelfview.origin.y + rectInSelfview.size.height;
    
    if (cellBottomY < kbH) {
        
        return;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.baseTableView.contentOffset = CGPointMake(0, cellBottomY - (self.baseTableView.height - kbH));
    }];
}
```



## 避免锁死Tip

1. dispatch_once 中不要有同步到主线程执行的方法。

2. CTTelephonyNetworkInfo 最好在 +load方法或者 main 方法之前的其他时机提前初始化一个共享的实例，避免踩到子线程懒加载时候要求主线程同步响应的坑。

3. 有可能存在锁竞争的代码尽量不在主线程同步执行。

4. 如果主线程与子线程不可避免的存在竞争时，加锁的粒度要尽量小，操作要尽量轻。、

5. 数据库读写，文件压缩/解压缩等磁盘 IO 行为不放在主线程执行。

6. 如果存在主线程将任务同步到串行队列中执行的场景，确保这些任务不与子线程可能存在的耗时操作复用同一个串行队列。

7. 对于一些启动阶段非必要同步加载并且有比较密集磁盘 IO 行为的 SDK，如各种支付分享等第三方 SDK 都可以延迟，错开加载。

8. NSUserDefaults 底层实现中存在直接或者间接的跨进程通信，在主线程同步调用容易发生卡死。➡️重度使用参考MMKV，轻度使用参考firebase自己写歌轻量的UserDefaults类

9. [[UIApplication sharedApplication] openURL]接口，内部实现也存在同步的跨进程通信。➡️iOS10 及以上的系统版本使用[[UIApplication sharedApplication] openURL:options:completionHandler:]这个接口替换，此接口可以异步调起，不会造成卡死。



## 测量一段代码的运行时间

### 使用 包装了 `mach_absolute_time` 的 `CACurrentMediaTime()` 方法来以秒为单位测量时间

> 和 `NSDate` 或 `CFAbsoluteTimeGetCurrent()` 偏移量不同的是，`mach_absolute_time()` 和 `CACurrentMediaTime()` 是基于内建时钟的，能够更精确更原子化地测量，并且不会因为外部时间变化而变化（例如时区变化、夏时制、秒突变等）



```objective-c
static size_t const count = 1000;
static size_t const iterations = 10000;
CFTimeInterval startTime = CACurrentMediaTime();
{
    for (size_t i = 0; i < iterations; i++) {
        @autoreleasepool {
            NSMutableArray *mutableArray = [NSMutableArray array];
            for (size_t j = 0; j < count; j++) {
                [mutableArray addObject:object];
            }
        }
    }
}
CFTimeInterval endTime = CACurrentMediaTime();
NSLog(@"Total Runtime: %g s", endTime - startTime);
```

> 这个例子中 `startTime` 和 `endTime` 之间的 block 代码是不必要的，只是为了提高可读性，让代码看起来更清晰明了：很容易能分隔开变量会发生大规模突变的代码



### dispatch_benchmark

```objective-c
uint64_t t = dispatch_benchmark(iterations, ^{
    @autoreleasepool {
        NSMutableArray *mutableArray = [NSMutableArray array];
        for (size_t i = 0; i < count; i++) {
            [mutableArray addObject:object];
        }
    }
});
NSLog(@"[[NSMutableArray array] addObject:] Avg. Runtime: %llu ns", t);
```

> 不要在提交的最终代码里包含`dispatch_benchmark`函数，这只应该用在测试或开发过程中。另外，使用instruments获取真正影响代码和程序效率的部分远比关注代码绝对运行时间更重要。



### 公共方法

> 出于仅提供辅助而与具体状态无关，如果特别有用的话，可能值得使其全局可用



e.g.

TransactionStateMachine.h

```objective-c
typedef NS_ENUM(NSUinteger, TransactionState) {
  TransactionOpened,
  TransactionPending,
  TransactionClosed
};

extern NSString * NSStringFromTransactionState(TransactionState state);
```



TransactionStateMachine.m

```objective-c
NSString * NSStringFromTransactionState(TransactionState state) {
  switch (state) {
    case TransactionOpened:
      return @"Opened";
    case TransactionPending:
      return @"Pending";
    case TransactionClosed:
      return @"Closed";
    default:
      return nil
  }
}
```



## 使用 CFStringTransform 正则化用户生产的内容

字符串变换的一个更实际的应用是正则化不可预知的用户输入。即使你的应用并不单独处理其他语言，你也应当能智能地处理用户向你的应用输入的任何内容。

例如，你想在设备上建立一个可搜索的电影索引，它包含世界各地的人的问候：

- 首先，应用 `kCFStringTransformToLatin` 变换将所有非英文文本转换为拉丁字母表示。

> Hello! こんにちは! สวัสดี! مرحبا! 您好! → Hello! kon’nichiha! s̄wạs̄dī! mrḥbạ! nín hǎo!

- 然后，应用 `kCFStringTransformStripCombiningMarks` 变换来去除变音符和重音。

> Hello! kon’nichiha! s̄wạs̄dī! mrḥbạ! nín hǎo! → Hello! kon’nichiha! swasdi! mrhba! nin hao!

- 最后，用 `CFStringLowercase` 转为小写，并用[`CFStringTokenizer`](https://developer.apple.com/library/mac/#documentation/CoreFoundation/Reference/CFStringTokenizerRef/Reference/reference.html) 分词用作文本的索引。

> (hello, kon’nichiha, swasdi, mrhba, nin, hao)

通过对用户输入的文本使用同样的变换，你就可以实现一个通用的搜索，无论搜索文本或内容是什么语言！



## CoreMotion 和 CoreLocation组合使用时一些移动速度范围指导值

- 步行速度通常最高能达到 2.5 米每秒（5.6 mph, 9 km/h）
- 跑步速度范围从 2.5 到 7.5 米每秒（5.6 – 16.8 mph, 9 – 27 km/h）
- 骑行速度范围从 3 到 12 米每秒（6.7 – 26.8 mph, 10.8 – 43.2 km/h）
- 汽车的速度可以超过 100 米每秒（220 mph, 360 km/h）

### 或者，你可能会使用位置数据来改变 UI，取决于现在的位置是否在一片水域。

```objective-c
if currentLocation.intersects(waterRegion) {
    if activity.walking {
        print("🏊‍")
    } else if activity.automotive {
        print("🚢")
    }
}
```



## 使用 keyPath 时避免拼写错误

```objective-c
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([object isKindOfClass:[NSOperation class]]) {
        if ([keyPath isEqualToString:NSStringFromSelector(@selector(isFinished))]) {

        }
    } else if (...) {
        // ...
    }
}
```



### removeObserver时，避免因尚未注册导致的崩溃

> 使用 @try / @catch 块包裹 remove 语句

```objective-c
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(isFinished))]) {
        if ([object isFinished]) {
          @try {
              [object removeObserver:self forKeyPath:NSStringFromSelector(@selector(isFinished))];
          }
          @catch (NSException * __unused exception) {}
        }
    }
}
```



> 当然，这个例子中没有处理一个捕获的异常，这其实是一种妥协的方式。因此，只有当面对连续不断的崩溃并且不能通过一般的措施（竞争条件或者来自父类的非法行为）补救才会用这种方式。



## 断言和断言处理器

### 两套断言宏

1. 一般断言：`NSAssert` / `NSCAssert`
2. 参数化断言：`NSParameterAssert` / `NSCParameterAssert`

#### 使用方法：

> 方法或函数应当在代码最开始处使用 `NSParameterAssert` / `NSCParameterAssert` 来强制输入的值满足先验条件，这是一条金科玉律；其他情况下使用 `NSAssert` / `NSCAssert`。

#### 区别：

>  C 和 Objective-C 的断言：`NSAssert` 应当只用于 Objective-C 环境中（即方法实现中），而 `NSCAssert` 应当只用于 C 环境中（即函数中）。

#### Also:

> `NSAssert`和`NSCAssert`有多参数变体，从`NSAssert1`到`NSAssert5`，他们各自使用不同数量的参数用于`printf`风格的格式化字符串。

### `NSAssertionHandler`

> `NSAssertionHandler` 提供了一套优雅地处理断言失败的方式来保留珍贵的现实世界的使用信息......但是不要在生产环境中使用`NSAssertionHandler`......基础类库中的断言处理只可远观不可亵玩。

> `NSAssertionHandler` 是一个很直接的类，带有两个需要在子类中实现的方法：`-handleFailureInMethod:...` （当 `NSAssert` / `NSParameterAssert` 失败时调用）和 `-handleFailureInFunction:...` （当 `NSCAssert` / `NSCParameterAssert` 失败时调用）。

e.g.

LoggingAssertionHander.h

```objective-c
@interface LoggingAssertionHandler: NSAssertionHandler
@end
```

LoggingAssertionHandler.m

```objective-c
@implementation LoggingAssertionHandler

- (void)handleFailureInMethod:(SEL)selector
                       object:(id)object
                         file:(NSString *)fileName
                   lineNumber:(NSInteger)line
                  description:(NSString *)format, ...
{
  NSLog(@"NSAssert Failure: Method %@ for object %@ in %@#%i", NSStringFromSelector(selector), object, fileName, line);
}

- (void)handleFailureInFunction:(NSString *)functionName
                           file:(NSString *)fileName
                     lineNumber:(NSInteger)line
                    description:(NSString *)format, ...
{
  NSLog(@"NSCAssert Failure: Function (%@) in %@#%i", functionName, fileName, line);
}

@end
```

>每个线程都可以指定断言处理器。想设置一个 `NSAssertionHandler` 的子类来处理失败的断言，在线程的 `threadDictionary` 对象中设置 `NSAssertionHandlerKey` 字段即可。
>
>大部分情况下，你只需在 `-application:didFinishLaunchingWithOptions:` 中设置当前线程的断言处理器。

e.g.

AppDelegate.m

```objective-c
- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  NSAssertionHandler *assertionHandler = [[LoggingAssertionHandler alloc] init];
  [[[NSThread currentThread] threadDictionary] setValue:assertionHandler
                                                 forKey:NSAssertionHandlerKey];
  // ...

  return YES;
}
```



## 数据持久化

### `NSKeyedArchiver`和`NSKeyedUnarchiver`

e.g.

```objective-c
// 1. 获取存储路径
NSURL *path = [NSBundle.mainBundle resourceURL];
path = [path URLByAppendingPathComponent:@"Documents"];

// 2. 存储
NSDate *timestamp = [NSDate date];
NSData *storeData = [NSKeyedArchiver archivedDataWithRootObject:timestamp requiringSecureCoding:NO error:nil];
[storeData writeToURL:path options:NSDataWritingFileProtectionCompleteUnlessOpen error:nil];

// 3. 取出数据
NSDate *date = [NSKeyedUnarchiver unarchivedObjectOfClass:NSDate.class fromData:[NSData dataWithContentsOfURL:path] error:nil];
```



## 文件写入与读取

> https://nshipster.cn/nsfilemanager/

进行文件的写入与读取时，不要使用 `NSBundle -xxxURL` 或 `NSBundle -xxxPath` 方法获取存储路径，可以使用 `NSSearchPathForDirectoriesInDomains` 。

e.g.

```objective-c
NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
documentsPath = [documentsPath stringByAppendingPathComponent:@"store.data"];
```

### 推荐：`NSFileManager`



## 使用 `NSIndexSet` 或 `NSMutableIndexSet` 配置设置项

e.g.

```objective-c
static NSUInteger const PreferenceItemICloudSyncOn = 1001;
static NSUInteger const PreferenceItemPreferredLocalCacheDataOn = 1002;
static NSUInteger const PreferenceItemNotificationsOn = 1010;
static NSUInteger const PreferenceItemNotificationsShowAlertOn = 1011;

static NSUInteger const PreferenceItemCardStyleOn = 2001;
static NSUInteger const PreferenceItemShowStrokeBorderOn = 2002;
static NSUInteger const PreferenceItemHideTableViewSeparatorOn = 2003;

static NSUInteger const PreferenceItemGuestModeOn = 3001;
static NSUInteger const PreferenceItemHideSpecificFilesOn = 3002;

- (NSMutableIndexSet *)openedPreferenceItems {
    
    if (!_openedPreferenceItems) {
        
      // 添加某项
        _openedPreferenceItems = [NSMutableIndexSet indexSet];
        [_openedPreferenceItems addIndex:PreferenceItemICloudSyncOn];
        [_openedPreferenceItems addIndex:PreferenceItemNotificationsOn];
        [_openedPreferenceItems addIndex:PreferenceItemHideTableViewSeparatorOn];
        [_openedPreferenceItems addIndex:PreferenceItemHideSpecificFilesOn];
    }
    return _openedPreferenceItems;
}

// 移除某项
[self.openedPreferenceItems removeIndex:PreferenceItemGuestModeOn];
```



## 确定文件是否存在

```objective-c
NSFileManager *fileManager = [NSFileManager defaultManager];
NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
NSString *filePath = [documentsPath stringByAppendingPathComponent:@"file.txt"];
BOOL fileExists = [fileManager fileExistsAtPath:filePath];
```



## `NSPredicate`

### 替换符

- `%@`: 对值为字符串、数字或日期对象的替换值

- `%K`: 是key path的替换值。

  e.g.

  ```objective-c
  NSPredicate *ageIs33Predicate = [NSPredicate predicateWithFormat:@"%K = %@", @"age", @33];
  
  // ["Charlie Smith"]
  NSLog(@"Age 33: %@", [people filteredArrayUsingPredicate:ageIs33Predicate]);
  ```



- `$VARIABLE_NAME`是可以被`NSPredicate -predicateWithSubstitutionVariables:`替换的值。

  e.g.

  ```objective-c
  NSPredicate *namesBeginningWithLetterPredicate = [NSPredicate predicateWithFormat:@"(firstName BEGINSWITH[cd] $letter) OR (lastName BEGINSWITH[cd] $letter)"];
  
  // ["Alice Smith", "Quentin Alberts"]
  NSLog(@"'A' Names: %@", [people filteredArrayUsingPredicate:[namesBeginningWithLetterPredicate predicateWithSubstitutionVariables:@{@"letter": @"A"}]]);
  ```

  



## `NSUndoManager`

e.g.

```objective-c
@interface ViewController()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *label;
@end
  
@implementation ViewController
  
/// UI
- (void)testMethod17 {
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(8, 84 + 20, UIScreen.mainScreen.bounds.size.width - 16, 36)];
    self.textField.backgroundColor = UIColor.systemFillColor;
    self.textField.layer.cornerRadius = 4.0;
    UIView *left = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 0)];
    UIView *right = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 0)];
    self.textField.leftView = left;
    self.textField.rightView = right;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.rightViewMode = UITextFieldViewModeAlways;
    self.textField.delegate = self;
    [self.view addSubview:self.textField];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(8, 84 + 20 + 36 + 20, UIScreen.mainScreen.bounds.size.width - 16, 48)];
    self.label.textColor = UIColor.secondaryLabelColor;
    [self.view addSubview:self.label];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self appendingLabelText:textField.text];
    textField.text = @"";
    [textField resignFirstResponder]; // 回车后使 textField 放弃第一响应者，这样 viewController 可以变成第一响应者来响应手机摇动的动作，触发 undoManager 响应。
    return NO;
}

- (void)appendingLabelText:(NSString *)text {
    
    // 每个 controller、控件都可以有单独的 undoManager，这里为了方便只用应用默认的全局 undoManager。
    NSUndoManager *undoManager = UIApplication.sharedApplication.delegate.window.undoManager;
    // 在 undoManager 注册对应 actionName 被 undo 时需要调用的方法 Selector 和参数。
    [undoManager registerUndoWithTarget:self selector:@selector(removeLastText:) object:text];
    // 注册撤销操作的名称，可以使用国际化达到更好的文本效果。
    [undoManager setActionName:@"add text"];
    if (self.label.text.length) {
        
        self.label.text = [NSString stringWithFormat:@"%@ %@", self.label.text, text];
    } else {
        
        self.label.text = text;
    }
}

- (void)removeLastText:(NSString *)text {
    
    NSUndoManager *undoManager = UIApplication.sharedApplication.delegate.window.undoManager;
    [undoManager registerUndoWithTarget:self selector:@selector(appendingLabelText:) object:text];
    [undoManager setActionName:@"remove text"];
    if ([self.label.text containsString:text]) {
        
        NSUInteger firstLetterLocation = [self.label.text rangeOfString:text].location;
        NSString *stringToRemove = text;
        if (firstLetterLocation > 0) {
            
            NSString *previous = [NSString stringWithFormat:@"%c", [self.label.text characterAtIndex:firstLetterLocation - 1]];
            if ([previous isEqualToString:@" "]) {
                
                stringToRemove = [NSString stringWithFormat:@" %@", text];
            }
        }
        self.label.text = [self.label.text stringByReplacingOccurrencesOfString:stringToRemove withString:@"" options:kNilOptions range:NSMakeRange(0, self.label.text.length)];
    }
}

@end
```



-registerUndoWithTarget:selector:object: 这个简便方法只能接受 object 一个参数。除此之外，还有一种通过 NSInvocation 注册复杂的撤销操作的办法：

```objective-c
// 在 [undoManager prepareWithInvocationTarget:self] 之后，可以直接调用进行撤销操作时需要调用的方法，并传入相应参数。
[[undoManager prepareWithInvocationTarget:self] removeLastText:text];
[undoManager setActionName:@"add text"];
```



## `UIKeyCommand`

> 为了使 iPad 更高效的工作，iOS 9 增加了 *可发现特性*，这是一个叠加层，用于显示一个应用程序内当前可用的键盘命令。

### `UIKeyCommand`快捷键的组成

1. input

   你需要识别的关键字，或正确的箭头和退出键，本身并不包含字符。可用常数有：

   1. `UIKeyInputUpArrow`
   2. `UIKeyInputDownArrow`
   3. `UIKeyInputLeftArrow`
   4. `UIKeyInputRightArrow`
   5. `UIKeyInputEscape`

2. modifierFlags

   一个或多个`UIKeyModifierFlags`，描述了需要与 input 键同时使用的键

   1. `.Command`、`.Alternate`、`.Shift`、`.Control`：分别表示 Command，Option，Shift 和 Control 键
   2. `.NumericPad`：表示 input 应该来自数字键盘，而不是标准键盘最上面一行
   3. `.AlphaShift`：表示大小写锁定键是否作为按键组合的一部分（大写状态）

3. action

   按键命令调用的方法，`UIKeyCommand` 作为其唯一的参数。键盘事件将追溯响应链，直到发现一个匹配的方法。

4. discoverabilityTitle（仅 iOS 9）

   一个可选的标签，用来在发现层显示快捷键命令。

   ==只有设置了标题的键盘命令才会被列出。==

### 设置并响应键盘命令

> 启用键盘命令很简单，只需要在响应链的某处提供一个 `UIKeyCommand` 实例的数组。

文字输入是自动的第一响应者，但也许更方便的是在视图控制器通过实现 `canBecomeFirstResponder()`来响应键盘命令：

```objective-c
- (BOOL)canBecomeFirstResponder {
    return YES;
}
```

然后通过 `keyCommands` 属性提供可用的按键命令列表

```objective-c
- (NSArray<UIKeyCommand *>*)keyCommands {
    return @[
        [UIKeyCommand keyCommandWithInput:@"1" modifierFlags:UIKeyModifierCommand action:@selector(selectTab:) discoverabilityTitle:@"Types"],
        [UIKeyCommand keyCommandWithInput:@"2" modifierFlags:UIKeyModifierCommand action:@selector(selectTab:) discoverabilityTitle:@"Protocols"],
        [UIKeyCommand keyCommandWithInput:@"3" modifierFlags:UIKeyModifierCommand action:@selector(selectTab:) discoverabilityTitle:@"Functions"],
        [UIKeyCommand keyCommandWithInput:@"4" modifierFlags:UIKeyModifierCommand action:@selector(selectTab:) discoverabilityTitle:@"Operators"],

        [UIKeyCommand keyCommandWithInput:@"f" 
                            modifierFlags:UIKeyModifierCommand | UIKeyModifierAlternate 
                                   action:@selector(search:) 
                     discoverabilityTitle:@"Find…"]
    ];
}

// ...

- (void)selectTab:(UIKeyCommand *)sender {
    NSString *selectedTab = sender.input;
    // ...
}
```



### 情景敏感性

> 只要一个按键被按下， `keyCommands` 属性就会被访问，从而可以提供根据你应用程序的上下文状态敏感的反应。虽然这是类似菜单项的方式，其有效/无效状态被配置在 OS X 里面，iOS 版的建议是完全忽略不活动的命令，也就是说，在发现层不要显示变灰的命令。

e.g. 对于不同的登录状态，有不同的可用快捷键。（针对已登录用户有额外的可用快捷键）

```swift
let globalKeyCommands = [UIKeyCommand(input:...), ...]
let loggedInUserKeyCommands = [UIKeyCommand(input:...), ...]

override var keyCommands: [UIKeyCommand]? {
    if isLoggedInUser() {
        return globalKeyCommands + loggedInUserKeyCommands
    } else {
        return globalKeyCommands
    }
}
```





