# Vim Workshop

---

## 1. 准备工作

推荐使用 Neovim。Vim 也可以，基础命令基本通用。

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

### 1.3 Ubuntu / Debian

```sh
sudo apt update
sudo apt install vim neovim
```

### 1.4 Arch Linux

```sh
sudo pacman -S vim neovim
```

### 1.5 Windows

使用 winget 安装 Neovim：

```ps1
winget install Neovim.Neovim
```

使用 winget 安装 Vim：

```ps1
winget install vim.vim
```

如果使用 WSL，也需要在 WSL 的 Linux 环境里单独安装 Vim 或 Neovim。

练习：

1. 在终端确认 `vim --version` 或 `nvim --version` 能正常输出。
2. 启动 Vim 或 Neovim。
3. 输入 `:q` 退出。
4. 再启动一次，输入 `:help` 打开帮助，然后用 `:q` 关闭帮助窗口。

---

## 2. 交互式教程

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


Normal mode 是默认状态。

### 3.1 按键记法

Vim 文档和配置里常用尖括号表示特殊按键或组合键：

| 记法 | 含义 |
| --- | --- |
| `<Esc>` | Escape |
| `<CR>` | Enter / Return |
| `<Tab>` | Tab |
| `<Space>` | 空格 |
| `<BS>` | Backspace |
| `<C-x>` | Ctrl + x |
| `<S-x>` | Shift + x |
| `<A-x>` | Alt + x |
| `<M-x>` | Meta + x |
| `<D-x>` | Command + x |


大写字母通常直接写成 `A`，表示 Shift + a，不常写成 `<S-a>`。

练习：

1. 在 Normal mode 按 `i` 进入 Insert mode。
2. 输入一行文字。
3. 按 `<Esc>` 回到 Normal mode。
4. 输入 `:set showmode`，再重复进入和离开 Insert mode，观察状态栏变化。

---

## 4. 进入和离开 Insert Mode

| 按键 | 含义 |
| --- | --- |
| `i` | 在光标前插入 |
| `I` | 在当前行第一个非空白字符前插入 |
| `a` | 在光标后追加 |
| `A` | 在行尾追加 |
| `o` | 在下方新开一行 |
| `O` | 在上方新开一行 |
| `s` | 删除光标下字符，并进入 Insert mode |
| `S` | 删除当前行，并进入 Insert mode |
| `c` | 修改 operator，需要配合 motion 使用 |
| `C` | 修改到行尾，并进入 Insert mode |
| `r` | 替换光标下一个字符，然后回到 Normal mode |
| `R` | 进入 Replace mode，连续覆盖已有字符 |
| `<Esc>` | 回到 Normal mode |


常见例子：

| 命令 | 含义 |
| --- | --- |
| `cw` | 修改当前 word 从光标开始的部分 |
| `c$` | 修改到行尾 |
| `ciw` | 修改当前 word |
| `ct,` | 修改到下一个逗号之前 |
| `cc` | 修改整行 |

Insert mode 中常用：

| 按键 | 含义 |
| --- | --- |
| `<C-w>` | 删除前一个 word |
| `<C-u>` | 删除到行首 |

练习：

```txt
hello_world
```

把光标放在行首，分别练习：

1. 按 `I`，输入 `say_`，按 `<Esc>`，得到 `say_hello_world`。
2. 按 `A`，输入 `!`，按 `<Esc>`，得到 `say_hello_world!`。
3. 把光标移到 `world` 的 `w` 上，按 `ciw`，输入 `Vim`，再按 `<Esc>`，得到 `say_hello_Vim!`。
4. 按 `u` 撤销，再按 `<C-r>` 重做。
5. 把光标移到任意字符上，按 `s` 替换一个字符。
6. 把光标移到 `hello` 的 `h` 上，按 `C` 修改到行尾。

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


- `word`：由字母、数字、下划线组成的一段，或者由连续标点组成的一段；它会把很多标点当成边界
- `WORD`：由非空白字符组成的一段；它只按空格、Tab、换行切分

练习：

```txt
foo.bar+baz hello_world /tmp/example.txt
```

把光标放在行首，尝试：

1. 连续按 `w`，观察 `foo`、`.`、`bar`、`+`、`baz` 会被当成不同 word。
2. 回到行首，连续按 `W`，观察 `foo.bar+baz` 会被当成一个 WORD。
3. 用 `e` 移到当前或下一个 word 的末尾。
4. 用 `b` 向前回到上一个 word 的开头。

### 5.3 行内查找字符

