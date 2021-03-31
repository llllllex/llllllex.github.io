# Xcode Tips

## 在 Xcode 活跃视图显示构建时间

```objective-c
   defaults write com.apple.dt.Xcode ShowBuildOperationDuration -bool YES
```



## 防止 Xcode 崩溃后，再次打开时打开崩溃前的所有工程

```objective-c
   defaults write com.apple.dt.Xcode ApplePersistenceIgnoreState -bool YES
```



## Make Xcode’s Assistant aware of your ViewModels, Views, etc

```objective-c
   defaults write com.apple.dt.Xcode IDEAdditionalCounterpartSuffixes -array-add "ViewModel" "View" "Screen"
```

> You can check the current value of this default using defaults read com.apple.dt.Xcode IDEAdditionalCounterpartSuffixes.



## Xcode 重构时，rename功能关闭代码折叠动画（duration设为0）

```objective-c
   defaults write com.apple.dt.Xcode CodeFoldingAnimationSpeed -int 0
```





