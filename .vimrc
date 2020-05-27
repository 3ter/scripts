set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" https://github.com/ycm-core/YouCompleteMe/wiki/Full-Installation-Guide
Plugin 'ycm-core/YouCompleteMe'

" https://github.com/preservim/nerdcommenter
Plugin 'preservim/nerdcommenter'

" https://github.com/NLKNguyen/papercolor-theme
Plugin 'NLKNguyen/papercolor-theme'

" https://github.com/vim-airline/vim-airline
Plugin 'vim-airline/vim-airline'

" All of your Plugins must be added before the following line
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set tabstop=4
set shiftwidth=4
set smartindent
set expandtab

set linebreak

" Color
set t_Co=256   " This is may or may not needed.

set background=dark
" Silent so it doesn't disturb you the first time .vimrc is run
" and vimplug still has to load the plugin
:silent! colorscheme PaperColor 

set number
