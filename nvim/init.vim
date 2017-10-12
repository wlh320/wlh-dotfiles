" w0h's nvim settings
" all by myself

""""""""""""""""""""""""""
" General settings       "
""""""""""""""""""""""""""
" Normal
set nocompatible
set number
filetype plugin on
filetype indent on
set autoread
set autochdir
set cursorline
set noswapfile
set encoding=utf8
set mouse=a

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

" search
set ignorecase
set smartcase
set hlsearch
set incsearch

" color
syntax enable
colorscheme jellybeans
set t_Co=256
" The following provide a transparent background:
"highlight Comment ctermbg=none
"highlight Constant ctermbg=none
"highlight Normal ctermbg=none
"highlight NonText ctermbg=none
"highlight Special ctermbg=none
"highlight SpecialKey ctermbg=none
"highlight Cursorline cterm=underline ctermbg=none
"highlight ErrorMsg ctermbg=none
"highlight Folded ctermbg=none
"highlight LineNr ctermbg=none
"highlight FoldColumn ctermbg=none
"highlight Title ctermbg=none
"highlight SignColumn ctermbg=none
syn match cFunction /\<\w\+\%(\s*(\)\@=/
hi default link cFunction Include

set wildmenu

" say goodbye to your arrow keys!
noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
noremap <Right> <nop>
inoremap <Up> <nop>
inoremap <Down> <nop>
inoremap <Left> <nop>
inoremap <Right> <nop>


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
    Plug 'lilydjwg/fcitx.vim'
    Plug 'ervandew/supertab'
    Plug 'roxma/nvim-completion-manager'
    Plug 'roxma/ncm-clang'
    Plug 'Chiel92/vim-autoformat'

call plug#end()

" NERDTree
map <F7> :NERDTreeToggle<CR>

" Tagbar
nmap <F8> :TagbarToggle<CR>

" AirLine
set laststatus=2
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_tabs = 1
let g:airline#extensions#tabline#exclude_preview = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_theme='murmur'

" SuperTab
let g:SuperTabDefaultCompletionType = "<c-n>"

" Ale
"let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0

" CtrlP
let g:ctrlp_custom_ignore = {
    \ 'dir':  '\v[\/]\.(git|hg|svn|rvm)$',
    \ 'file': '\v\.(exe|so|dll|zip|tar|tar.gz|pyc)$',
    \ }

" autoformat
au BufWrite * :Autoformat " auto format after save
let g:autoformat_autoindent = 0
let g:autoformat_retab = 0
let g:autoformat_remove_trailing_spaces = 1

