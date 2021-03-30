# macOS Tips



## macOS 安全验证工具链中添加 Touch ID 验证

> TIL, macOS 在 /etc/pam.d/sudo 里面增加一行 auth sufficient pam_tid.so 可以给 sudo 加上 TouchID 验证

![](https://tva1.sinaimg.cn/large/008eGmZEly1goxdm0k6iyj30b103ywfl.jpg)



![](https://tva1.sinaimg.cn/large/008eGmZEly1goxdmk2iy6j30uu0e0q5i.jpg)



## macOS 的 mds_stores 导致应用程序内存不足的故障解决记录

Apple的产品专家两三个小时后给我回电了，提供了解决办法，并将解决方法发送到了我的邮箱。 我猜这个方法应该更可靠，适合当前版本（macOS High Sierra 10.13.1），如下：

您可以尝试以下方案： 

1）在终端中键入命令 `"sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist”` 

2）完成后重启电脑 3）确认您的电脑未开启 Time Machine，功能的情况下，执行以下重建命令：

`sudo mdutil -i off` // <press [return]>

`sudo mdutil -E` // <press [return]> 

`sudo mdutil -i on` // <press [return]>

 需要等待完成重建，完成后再尝试确认是否可以解决。



## Youtube-download

1. 安装youtube-dl

   ```shell
   pip install youtube-dl
   ```

2. 安装you-get

   ```shell
   pip install you-get
   ```

那么需要安装的ffmpeg的库该如何安装呢？可以参看这个仓库：

   - ​		[https://github.com/holzschu/a-Shell-commands](https://www.luckydesigner.space/wp-content/themes/begin5.2/inc/go.php?url=https://github.com/holzschu/a-Shell-commands)

点击对应的链接下载，或者直接点击下载这个链接：

   - ​		[https://github.com/holzschu/a-Shell-commands/releases/download/0.1/ffmpeg.wasm](https://www.luckydesigner.space/wp-content/themes/begin5.2/inc/go.php?url=https://github.com/holzschu/a-Shell-commands/releases/download/0.1/ffmpeg.wasm)

之后打开文件这个app——File App，就会看到它已经在Download这个文件夹里面了，先留着备用。

然后前往ipad本机，选择a-Shell文件夹，进入后新建一个名为bin的文件夹，如下图所示。

然后将那个备用的"ffmpeg.wasm"文件，转移到该文件夹即可。

### 使用

这样就可以实现下载视频，音频，图片之类的了。

比如下载小鸡小鸡歌曲，只需要输入以下代码即可：

`youtube-dl "ytsearch:小鸡小鸡"`

下载完成后，就到File App里面的A-shell查看就可以了，如下图所示。



## 删除 App 的代码签名（以避免 OCSP 在签名证书校验时通过 http:80 明文发送哈希）

```shell
codesign --remove-signature foo.app
codesign --remove-signature <#your app’s path#>
```



## If you don't like Big Sur's new title style and want to revert to how it looks in Catalina:

```shell
defaults write -g NSWindowSupportsAutomaticInlineTitle -bool false
```

and relaunch Finder.



