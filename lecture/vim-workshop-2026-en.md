# Vim Workshop 2026

---

## Part 0 -- Intro

### Target

This tutorial is aimed at **beginners**.

After this session, you should be able to:

- explain what Vim is and what a **modal editor** means
- understand the evolution from `vi` to `vim` to `neovim`
- recognize the main Vim modes: Normal / Insert / Visual / Command
- use the most common everyday operations for movement, editing, search, replacement, indentation, copy/paste, and macros
- read very basic Vimscript and Lua configuration
- know how to start configuring Neovim, install plugins, and use lazy loading

---

## 1. Introduction

### 1.1 What is Vim

Vim is a text editor built around **keyboard-driven editing**.

Its most important traits are not just that it is “lightweight” or “classic,” but that:

- **editing operations are composable**
- **movement and text input are separated**
- **a lot of work can be done without leaving the home row**

Many modern editors also provide a Vim mode. In essence, they are borrowing Vim's editing philosophy.

### 1.2 What is a modal editor

Vim is a **modal editor**.

That means:

- some modes are for typing text
- some modes are for moving the cursor
- some modes are for selecting text
- some modes are for executing commands

The biggest difference from a regular editor is:

> In Vim, the same key can mean different things in different modes.

For example:

- in **Visual mode**, `u` lowercases the selected text
- in **Normal mode**, `u` undoes the previous change

### 1.3 Why many people like Vim

Common reasons:

- less mouse usage
- fewer repetitive actions
- complex edits can be composed into short commands
- it works especially well for remote development and terminal environments
- once you are fluent, editing feels fast and continuous

But it is also important to say:

- Vim has a **steep learning curve at the beginning**
- it is not ideal if you expect to memorize a few shortcuts and instantly become productive
- real improvement comes from **consistent practice**

### 1.4 The history of Vim: vi -> vim -> neovim

You can remember it roughly like this:

- `vi`: the classic editor from the Unix era
- `vim`: **Vi IMproved**, an enhanced version of vi
- `neovim`: a modern fork of Vim with more focus on extensibility, Lua, and async capabilities

Most of the core operations you learn today work in both Vim and Neovim.

---

## 2. Mode of Vim

This section builds the big picture first, then goes deeper.

### 2.1 The four most important modes

1. **Normal mode**: the default mode, used for movement, deletion, copy, change, and jumping
2. **Insert mode**: for typing text
3. **Visual mode**: for selecting text
4. **Command-line mode**: for commands like `:` `/` `?`

### 2.2 One core idea

> Normal mode is your “native language.” Insert mode is only a short stop.

The biggest beginner problems are usually:

- staying in Insert mode all the time
- using Vim as if it were an ordinary text box

Once you move cursor movement, selection, deletion, and replacement back into Normal mode, Vim starts to show its real value.

---

## 3. Insert Mode

### 3.1 How to enter Insert mode

Most common keys:

| Key | Meaning                                                 |
| --- | ------------------------------------------------------- |
| `i` | insert before the cursor                                |
| `a` | append after the cursor                                 |
| `I` | insert before the first non-blank character of the line |
| `A` | append at the end of the line                           |
| `o` | open a new line below and enter Insert mode             |
| `O` | open a new line above and enter Insert mode             |
| `s` | delete the current character and enter Insert mode      |
| `S` | delete the current line and enter Insert mode           |
| `c` | change, used together with a motion                     |
| `C` | change to the end of the line                           |
| `r` | replace one character                                   |
| `R` | enter Replace mode and overwrite continuously           |

### 3.2 How to leave Insert mode

- `<Esc>`: the standard way
- `<C-c>`: can also exit Insert mode, but is not completely identical to `<Esc>`

- You can consider remapping Caps Lock or using other ergonomic tweaks later.

### 3.3 Common Insert mode shortcuts

- `<C-w>`: delete the word before the cursor

Two more that are often used together:

- `<C-u>`: delete back to the start of the line

### 3.4 Exercise

Given this line:

```txt
hello_world
```

Try the following:

- use `i` to insert `say_` at the beginning
- use `A` to append `!` at the end
- use `s` to replace the current character
- use `C` to change the second half of the line

---