| 按键 | 含义 |
| --- | --- |
| `f{char}` | 向右找到某个字符 |
| `F{char}` | 向左找到某个字符 |
| `t{char}` | 向右移动到某个字符之前 |
| `T{char}` | 向左移动到某个字符之后 |
| `;` | 重复上一次 `f` / `F` / `t` / `T` |
| `,` | 反方向重复上一次 `f` / `F` / `t` / `T` |

练习：

```txt
alpha, beta, gamma
```

把光标放在行首，尝试：

1. 按 `f,` 跳到第一个逗号。
2. 按 `;` 跳到下一个逗号。
3. 按 `,` 回到上一个逗号。
4. 回到行首，按 `t,` 停在第一个逗号前。
5. 把光标放在行尾，按 `F,` 向左找逗号。

### 5.4 行内和文件移动

| 按键 | 含义 |
| --- | --- |
| `0` | 行首 |
| `^` | 当前行第一个非空白字符 |
| `$` | 行尾 |
| `gg` | 文件第一行 |
| `G` | 文件最后一行 |
| `{n}G` | 跳到第 n 行，例如 `42G` |
| `<C-d>` | 向下半页 |
| `<C-u>` | 向上半页 |

### 5.5 屏幕位置

这些命令不移动光标到别的文本位置，而是调整当前行在屏幕里的位置：

| 按键 | 含义 |
| --- | --- |
| `zz` | 当前行放到屏幕中间 |
| `zt` | 当前行放到屏幕顶部 |
| `zb` | 当前行放到屏幕底部 |

读长文件或写代码时，`zz` 很常用。

### 5.6 结构跳转

| 按键 | 含义 |
| --- | --- |
| `{` | 跳到上一段 |
| `}` | 跳到下一段 |
| `(` | 跳到上一句 |
| `)` | 跳到下一句 |
| `[[` | 跳到上一个 section |
| `]]` | 跳到下一个 section |
| `%` | 在匹配的括号之间跳转 |

`[` 和 `]` 也是一组 bracket commands 的前缀。在不同语言、插件或 LSP 环境里可能有不同含义，具体行为依上下文和 filetype 而定。

综合练习：

```txt
first line

alpha beta gamma

if (ready) {
  call(value)
}

last line
```

尝试：

1. 用 `gg` 跳到文件开头，再用 `G` 跳到文件末尾。
2. 用 `0`、`^`、`$` 在同一行内移动。
3. 用 `{` 和 `}` 在空行分隔的段落之间跳转。
4. 把光标放在括号上，用 `%` 在匹配括号之间跳转。
5. 滚动半页后按 `zz`，观察当前行在屏幕中的位置。

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
| `y}` | 复制到段落末尾 |
| `ct,` | 修改到下一个逗号之前 |

### 6.4 Text Object

Text object 表示一个有意义的文本范围。

| Text object | 含义 |
| --- | --- |
| `iw` | 当前 word 内部 |
| `aw` | 一个 word，通常包含周围空格 |
| `iW` | 当前 WORD 内部 |
| `aW` | 一个 WORD，通常包含周围空格 |
| `ip` | 当前段落内部 |
| `ap` | 当前段落，通常包含段落后空行 |
| `i"` | 双引号内部 |
| `a"` | 一对双引号，包含引号本身 |
| `i'` | 单引号内部 |
| `a'` | 一对单引号，包含引号本身 |
| `i(` | 圆括号内部 |
| `a(` | 一对圆括号，包含括号本身 |
| `i[` | 方括号内部 |
| `a[` | 一对方括号，包含括号本身 |
| `i{` | 花括号内部 |
| `a{` | 一对花括号，包含括号本身 |


常用组合：

| 命令 | 含义 |
| --- | --- |
| `diw` | 删除当前 word |
| `ciw` | 修改当前 word |
| `daw` | 删除一个 word，通常也删除相邻空格 |
| `diW` | 删除当前 WORD |
| `di"` | 删除引号内部 |
| `ci(` | 修改圆括号内部 |

练习：

```txt
call(foo_bar, "hello world", { x: 1, y: 2 })
```

每次练习前可以按 `u` 撤销，或者重新复制这一行。尝试：

1. 把光标放在 `foo_bar` 中间，按 `diw` 删除 `foo_bar`。
2. 把光标放在 `foo_bar` 中间，按 `ciw`，输入 `name`，再按 `<Esc>` 改成 `name`。
3. 把光标放在 `"hello world"` 里面，按 `di"` 删除引号内部。
4. 把光标放在圆括号内部，按 `ci(`，输入 `new_value`，再按 `<Esc>` 修改参数列表。
5. 把光标放在 `{ x: 1, y: 2 }` 内部，按 `di{` 删除花括号内部。

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

