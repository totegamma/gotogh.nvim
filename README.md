# gotogh.nvim

Open the file, commit, or PR at the current cursor line on the GitHub page.

## install

```
Plug 'totegamma/gotogh.nvim'
--
require('gotogh').setup()
```

When you're using linux, you have to set `BROWSER` environment variable to specify which browser to open.

## usage

```
:Gotogh // Open file with current linenumber
:GotoghCommit // Open commit
:GotoghPr // Search pr
```

## osusume

```
noremap go <Cmd>Gotogh<CR>
noremap gc <Cmd>GotoghCommit<CR>
noremap gp <Cmd>GotoghPr<CR>
```

