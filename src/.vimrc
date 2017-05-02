set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

if v:version >= 704
    Plugin 'SirVer/ultisnips'
endif

Plugin 'bling/vim-airline'
Plugin 'benmills/vimux'
Plugin 'bronson/vim-trailing-whitespace'
Plugin 'gmarik/Vundle.vim'
Plugin 'honza/vim-snippets'
Plugin 'jmcantrell/vim-virtualenv'
Plugin 'kien/ctrlp.vim'
Plugin 'klen/python-mode'
Plugin 'majutsushi/tagbar'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'tommcdo/vim-exchange'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'
Plugin 'vim-scripts/DoxygenToolkit.vim'

call vundle#end()

" Settings

filetype plugin indent on
syntax on
set nonumber
set hlsearch

" Plugin config

set tags=./tags;$HOME

" vim airline
" let g:airline_powerline_fonts = 1
" if !exists('g:airline_symbols')
"     let g:airline_symbols = {}
" endif
" let g:airline_symbols.space = "\ua0"
set t_Co=256
let g:airline_right_sep=""
let g:airline_left_sep=""
let g:airline_theme="simple"
set fillchars+=vert:\ 

" - python-mode
set completeopt=menu

" - syntastic
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_mode_map = { 'passive_filetypes': ['cuda'] }

let g:syntastic_cpp_include_dirs=["include", "hdr", "inc", "../include", "../hdr", "../inc", "/opt/cuda/include"]
let g:syntastic_cpp_compiler_options="-std=c++11"
let g:syntastic_c_include_dirs=["include", "hdr", "inc", "../include", "../hdr", "../inc", "/opt/cuda/include"]

" - UltiSnips
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<S-tab>"

" Mappgings

let mapleader=","

nnoremap <leader>w :w <CR>
nnoremap <leader>x :x <CR>
nnoremap <leader>nh :nohlsearch <CR>
nnoremap <leader>nu :set invnumber <CR>

inoremap jj <ESC>
inoremap kk <ESC>
inoremap jk <ESC>

nnoremap <leader>ft :! python -m behave <CR>

nnoremap <leader>ev :e ~/.vimrc <CR>
nnoremap <leader>sv :so ~/.vimrc <CR>

" Settings

filetype plugin indent on
syntax on
set number
set hlsearch

" Indent settings

set autoindent
set expandtab
set shiftwidth=4
set softtabstop=4

" Wild stuff
set suffixes+=.a,.o,.pyc
set wildignore+=*.o,*.so

" Statusline
set laststatus=2
" set statusline+=%<%f\ %{fugitive#statusline()}\ %h%m%r%=%-14.(%l,%c%V%)\ %P
" set highlight=sb

" Extra per project configuration
if $PWD != $HOME
    if filereadable(".vimrc")
        source .vimrc
    endif
endif

" Swap buffers

function! MarkWindowSwap()
    let g:markedWinNum = winnr()
endfunction

function! DoWindowSwap()
    "Mark destination
    let curNum = winnr()
    let curBuf = bufnr( "%" )
    exe g:markedWinNum . "wincmd w"
    "Switch to source and shuffle dest->source
    let markedBuf = bufnr( "%" )
    "Hide and open so that we aren't prompted and keep history
    exe 'hide buf' curBuf
    "Switch to dest and shuffle source->dest
    exe curNum . "wincmd w"
    "Hide and open so that we aren't prompted and keep history
    exe 'hide buf' markedBuf 
endfunction

nmap <silent> <leader>mw :call MarkWindowSwap()<CR>
nmap <silent> <leader>pw :call DoWindowSwap()<CR>