```txt
status: pending
status: pending
status: pending
```

尝试：

1. 把光标放在第一行的 `pending` 上。
2. 按 `ciw`，输入 `done`，再按 `<Esc>` 把它改成 `done`。
3. 移动到下一行的 `pending` 上。
4. 按 `.` 重复刚才的修改。
5. 再移动到第三行，继续按 `.`。
6. 用 `u` 撤销一次，再用 `<C-r>` 重做。

---

## 8. 缩进和格式化

`=` / `gq` / `gw`：可以和 motion 或 text object 组合。

| 命令 | 类型 | 含义 |
| --- | --- | --- |
| `=` | operator | 按 Vim 的缩进规则重新计算缩进 |
| `gq` | operator | 格式化文本，主要处理自然语言段落的换行 |
| `gw` | operator | 类似 `gq`，但尽量保持光标位置 |



| 命令 | 含义 |
| --- | --- |
| `>>` | 当前行向右缩进 |
| `<<` | 当前行向左缩进 |
| `>` | Visual mode 中选区向右缩进 |
| `<` | Visual mode 中选区向左缩进 |
| `==` | 重新缩进当前行 |
| `=ap` | 重新缩进当前段落 |
| `=i{` | 重新缩进当前花括号内部 |
| `gg=G` | 重新缩进整个文件 |
| `gq{motion}` | 格式化一段文本 |
| `gqap` | 格式化当前段落 |
| `gwap` | 类似 `gqap`，但尽量保持光标位置 |

代码格式化通常还需要 LSP、formatter 插件或外部工具。这里的 `=` 只负责 Vim 能识别的缩进规则。

缩进练习：

```c
void demo() {
printf("hello ");
if (true) {
printf("world");
}
printf("\n");
}
```

把光标放在函数内部尝试：

```vim
==
=i{
=ap
```

观察：

- `==` 只处理当前行。
- `=i{` 处理当前 `{}` 内部，不包括 `{}` 本身。
- `=ap` 处理当前段落。
- `gg=G` 可以重新缩进整个文件。

格式化练习：
```txt

Vim is a modal editor. It separates moving, selecting, changing, and inserting text. This makes many editing operations composable, but it also means beginners need to practice Normal mode deliberately.

```

把光标放在这一段里，尝试：
```vim
gqap
gwap
```

观察 `gqap` 和 `gwap` 的效果是否相同，以及光标位置是否变化。

---

## 9. 剪贴板和寄存器

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

### 9.1 OSC 52

在 SSH、tmux、远程容器或没有 GUI 剪贴板的终端里，`"+y` 可能不可用。OSC 52 可以让远程 Vim 通过终端把内容写回本地剪贴板。

但它依赖终端链路完整支持：

- 本地终端必须允许 OSC 52。
- tmux 可能需要额外配置。
- 有些终端会限制可复制内容的长度。
- 远程多层 SSH 时，中间环境可能会拦截或丢弃序列。

所以遇到剪贴板问题时，不要只检查 Vim 配置，也要检查终端和 tmux。

练习：

```txt
copy this line
paste below
system clipboard test
```

尝试：

1. 用 `yy` 复制第一行，用 `p` 粘贴到下一行。
2. 用 `dd` 删除一行，再用 `p` 粘贴回来。
3. 如果本机剪贴板可用，选中一段文本后用 `"+y` 复制到系统剪贴板。
4. 在 Vim 外部粘贴，确认系统剪贴板是否生效。
5. 如果失败，用 `:checkhealth` 或 `:version` 检查剪贴板支持。

---

## 10. 搜索和替换

搜索：

```vim
/pattern
?pattern
```

| 命令 | 含义 |
| --- | --- |
| `/pattern` | 向文件后方搜索 |
| `?pattern` | 向文件前方搜索 |

搜索后：

| 按键 | 含义 |
| --- | --- |
| `n` | 沿当前搜索方向找下一个匹配 |
| `N` | 沿当前搜索方向找上一个匹配 |
| `*` | 向文件后方搜索光标下的 word |
| `#` | 向文件前方搜索光标下的 word |

搜索练习：

```txt
apple banana apple
pear apple grape
banana pear apple
```

尝试：

1. 用 `/apple` 搜索 `apple`。
2. 用 `n` 找下一个匹配，用 `N` 反方向找。
3. 把光标放在 `banana` 上，按 `*` 搜索同一个 word。
4. 用 `?pear` 反向搜索 `pear`。

### 10.1 Jump List

Vim 会记录跳转历史。

| 按键 | 含义 |
| --- | --- |
| `<C-o>` | 回到上一个较旧的跳转位置 |
| `<C-i>` | 前进到下一个较新的跳转位置 |

