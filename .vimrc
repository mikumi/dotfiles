" Pathogen
execute pathogen#infect()
call pathogen#helptags() " generate helptags for everything in 'runtimepath'

syntax on
filetype plugin indent on
set number

autocmd BufWritePre * :%s/\s\+$//e " trim trailing white space

" set background=dark
" colorscheme solarized
