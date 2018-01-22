set encoding=utf-8
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set encoding=utf-8
set cursorline
" 显示行号
set number
" set relativenumber 

" 用空格代替制表符
set expandtab

" Tab键的宽度
set tabstop=4

" 统一缩进为4
set softtabstop=4
set shiftwidth=4

" 自动缩进
set autoindent
set cindent

set hlsearch

" using vunble
if filereadable(expand("~/dotfiles/vim/vimrc.bundles"))
  source ~/dotfiles/vim/vimrc.bundles
endif


