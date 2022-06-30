# foldjump.vim
Jump between folds with ease (a replacement for zk). Where normal zk would go
up until the nearest folded line, foldjump will go to the top of a folded
section, making movement in combination with zj much more intuitive and
predictable.

Enter `:help foldjump` for more details.

## Installation 
Install with your favorite plugin manager! For example, with [vim-plug](https://github.com/junegunn/vim-plug)
```vim
Plug 'dzfrias/vim-foldjump'
```

## Customization
To make your own mappings, put `let g:foldjump_map_keys = 0` in your vimrc and
use `<Plug>FoldJumpUp` to go up a fold.

## License
This plugin is licensed under MIT license.