## 4. Normal Mode

Normal mode is the core of Vim.

### 4.1 basic move

#### 4.1.1 hjkl

| Key | Move  |
| --- | ----- |
| `h` | left  |
| `j` | down  |
| `k` | up    |
| `l` | right |

- Why are they useful:

- your hands stay on the home row
- they combine smoothly with other commands

#### 4.1.2 Word movement: `w b e` and `W B E`

| Key | Meaning                                    |
| --- | ------------------------------------------ |
| `w` | move to the beginning of the next word     |
| `b` | move to the beginning of the previous word |
| `e` | move to the end of the current / next word |
| `W` | move to the beginning of the next WORD     |
| `B` | move to the beginning of the previous WORD |
| `E` | move to the end of the current / next WORD |

Difference:

- `word`: splits more aggressively on punctuation, letters, and numbers
- `WORD`: splits only on whitespace

For example:

```txt
foo.bar+baz
```

Vim will see this as multiple `word`s, but it can be treated as a single `WORD`.

#### 4.1.3 Screen scrolling: `<C-d>` `<C-u>`

- `<C-d>`: scroll down half a page
- `<C-u>`: scroll up half a page

These are extremely common when reading code.

#### 4.1.4 In-line movement: `0 ^ $`

| Key | Meaning                                         |
| --- | ----------------------------------------------- |
| `0` | go to column 0 of the line                      |
| `^` | go to the first non-blank character of the line |
| `$` | go to the end of the line                       |

#### 4.1.5 Document-level jump: `gg G`

- `gg`: go to the first line of the file
- `G`: go to the last line of the file
- `42G`: jump to line 42

### 4.2 motion, count, object

This is one of the most valuable things to learn in Vim.

### 4.2.1 count

Numbers can be used to repeat an operation.

For example:

- `3j`: move down 3 lines
- `5w`: jump forward 5 words
- `2dd`: delete 2 lines

### 4.2.2 motion

A motion can be understood as a movement range.

Common motions:

- `w`, `b`, `e`
- `0`, `^`, `$`
- `f{char}`, `F{char}`
- `t{char}`, `T{char}`
- `gg`, `G`
- `{`, `}`
- `(`, `)`
- `[` `]`

### 4.2.3 operator + motion

The classic form is:

```txt
operator + motion
```

For example:

- `dw`: delete up to the next word
- `d$`: delete to the end of the line
- `c$`: change to the end of the line
- `y}`: yank to the end of the paragraph

### 4.2.4 text object

Text objects are one of Vim's highest-value ideas.

Common ones:

- `iw` / `aw`: inner word / a word
- `iW` / `aW`: inner WORD / a WORD
- `i"` / `a"`: inside quotes / around quotes
- `i(` / `a(`: inside parentheses / around parentheses
- `i[` / `a[` : inside square brackets / around square brackets
- `i{` / `a{`: inside braces / around braces

### 4.2.5 The examples explicitly listed in the guideline

- `diw`: delete inside the current word
- `daw`: delete a word, possibly including surrounding whitespace
- `diW`: delete inside the current WORD
- `daW`: delete a WORD
- `ct$`: change from the cursor to the end of the line

Try comparing them yourself on this text:

```txt
foo_bar,baz qux
```

Try:

- `diw`
- `daw`
- `diW`
- `daW`

Observe the difference in boundaries.

### 4.3 `zz`, `zt`, `zb`

These do not move the cursor somewhere else. Instead, they **reposition the current line inside the window**:

- `zz`: place the current line in the middle of the screen
- `zt`: place the current line at the top of the screen
- `zb`: place the current line at the bottom of the screen

They are very useful when writing code and reading large files.

### 4.4 Common editing keys

```txt
a, A, i, I, r, R, c, C, s, S, t, T, f, F, o, O, x, d, D, u, p, P, y, <C-r>
```

You can memorize them by grouping them by function.

#### 4.4.1 Insert / append

- `i`, `I`, `a`, `A`, `o`, `O`

#### 4.4.2 Delete / change

- `x`: delete one character
- `d`: delete operator
- `D`: delete to the end of the line
- `c`: change operator
- `C`: change to the end of the line
- `s`: replace the current character and enter Insert mode
- `S`: replace the whole line and enter Insert mode

