"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGIN INSTALLATION
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Install Vundle plugins
if filereadable(expand("~/.vimrc.bundles"))
    source ~/.vimrc.bundles
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" UI
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
endif

filetype plugin indent on

set number " show line numbers on left side
set relativenumber " show line numbers relative to current line
set ruler " Line and character numbers
set showcmd " Show info about current command at bottom
set backspace=indent,eol,start
set mouse=a
set incsearch
set hlsearch
set ignorecase
set smartcase
set encoding=utf-8
set nowrap
set colorcolumn=81


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MISC
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set nocompatible

" Tab/indent configuration
set tabstop=4       " The width of a TAB is set to 4.
                    " Still it is a \t. It is just that
                    " Vim will interpret it to be having
                    " a width of 4.
set shiftwidth=4    " Indents will have a width of 4
set softtabstop=4   " Sets the number of columns for a TAB
set expandtab       " Expand TABs to spaces
set smarttab

" ignore white space for diffs
set diffopt+=iwhite

" Fix copy and pasting. Use F2 before last chunks
set pastetoggle=<F2>
set clipboard=unnamed

" Don't hide quotes in json
set conceallevel=0

set wildmenu " Display matching files/commands when tab complete in command mode

" Call :MakeTags to setup ctags for current folder (run in root project
" folder)
command! MakeTags !ctags -R .

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PERFORMANCE
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set lazyredraw
set ttyfast

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" KEY MAPPINGS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""

map <Leader>j :%!python -m json.tool<CR>:set syntax=json<CR>
map <C-a> <esc>ggVG<CR>
nmap <silent> <leader>d <Plug>DashSearch
map <C-e> <esc>:MRU<CR>
" map <C-n> :NERDTreeToggle<CR>

" Disable arrow keys for practicing
" noremap <Up> <NOP>
" noremap <Down> <NOP>
" noremap <Left> <NOP>
" noremap <Right> <NOP>

" Use mac style text selection
nmap <S-Up> v<Up>
nmap <S-Down> v<Down>
nmap <S-Left> v<Left>
nmap <S-Right> v<Right>
vmap <S-Up> <Up>
vmap <S-Down> <Down>
vmap <S-Left> <Left>
vmap <S-Right> <Right>
imap <S-Up> <Esc>v<Up>
imap <S-Down> <Esc>v<Down>
imap <S-Left> <Esc>v<Left>
imap <S-Right> <Esc>v<Right>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin configurations
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set laststatus=2 " show airline at all times

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SYNTAX CHECKS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" configure syntastic syntax checking to check on open as well as save
let g:syntastic_check_on_open=1
let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-"]

" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TAB COMPLETION
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" This will remap the TAB key to behave smarter and either open CTRL-P for
" tab completion or just insert a real TAB, depending on the situation

set wildmode=list:longest,list:full
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <Tab> <c-r>=InsertTabWrapper()<cr>
inoremap <S-Tab> <c-n>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" FILE HANDLING
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""

autocmd BufWritePre * :%s/\s\+$//e " trim trailing white space
autocmd! bufwritepost .vimrc source % " auto-reload .vimrc on save

augroup vimrcEx
  autocmd!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Set syntax highlighting for specific file types
  autocmd BufRead,BufNewFile Appraisals set filetype=ruby
  autocmd BufRead,BufNewFile *.md set filetype=markdown

  " Enable spellchecking for Markdown
  autocmd FileType markdown setlocal spell

  " Automatically wrap at 80 characters for Markdown
  autocmd BufRead,BufNewFile *.md setlocal textwidth=80

  " Automatically wrap at 72 characters and spell check git commit messages
  autocmd FileType gitcommit setlocal textwidth=72
  autocmd FileType gitcommit setlocal spell

  " Allow stylesheets to autocomplete hyphenated words
  autocmd FileType css,scss,sass setlocal iskeyword+=-
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" FUZZY COMPLETE
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set rtp+=/usr/local/opt/fzf
