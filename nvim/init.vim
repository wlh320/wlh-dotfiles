" w0h's nvim settings
" all by myself

""""""""""""""""""""""""""
" General settings       "
""""""""""""""""""""""""""
set number
set nocompatible
filetype plugin on
filetype indent on
set autoread
set autochdir
set cursorline

" Tab / spaces
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4

set ai "Auto indent
set si "Smart indent
set nowrap "Wrap lines

let mapleader = ","
let g:mapleader = ","

if has('mouse')
  set mouse=a
endif

set encoding=utf8

" search
set ignorecase
set smartcase
set hlsearch
set incsearch 

" color
syntax enable 
colorscheme molokai
set t_Co=256
highlight Comment ctermbg=none
highlight Constant ctermbg=none
highlight Normal ctermbg=none
highlight NonText ctermbg=none
highlight Special ctermbg=none
highlight SpecialKey ctermbg=none
highlight Cursor ctermbg=none
highlight Cursorline ctermfg=none
"highlight ErrorMsg ctermbg=none
highlight Folded ctermbg=none
highlight LineNr ctermbg=none
highlight FoldColumn ctermbg=none
highlight Title ctermbg=none
highlight SignColumn ctermbg=none
syn match cFunction /\<\w\+\%(\s*(\)\@=/
hi default link cFunction Include

""""""""""""""""""""""""""
" Plugins                "
""""""""""""""""""""'"""""
call plug#begin('~/.config/nvim/plugged')

    Plug 'bling/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'mattn/emmet-vim'
    Plug 'scrooloose/nerdcommenter'
    Plug 'scrooloose/nerdtree'
    Plug 'majutsushi/tagbar'
    Plug 'ctrlpvim/ctrlp.vim'
    Plug 'jiangmiao/auto-pairs'
    Plug 'w0rp/ale'
    Plug 'ervandew/supertab'
    Plug 'lilydjwg/fcitx.vim'
    
    Plug 'roxma/nvim-completion-manager'
    Plug 'roxma/ncm-clang'

call plug#end()

" NERDTree
map <F7> :NERDTreeToggle<CR>

" Tagbar
nmap <F8> :TagbarToggle<CR>

" AirLine
set laststatus=2
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_theme='murmur'

" SuperTab
let g:SuperTabDefaultCompletionType = "<c-n>"

" Ale
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0
