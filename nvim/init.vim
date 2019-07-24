" w0h's nvim settings
" all by myself

""""""""""""""""""""""""""
" General settings       "
""""""""""""""""""""""""""
" Normal
set nocompatible
set number
set number relativenumber
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

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
set nowrap "Wrap lines
set wildmenu "wildmenu

let mapleader = ","
let g:mapleader = ","

" search
set ignorecase
set smartcase
set hlsearch
set incsearch

" color
syntax enable
set termguicolors
"set t_Co=256
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
"syn match cFunction /\<\w\+\%(\s*(\)\@=/
"hi default link cFunction Include


" say goodbye to your arrow keys!
noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
noremap <Right> <nop>
inoremap <Up> <nop>
inoremap <Down> <nop>
inoremap <Left> <nop>
inoremap <Right> <nop>

" terminal
tnoremap <Esc> <C-\><C-n>

""""""""""""""""""""""""""
" Plugins                "
""""""""""""""""""""'"""""
call plug#begin('~/.config/nvim/plugged')

    Plug 'itchyny/lightline.vim' " status line
    Plug 'scrooloose/nerdcommenter' " comment
    Plug 'scrooloose/nerdtree' " file manager
    Plug 'majutsushi/tagbar' " c tags
    Plug 'jiangmiao/auto-pairs' " auto pairs

    Plug '/bin/fzf'
    Plug 'junegunn/fzf.vim'

    Plug 'Chiel92/vim-autoformat' " auto format file
    Plug 'Yggdroot/indentLine' " add vertical lines
    Plug 'sheerun/vim-polyglot' " syntax enhancement

    " syntax check and complete
    Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}} " completion

    " color
    Plug 'nanotech/jellybeans.vim'

call plug#end()

" NERDTree
map <F7> :NERDTreeToggle<CR>

" Tagbar
nmap <F8> :TagbarToggle<CR>

" autoformat
au BufWrite * :Autoformat " auto format after save
let g:autoformat_autoindent = 0
let g:autoformat_retab = 0
let g:autoformat_remove_trailing_spaces = 1

" deoplete
set completeopt-=preview
set noshowmode

" coc.nvim
" use <tab> for trigger completion and navigate to next complete item
" use <cr> to confirm
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"
let g:coc_snippet_next = '<TAB>'
let g:coc_snippet_prev = '<S-TAB>'

" set color
colorscheme jellybeans

" lightline
let g:lightline = {
      \ 'colorscheme': 'jellybeans',
      \ }

" fzf.vim
nnoremap <silent> <leader>f :Files<cr>
