# Vim Workshop

---

## 1. 课前准备

本课程推荐使用 Neovim。Vim 也可以，基础命令基本通用。

### 1.1 检查是否已经安装

```sh
vim --version
nvim --version
```

启动 Vim：

```sh
vim
```

启动 Neovim：

```sh
nvim
```

### 1.2 macOS

推荐使用 Homebrew：

```sh
brew install vim
brew install neovim
```

macOS 通常自带 Vim，但版本可能比较旧。

### 1.3 Ubuntu / Debian

```sh
sudo apt update
sudo apt install vim neovim
```

### 1.4 Fedora

```sh
sudo dnf install vim neovim
```

### 1.5 Arch Linux

```sh
sudo pacman -S vim neovim
```

### 1.6 Windows

使用 winget 安装 Neovim：

```powershell
winget install Neovim.Neovim
```

使用 winget 安装 Vim：

```powershell
winget install vim.vim
```

如果使用 WSL，也需要在 WSL 的 Linux 环境里单独安装 Vim 或 Neovim。

---

## 2. `:Tutor`

Neovim 自带交互式教程。

在终端运行：

```sh
nvim +Tutor
```

或者进入 Neovim 后运行：

```vim
:Tutor
```

---

## 3. Vim 模式

Vim 是 modal editor，也就是“有模式的编辑器”。

最常用的四种模式：

| 模式 | 用途 |
| --- | --- |
| Normal | 移动、删除、复制、粘贴、跳转 |
| Insert | 输入文本 |
| Visual | 选择文本 |
| Command-line | 执行 `:w`、`:q`、`/pattern` 等命令 |

最重要的习惯：

Normal mode 是默认状态。

---

## 4. 进入和离开 Insert Mode

| 按键 | 含义 |
| --- | --- |
| `i` | 在光标前插入 |
| `a` | 在光标后追加 |
| `I` | 在当前行第一个非空白字符前插入 |
| `A` | 在行尾追加 |
| `o` | 在下方新开一行 |
| `O` | 在上方新开一行 |
| `<Esc>` | 回到 Normal mode |

Insert mode 中常用：

| 按键 | 含义 |
| --- | --- |
| `<C-w>` | 删除前一个 word |
| `<C-u>` | 删除到行首 |

练习：

```txt
hello_world
```

把它改成：

```txt
say_hello_world!
```

---

## 5. 移动

### 5.1 基本移动

| 按键 | 移动 |
| --- | --- |
| `h` | 左 |
| `j` | 下 |
| `k` | 上 |
| `l` | 右 |

方向键也能用，但 `hjkl` 更容易和其他 Vim 命令组合。

### 5.2 Word 移动

| 按键 | 含义 |
| --- | --- |
| `w` | 下一个 word |
| `b` | 上一个 word |
| `e` | 当前或下一个 word 的末尾 |
| `W` | 下一个 WORD |
| `B` | 上一个 WORD |
| `E` | 当前或下一个 WORD 的末尾 |

`word` 和 `WORD` 不是简单的大小写版本，它们的边界不同：

- `word`：由字母、数字、下划线组成的一段，或者由连续标点组成的一段；它会把很多标点当成边界
- `WORD`：由非空白字符组成的一段；它只按空格、Tab、换行切分

练习：

```txt
foo.bar+baz hello_world
```

分别用 `w` 和 `W` 从行首移动，观察停下的位置。

### 5.3 行内和文件移动

| 按键 | 含义 |
| --- | --- |
| `0` | 行首 |
| `^` | 当前行第一个非空白字符 |
| `$` | 行尾 |
| `gg` | 文件第一行 |
| `G` | 文件最后一行 |
| `42G` | 跳到第 42 行 |
| `<C-d>` | 向下半页 |
| `<C-u>` | 向上半页 |

---

## 6. Vim 编辑语法

Vim 命令经常可以组合：

```txt
count + operator + motion
```

其中 `count` 可以省略。

### 6.1 Count

| 命令 | 含义 |
| --- | --- |
| `3j` | 向下移动 3 行 |
| `5w` | 向前移动 5 个 word |
| `2dd` | 删除 2 行 |

### 6.2 Operator

| Operator | 含义 |
| --- | --- |
| `d` | 删除 |
| `c` | 修改，并进入 Insert mode |
| `y` | 复制 |

### 6.3 Motion

| 命令 | 含义 |
| --- | --- |
| `dw` | 删除到下一个 word |
| `d$` | 删除到行尾 |
| `c$` | 修改到行尾 |
| `yw` | 复制到下一个 word |

### 6.4 Text Object

Text object 表示一个有意义的文本范围。