#### 4.4.3 Find character

- `f{char}`: find a character to the right
- `F{char}`: find a character to the left
- `t{char}`: move to just before a character on the right
- `T{char}`: move to just after a character on the left

#### 4.4.4 Copy, paste, undo, redo

- `y`: yank
- `p`: paste after
- `P`: paste before
- `u`: undo
- `<C-r>`: redo

### 4.5 yank, delete, clipboard and OSC 52

#### 4.5.1 yank and delete

- `y`: copy
- `d`: delete (it also goes into a register, so you can think of it as a cut)

For example:

- `yy`: yank the whole line
- `dd`: delete the whole line
- `p`: paste after the cursor
- `P`: paste before the cursor

#### 4.5.2 System clipboard

If your Vim / Neovim supports the clipboard, you can use:

- `"+y`: copy to the system clipboard
- `"+p`: paste from the system clipboard

#### 4.5.3 What is OSC 52

In the following situations, the system clipboard may not be directly available:

- SSH remote machines
- tmux
- terminal environments without a GUI clipboard

**OSC 52** is a terminal protocol that allows programs to send content to the local clipboard through the terminal.

You can think of it as:

> “Let remote Vim send copied text back to my local clipboard.”

### 4.6 indentation

Indent-related commands:

- `>`: indent right (in Visual mode)
- `<`: indent left (in Visual mode)
- `>>`: indent the whole line right
- `<<`: indent the whole line left

They can also be used together with Visual mode.

### 4.7 search and jump

#### 4.7.1 `/` search

Type:

```vim
/pattern
```

Then press Enter to search forward.

After searching:

- `n`: next match
- `N`: previous match

#### 4.7.2 `*` and `#`

- `*`: search forward for the word under the cursor
- `#`: search backward for the word under the cursor

These two keys are very fast and especially good for code reading.

#### 4.7.3 Jump list: `<C-o>` and `<C-i>`

Vim records your jump history.

- `<C-o>`: go back to an older jump location
- `<C-i>`: go forward to a newer jump location

This is useful when:

- moving between search results
- returning after `gd` / tag jumps
- jumping back and forth in large files

#### 4.7.4 Mark jump: `` ` ``

You can set a mark like this:

```vim
ma
```

This places mark `a` at the current location.

Later:

