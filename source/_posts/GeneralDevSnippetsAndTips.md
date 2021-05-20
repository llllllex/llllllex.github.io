---
title: GeneralDevSnippetsAndTips
date: 2021-05-14 17:30:30
tags:
---



## 开发通用常用代码块和知识点



> 部分来源
>
> [veryitman]:http://www.veryitman.com/



### Git

#### Tag

1. 向远程 Repository 添加 tag

   ```bash
   git tag -m "注释内容" 0.0.1
   git push --tags
   ```

2. 删除本地 tag

   ```bash
   git tag --delete [TagName]
   ```

   e.g.

   ```bash
   git tag --delete 0.0.1
   ```

3. 删除远程 tag

   > 如果删除 tag 后，想重新打一个相同的 tag，需要先删除本地的 tag，否则会失败。

   ```bash
   git push --delete origin [TagName]
   ```

   e.g.

   ```bash
   git push --delete origin 0.0.1
   ```

   

