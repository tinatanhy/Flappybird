# 工程文件

这里存放两个工程所在的文件夹。

`test/` 为测试所用的工程，在这里编写一些可能会用上但不一定用得上的硬件，可以随意一些。

`Flappy/` 为项目的正式工程，还没有建立。

## 第一次 clone 工程

目前同步工程的原理是同步 `test/test.xpr` 和 `test/test.srcs` 两个文件（文件夹）。其他的文件都被 `.gitignore` 忽略掉。`.xpr` 文件用来存储工程中已经引用的文件信息，是 XML 格式的，在发生冲突需要手动 Merge 时谨慎修改。`.srcs` 是所有代码所在的目录，引用外部代码也请将代码放进工程中，以便同步后直接使用。

1. 如果在 clone 下来后做了一些修改，先 `git commit` 一次，保存修改。
2. 删除 `projects/` 下的两个（目前是一个）工程。
3. 用 Vivado 在 `projects/` 下建立一个工程 `test`，暂时选择 `xc7a35tfgg484-1` 作为芯片型号。
4. 再 `git checkout .` 一次，同步 `.xpr` 和 `.srcs`。
5. 试试 Simulate 一下，导出一下 bitstream 看看能不能跑起来！

工程文件第 7 行有一句 `<Project Product="Vivado" Version="7" Minor="63" Path="D:/Github/FPGA_Flappy/projects/test/test.xpr">` 会指示工程文件所在的目录，但我猜它不会造成什么影响。合并时设置成自己的目录（不修改）就好了。