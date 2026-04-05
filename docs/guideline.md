# Vim Workshop 2026

---

## Part 0 -- Intro

### Target

Understand the following concepts

- What's vim
- What's modal editor
- Some history of vim from vi
- Mode of vim
  - insert
    - some keybinding like <c-w>
  - normal keybinding
    - basic move (hjkl wbe WBE <c-d> <c-u> 0 ^ $)
    - motion, count, object (diw, daw, diW, daW, ct$)
    - zz, zt, zb
    - a, A, i, I, r, R, c, C, s, S, t, T, f, F, o, O, x, d, D, u, U, p, P, y, u, <c-r>
    - yank, delete, clip board and OSC 52
    - indentation (<, >, <<, >>)
    - search and jump (/, \*, #, <c-o>, <c-i>, \`, {}, (), [])
    - gg G
  - command mode
    - help
    - save, quit (:q, :w, different between :wq and :x)
    - edit (:e)
    - netrw (:E)
    - split (:vs, :sp)
    - window, buffer, tab
    - run command and read (:r!)
    - sed and regex in vim (the regex part is quite different the standard introduced in bash wksp)
  - visual mode
    - visual mode
    - visual line mode
    - visual block mode
- macro
- basic vim script (`set rnu`)
- nvim plugin recommendation
- lazy loading
- basic lua
- recommended structure to write your config
- make your own distribution and cross compile on github
- misc
