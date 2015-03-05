" Vundle
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'

" Vundle Plugins
Plugin 'altercation/vim-colors-solarized'

call vundle#end()

" All other settings

syntax on
filetype plugin indent on
set number " show line numbers on left side
set ruler " Line and character numbers
set backspace=indent,eol,start

autocmd BufWritePre * :%s/\s\+$//e " trim trailing white space

" Font and colors
if has('gui_running')
    set background=light
    colorscheme solarized
else
    "set background=dark
    "colorscheme solarized
endif
set guifont=Menlo:h12

" Tab configuration
set tabstop=4       " The width of a TAB is set to 4.
                    " Still it is a \t. It is just that
                    " Vim will interpret it to be having
                    " a width of 4.
set shiftwidth=4    " Indents will have a width of 4
set softtabstop=4   " Sets the number of columns for a TAB
set expandtab       " Expand TABs to spaces
set smarttab

" Jedi-Vim
let g:jedi#completions_command = "<A-Space>"