```vim
`a
```

can jump back to that position.

`` can jump back to the previous jump location.

#### 4.7.5 Structural jumps: `{}`, `()`, `[]`

- `{` `}`: jump by paragraph
- `(` `)`: jump by sentence
- `[` `]`: often related to matching structures, lists, sections, or code objects; the exact behavior depends on context and filetype

After installing LSP-related plugins, these motions may also gain additional meanings, but we will not expand on that here.

- `%` is also very commonly used to jump between matching brackets

---

## 5. Command Mode

Command-line mode is usually entered through:

- `:` to run Ex commands
- `/` to search
- `?` to search backward

Here we focus on `:`.

### 5.1 help

When you run into something you do not know, check help first, just like referring to the `man` who knows everything.

```vim
:help
:help w
:help :w
:help CTRL-W
:help motion
```

One of the correct ways to learn Vim is:

> If you do not know it, look it up in `:help`

### 5.2 save, quit

Most common commands:

| Command | Meaning                          |
| ------- | -------------------------------- |
| `:q`    | quit                             |
| `:q!`   | force quit without saving        |
| `:w`    | save                             |
| `:wq`   | save and quit                    |
| `:x`    | write only if changed, then quit |
| `ZZ`    | equivalent to `:x`               |

#### The difference between `:wq` and `:x`

- `:wq`: always writes, then quits
- `:x`: only writes if the contents changed

In daily use both are fine, but it is good to know the difference.

### 5.3 edit: `:e`

```vim
:e filename
```

Open another file.

Also common:

```vim
:e!
```

Discard unsaved changes and reload from disk. This is useful if a local agent wrote to the file and your buffer is out of sync.

### 5.4 netrw: `:E`

`netrw` is Vim's built-in file browser.

```vim
:E
```

### 5.5 split: `:vs`, `:sp`

```vim
:sp
:vs
```

- `:sp`: horizontal split
- `:vs`: vertical split

Together with window navigation:

```txt
<C-w> h/j/k/l
```

### 5.6 window, buffer, tab

According to `help`:

- A buffer is the in-memory text of a file.
- A window is a viewport on a buffer.
- A tab page is a collection of windows.

#### window

A window is a visible view.

#### buffer

A buffer is the content of an opened file in memory.

#### tab

A tab is not the browser-style model of “one file per tab.” It is a layout of windows.

### 5.7 run command and read: `:r!`

```vim
:r! ls
```

This reads the output of an external command into the current buffer.

For example:

```vim
:r! date
:r! pwd
```

This is very handy when writing documents, assembling output, or generating templates.

### 5.8 sed in vim

Vim's substitution command:

```vim
:%s/old/new/g
```

Explanation:

- `%`: the whole file
- `s`: substitute
- `g`: replace all matches on each line

More examples:

```vim
:1,10s/foo/bar/g
:%s/foo/bar/gc
```

Here `c` means confirm, one by one.

#### 5.8.1 Magic: \V \v \M \m

Magic is a common Vim regex option, for example in `%s/\v`.

| \v   | \m     | \M     | \V     | matches                         |
| ---- | ------ | ------ | ------ | ------------------------------- |
| a    | a      | a      | a      | literal 'a'                     |
| \a   | \a     | \a     | \a     | any alphabetic character        |
| .    | .      | \\.    | \\.    | any character                   |
| \\.  | \\.    | .      | .      | literal dot                     |
| \$   | \$     | \$     | \\\$   | end-of-line                     |
| \\\* | \\\*   | \\\*   | \\\*   | any number of the previous atom |
| ~    | ~      | \\~    | \\~    | latest substitute string        |
| ()   | \\(\\) | \\(\\) | \\(\\) | group as an atom                |
| \|   | \\\|   | \\\|   | \\\|   | nothing: separates alternatives |
| \\\\ | \\\\   | \\\\   | \\\\   | literal backslash               |
| \\\{ | {      | {      | {      | literal curly brace             |

When you want regex that looks more like what most people are used to, `\v` is the easiest choice.

For example, if you want to search for `foo` or `bar`:

```vim
/\v(foo|bar)
```

Without `\v`, in many cases you need more escaping.

When you want to match a large piece of text as a plain string, `\V` is very useful.

For example, to search literally for:

```txt
a.b*c
```

you can write:

```vim
/\Va.b*c
```

Here `.`, `*` and other symbols are no longer treated as regex metacharacters.

- `\m`: close to Vim's default behavior
- `\M`: useful when you do not want too many symbols to trigger regex behavior

#### Example

Search for one or more digits:

```vim
/\v\d+
```

Search literally for `foo.bar`:

```vim
/\Vfoo.bar
```

Replacement works the same way:

```vim
:%s/\v(foo|bar)/baz/g
:%s/\Vfoo.bar/literal/g
```

If you cannot remember the default rules, the most practical strategy is:

- when the regex gets complex, add `\v` first
- when you want to search raw text literally, add `\V` first

**Exercise**

Use sed to convert the corresponding table in `:h magic` into Markdown format.

---

## 6. Visual Mode

### 6.1 visual mode

Press:

```txt
v
```

to enter character-wise selection.

### 6.2 visual line mode

Press:

```txt
V
```

to enter line-wise selection.

### 6.3 visual block mode

Press:

```txt
<C-v>
```

to enter block-wise selection.

This is one of Vim's strongest features, especially for:

- inserting the same text at the start of many lines
- editing multiple columns at once
- batch commenting / uncommenting

For example:

1. use `<C-v>` to select a column
2. press `I`
3. type `- `
4. press `<Esc>`

Then Vim can insert `- ` at the start of all selected lines at once.

[vim-visual-multi](https://github.com/mg979/vim-visual-multi) is also recommended here.

### 6.4 Common operations in Visual mode

After selecting text, you can directly use:

- `d`: delete
- `y`: yank
- `c`: change
- `>`: indent right
- `<`: indent left
- `o`: switch the cursor between the two ends of the selection

---

## 7. Macro

Macros are used to automate repetitive edits.

### 7.1 Record and play back

#### Record

```txt
q{register}
```

For example:

```txt
qa
```

This starts recording into register `a`.

When you are done, press:

```txt
q
```

to stop recording.

#### Play back

```txt
@a
```

Repeat the last macro with:

```txt
@@
```

Execute it many times:

```txt
10@a
```

### 7.2 Good use cases for macros

- multiple similar lines that differ only slightly
- repeatedly inserting prefixes and suffixes
- format conversion
- batch numbering

### 7.3 Exercise

Turn:

```txt
apple
banana
orange
```

into:

```txt
- apple
- banana
- orange
```

Try recording a macro to do it.

### 7.4 `.` repeats the last change

This is an extremely powerful key in Vim.

If you just made an edit, pressing `.` repeats that edit.

---

## 8. Basic Vim Script

Whether you are a Vim user or a Neovim user, I still recommend memorizing the commands below. They help when you do not have public internet access, or when you need to quickly fix configuration on someone else's machine.

```vim
set rnu
syntax on
```

---

## 9. Nvim Plugin Recommendation

I strongly recommend Neovim. It has a very mature plugin ecosystem and is highly customizable.

For recommended plugins, see [plugin](./plugin.md).

---

## 10. Lazy Loading

Once you install many plugins, startup performance becomes a problem.

The idea of **lazy loading** is:

> only load a plugin when it is actually needed.

For example:

- load a plugin only for a certain filetype
- load it only when a certain command is executed
- load it only when a certain keybinding is pressed

In Neovim, `lazy.nvim` is a very popular solution.

A simple example:

```lua
require("lazy").setup({
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
	},
	{
		"folke/trouble.nvim",
		opts = {}, -- for default options, refer to the configuration section for custom setup.
		lazy = true,
		cmd = "Trouble",
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>cs",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>cl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>xL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>xQ",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},
	}
})
```

This means:

- the plugin is loaded only when a keybinding is triggered, for example `<leader>xL`
- plugins such as themes may be loaded earlier with higher priority

---

## 11. Basic Lua

<!-- TODO: More grammar will be introduced after the Part 13 is done -->

Neovim now uses Lua heavily for configuration.

The easiest way to learn it is by comparing Vimscript and Lua side by side.

### 11.1 Example comparison

#### Relative line numbers

Vimscript:

```vim
set relativenumber
```

Lua:

```lua
vim.opt.relativenumber = true
```

#### Tab width

```lua
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
```

#### Keymap

```lua
vim.keymap.set("n", "<leader>w", ":w<cr>")
```

---

## 12. Recommended Structure to Write Your Config

Recommended:

```
init.lua: The entry point that requires other modules.
lua/core/: General settings like line numbers, tab widths, and leader keys.
lua/plugin/: Individual files or a single file for plugin specifications.
lua/keymap/: Custom keybindings.
```

---

## 13. Make Your Own Distribution and Cross Compile on GitHub

TBD

---

<!-- TODO: write more interesting examples -->

## 14. Exercises

### Exercise 1 -- Basic movement

Open a file with about 100 lines and use only these keys to move around:

- `hjkl`
- `wbe`
- `0^$`
- `ggG`
- `<C-d><C-u>`

Goal:

- jump close to any target line within 10 seconds

### Exercise 2 -- Text object

Practice repeatedly on the following text:

```txt
call(foo_bar, "hello world", { x: 1, y: 2 })
```

Try:

- `diw`
- `ciw`
- `diW`
- `daW`
- `di"`
- `di(`
- `di{`

### Exercise 3 -- Search and replace

Prepare a file that contains multiple occurrences of `int`, then complete the following:

- replace on the current line
- replace in the whole file
- replace with confirmation
- write a clearer regex using `\v`

### Exercise 4 -- Visual block mode

Turn:

```txt
line1
line2
line3
line4
```

into:

```txt
# line1
# line2
# line3
# line4
```

You must use `<C-v>`.

### Exercise 5 -- Macro

Turn:

```txt
apple
banana
orange
```

into:

```txt
fruit: apple
fruit: banana
fruit: orange
```

You must record a macro to do it.
