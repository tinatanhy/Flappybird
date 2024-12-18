# 工程文件

`Flappy/` 为项目的正式工程。

## 第一次 clone 工程

目前同步工程的原理是同步 `Flappy/Flappy.xpr`, `Flappy.ip_user_files`, 和 `Flappy/Flappy.srcs` 3 个文件（文件夹）。其他的文件都被 `.gitignore` 忽略掉。`.xpr` 文件用来存储工程中已经引用的文件信息，是 XML 格式的，在发生冲突需要手动 Merge 时谨慎修改。`.srcs` 是所有代码所在的目录，引用外部代码也请将代码放进工程中，以便同步后直接使用。`ip_user_files` 用于保存 ip 核配置。

直接 Clone 下来后应当可以打开 xpr 工程。