| Text object | 含义 |
| --- | --- |
| `iw` | 当前 word 内部 |
| `aw` | 一个 word，通常包含周围空格 |
| `i"` | 引号内部 |
| `i(` | 圆括号内部 |
| `i{` | 花括号内部 |

常用组合：

| 命令 | 含义 |
| --- | --- |
| `diw` | 删除当前 word |
| `ciw` | 修改当前 word |
| `di"` | 删除引号内部 |
| `ci(` | 修改圆括号内部 |

练习：

```txt
call(foo_bar, "hello world", { x: 1, y: 2 })
```

尝试：

```txt
diw
ciw
di"
ci(
```

---

## 7. 日常编辑命令

| 命令 | 含义 |
| --- | --- |
| `x` | 删除一个字符 |
| `dd` | 删除当前行 |
| `yy` | 复制当前行 |
| `p` | 在光标后粘贴 |
| `P` | 在光标前粘贴 |
| `u` | 撤销 |
| `<C-r>` | 重做 |
| `.` | 重复上一次修改 |

练习：

1. 用 `ciw` 修改一个 word。
2. 移动到另一个类似 word。
3. 按 `.` 重复刚才的修改。

---

## 8. 剪贴板和寄存器

Vim / Neovim 里的 `y`、`d`、`p` 默认使用 Vim 自己的寄存器，不一定等于系统剪贴板。所以你可能会遇到：在 Vim 里 `yy` 了，却粘不到别的软件里。

| 命令 | 含义 |
| --- | --- |
| `yy` | 复制到 Vim 寄存器 |
| `p` | 从 Vim 寄存器粘贴 |
| `"+y` | 复制到系统剪贴板 |
| `"+p` | 从系统剪贴板粘贴 |

也可以配置成默认使用系统剪贴板：

```lua
vim.opt.clipboard = "unnamedplus"
```

```vim
set clipboard=unnamedplus
```

如果仍然不能复制到系统外部，通常是当前系统、终端或远程环境没有正确支持剪贴板。

---

## 9. 搜索和替换

搜索：

```vim
/pattern
```

搜索后：

| 按键 | 含义 |
| --- | --- |
| `n` | 下一个匹配 |
| `N` | 上一个匹配 |
| `*` | 向后搜索光标下的 word |
| `#` | 向前搜索光标下的 word |

替换全文：

```vim
:%s/old/new/g
```

逐个确认：

```vim
:%s/old/new/gc
```

替换第 1 到第 10 行：

```vim
:1,10s/old/new/g
```

---

## 10. 保存、退出、帮助

| 命令 | 含义 |
| --- | --- |
| `:w` | 保存 |
| `:q` | 退出 |
| `:q!` | 不保存，强制退出 |
| `:wq` | 保存并退出 |
| `:x` | 有修改才保存，然后退出 |
| `:e filename` | 打开文件 |
| `:help topic` | 打开帮助 |

例子：

```vim
:help w
:help :w
:help motion
:help text-objects
```

---

## 11. Visual Mode

| 按键 | 含义 |
| --- | --- |
| `v` | 按字符选择 |
| `V` | 按行选择 |
| `<C-v>` | 按块选择 |

选中文本后：

| 按键 | 含义 |
| --- | --- |
| `d` | 删除 |
| `y` | 复制 |
| `c` | 修改 |
| `>` | 向右缩进 |
| `<` | 向左缩进 |

Visual block 练习，把：

```txt
line1
line2
line3
line4
```

变成：

```txt
# line1
# line2
# line3
# line4
```

步骤：

1. 按 `<C-v>`。
2. 选中四行第一列。
3. 按 `I`。
4. 输入 `# `。
5. 按 `<Esc>`。

---

## 12. Macro

Macro 用来录制并重复一串按键。

| 命令 | 含义 |
| --- | --- |
| `qa` | 开始录制到寄存器 `a` |
| `q` | 停止录制 |
| `@a` | 播放 macro `a` |
| `@@` | 重复上一次 macro |
| `10@a` | 执行 10 次 macro `a` |

练习：

```txt
apple
banana
orange
```

改成：

```txt
fruit: apple
fruit: banana
fruit: orange
```

---

## 13. 课后继续学习

建议顺序：

1. 完整做完 `:Tutor`。
2. 阅读 `:help motion`、`:help operator`、`:help text-objects`。
3. 每天用 Vim / Neovim 做一些小的真实编辑。
4. 学习 window、buffer、tab。
5. 学习基础配置。
6. 学习插件和 Neovim Lua。

推荐插件在 [plugin.md](./plugin.md) 。