常见场景：搜索后跳回原位置，或者在大文件里来回跳转。

### 10.2 Mark

Mark 用来手动记录位置：

| 命令 | 含义 |
| --- | --- |
| `ma` | 把当前位置记录到 mark `a` |
| `` `a `` | 跳回 mark `a` 的精确位置 |
| <code>``</code> | 跳回上一次跳转前的位置 |

练习：

1. 在某一行按 `ma`。
2. 用 `/pattern` 或 `G` 跳到别处。
3. 按 `` `a `` 回到刚才的位置。

### 10.3 Substitute

替换全文：

```vim
:%s/old/new/g
```

逐个确认：

```vim
:%s/old/new/gc
```

替换当前文件第 1 到第 10 行：

```vim
:1,10s/old/new/g
```

练习：

```txt
red apple
red banana
green apple
red grape
```

尝试：

1. 用 `:%s/red/blue/g` 把所有 `red` 改成 `blue`。
2. 用 `u` 撤销。
3. 用 `:%s/red/blue/gc` 逐个确认替换。
4. 只替换前两行：把光标放到第一行，按 `Vj` 选中两行，再输入 `:s/red/yellow/g`。

### 10.4 Magic

Vim 的正则有 magic 规则，很多符号什么时候需要转义，和常见正则不完全一样。

四种模式：

| 前缀 | 用法 |
| --- | --- |
| `\v` | very magic，复杂正则优先用它，少写反斜杠 |
| `\V` | very nomagic，按普通字符串搜索，适合匹配大量符号 |
| `\m` | magic，接近默认行为 |
| `\M` | nomagic，减少特殊符号 |

常见规则：


