# assembly-language
王爽《汇编语言(第3版) 》的实验、课程设计源码

## 搭建开发环境
### ubuntu安装dosbox
sudo apt-get install dosbox
### clone本项目
源码在source code文件夹下。
### 挂载
- shell中运行dosbox命令
- 在dosbox中运行 mount c： 路径/assembly-language
- 在dosbox中运行 c：

## 开发过程
### 编辑源文件
将汇编源文件放入source code文件夹中
### 编译
masm source code/count99.asm;

生成的obj文件在项目根目录下
### 连接
link count99;

生成exe文件也在项目根目录下
