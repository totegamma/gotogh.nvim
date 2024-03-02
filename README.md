# gotogh.nvim

Open the currently open file on a Github page with line numbers

## install

```
Plug 'totegamma/gotogh.nvim'
--
require('gotogh').setup()
```

When you're using linux, you have to set `BROWSER` environment variable to specify which browser to open.

## usage

```
:Gotogh
```

## osusume

```
noremap go <Cmd>Gotogh<CR>
```