| \v   | \m     | \M     | \V     | 目标                         |
| ---- | ------ | ------ | ------ | ------------------------------- |
| a    | a      | a      | a      | 普通字母 `a`                     |
| \a   | \a     | \a     | \a     | 任意字母        |
| .    | .      | \\.    | \\.    | 任意字符                   |
| \\.  | \\.    | .      | .      | 符号 `.`                     |
| \$   | \$     | \$     | \\\$   | 行尾                     |
| \\\* | \\\*   | \\\*   | \\\*   | 重复前一个 atom 任意次 |
| ~    | ~      | \\~    | \\~    | 上一次替换的字符串        |
| ()   | \\(\\) | \\(\\) | \\(\\) | 分组            |
| \|   | \\\|   | \\\|   | \\\|   | 或 |
| \\\\ | \\\\   | \\\\   | \\\\   | 符号 `\`               |
| \\\{ | {      | {      | {      | 符号 `{`             |


例子：

```vim
/\v(foo|bar)
/\Vfoo.bar
:%s/\v(foo|bar)/baz/g
:%s/\Vfoo.bar/literal/g
```

记不住默认规则时：复杂正则先加 `\v`，按原文搜索先加 `\V`。

练习：

```txt
foo
bar
foo.bar
fooXbar
a.b*c
item-42
item-108
call(foo)
call(bar)
call(baz)
```

尝试：

1. 用 `/foo.bar` 搜索，观察它会匹配 `foo.bar` 和 `fooXbar`。
2. 用 `/\Vfoo.bar` 搜索，只匹配字面量 `foo.bar`。
3. 用 `/\Va.b*c` 搜索字面量 `a.b*c`。
4. 用 `/\v(foo|bar)` 搜索 `foo` 或 `bar`。
5. 用 `/\vitem-\d+` 搜索 `item-42` 和 `item-108`。
6. 用 `/\vcall\((foo|bar)\)` 搜索 `call(foo)` 或 `call(bar)`，不匹配 `call(baz)`。
7. 用 `:%s/\vitem-(\d+)/item #\1/g` 把 `item-42` 改成 `item #42`。

---

## 11. 保存、退出、帮助

| 命令 | 含义 |
| --- | --- |
| `:w` | 保存 |
| `:q` | 退出 |
| `:q!` | 不保存，强制退出 |
| `:wq` | 保存并退出 |
| `:x` | 有修改才保存，然后退出 |
| `ZZ` | 等价于 `:x` |
| `:e filename` | 打开文件 |
| `:e!` | 丢弃未保存修改，从磁盘重新载入当前文件 |
| `:E` | 打开内置文件浏览器 netrw |
| `:r! command` | 把外部命令输出读入当前 buffer |
| `:help topic` | 打开帮助 |

`:wq` 和 `:x` 的区别：`:wq` 会写入文件再退出；`:x` 只有内容变更时才写入。

例子：

```vim
:help w
:help :w
:help CTRL-W
:help motion
:help text-objects
:r! date
:r! pwd
```

练习：

1. 新建一个临时文件，输入几行文字。
2. 用 `:w /tmp/vim-workshop-test.txt` 保存。
3. 用 `:e /tmp/vim-workshop-test.txt` 重新打开。
4. 输入一行新内容，再用 `:e!` 丢弃未保存修改。
5. 用 `:help motion` 打开帮助，再用 `<C-w>h` 或 `<C-w>j` 回到原窗口。

---

## 12. 分屏、Buffer 和 Tab

打开分屏：

| 命令 | 含义 |
| --- | --- |
| `:sp` | 水平分屏 |
| `:vs` | 垂直分屏 |
| `:q` | 关闭当前窗口 |

窗口间移动：

| 按键 | 含义 |
| --- | --- |
| `<C-w>h` | 到左边窗口 |
| `<C-w>j` | 到下方窗口 |
| `<C-w>k` | 到上方窗口 |
| `<C-w>l` | 到右边窗口 |
| `<C-w>=` | 平均分配窗口大小 |
| `<C-w>o` | 只保留当前窗口 |

概念区别：

- buffer：文件内容在内存里的对象
- window：显示 buffer 的视图
- tab：一组 window 的布局，不等于“一个文件一个标签页”

练习：

1. 用 `:e file-a.txt` 打开一个新文件。
2. 用 `:vs file-b.txt` 打开垂直分屏。
3. 用 `<C-w>h` 和 `<C-w>l` 在两个窗口之间切换。
4. 在两个窗口中分别输入不同内容。
5. 用 `<C-w>=` 平均分配窗口大小。
6. 用 `:q` 关闭当前窗口。
7. 用 `:ls` 查看当前 buffer 列表。

---

## 13. Visual Mode

| 按键 | 含义 |
| --- | --- |
| `v` | 按字符选择；再次按 `v` 回到 Normal mode |
| `V` | 按行选择；再次按 `V` 回到 Normal mode |
| `<C-v>` | 按块选择；再次按 `<C-v>` 回到 Normal mode |
| `<Esc>` | 离开 Visual mode，回到 Normal mode |

选中文本后：

| 按键 | 含义 |
| --- | --- |
| `d` | 删除 |
| `y` | 复制 |
| `c` | 修改 |
| `>` | 向右缩进 |
| `<` | 向左缩进 |
| `o` | 在选区两端切换光标 |

选中区域后按 `:`，命令行会自动出现：

```vim
:'<,'>
```

这表示“刚才选中的范围”。例如选中几行后输入：

```vim
:'<,'>s/old/new/g
```

就只会在选区里替换。

Visual block 常用于：

- 在多行行首插入相同内容
- 编辑多列文本
- 批量注释或取消注释

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

1. 把光标放在第一行的 `l` 上。
2. 按 `<C-v>`。
3. 按 `j` 三次，选中四行第一列。
4. 按 `I`。
5. 输入 `# `。
6. 按 `<Esc>`，等待 Vim 把插入内容应用到所有选中行。

再练习一次，把 `# ` 删除：

1. 把光标放在第一行的 `#` 上。
2. 按 `<C-v>`。
3. 按 `j` 三次，再按 `l` 选中两列。
4. 按 `d` 删除选区。

---

## 14. Macro

Macro 用来录制并重复一串按键。

| 命令 | 含义 |
| --- | --- |
| `qa` | 开始录制到寄存器 `a` |
| `q` | 停止录制 |
| `@a` | 播放 macro `a` |
| `@@` | 重复上一次 macro |
| `10@a` | 执行 10 次 macro `a` |

适合用 macro 的场景：

- 多行结构相似，但每行内容略有不同
- 重复插入前缀或后缀
- 简单格式转换
- 批量编号

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

步骤：

1. 把光标放在第一行开头。
2. 按 `qa` 开始录制到寄存器 `a`。
3. 按 `Ifruit: ` 在行首插入前缀。
4. 按 `<Esc>` 回到 Normal mode。
5. 按 `j` 移到下一行。
6. 按 `q` 停止录制。
7. 按 `2@a` 对剩下两行重复 macro。

---

## 15. 课后继续学习

建议顺序：

1. 完整做完 `:Tutor`。
2. 阅读 `:help motion`、`:help operator`、`:help text-objects`。
3. 每天用 Vim / Neovim 做一些小的真实编辑。
4. 学习 window、buffer、tab。
5. 学习基础配置。
6. 学习插件和 Neovim Lua。

推荐插件在 [plugin.md](./plugin.md) 。

