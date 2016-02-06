set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
 set rtp+=~/.vim/bundle/Vundle.vim
 call vundle#begin()
" let Vundle manage Vundle, required
 Plugin 'VundleVim/Vundle.vim'
" " All of your Plugins must be added before the following line
call vundle#end()            " required
" " Brief help
" " :PluginList       - lists configured plugins
" " :PluginInstall    - installs plugins; append `!` to update or just
" :PluginUpdate
" " :PluginSearch foo - searches for foo; append `!` to refresh local cache
" " :PluginClean      - confirms removal of unused plugins; append `!` to
" auto-approve removal

" Enable filetype plugin
filetype plugin on
filetype indent on

" Searching and all
set incsearch
set smartcase
set hlsearch
set ignorecase

" Tabbing, Default to 2 spaces as tabs
set cino=:0g0(0,W2
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2

" Filetype sesific
au FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4

"UI things for vim
set t_Co=256
syntax enable "For monokai color sceme
colorscheme harlequin
set wildmenu  "visual auto-complete for command menu
filetype indent on  "load filetype specific indent files
set smartindent "for indentation
set showmatch "show highlighted matching parenthesis
set showcmd " shows the commands u type in the bottom bar.
set number  " Shows line numbers
set rnu " Shows relative line numbers
set guioptions-=T   " TODO
set guioptions+=c   " TODO Console messages

""Highlight trailing whitespaces (+ keybindings below)
highlight ExtraWhitespace ctermbg=red guibg=red
""highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
" au InsertLeave * match ExtraWhitespace /\s\+$/

"Custom esc key
inoremap ,. <esc>

" Custom Syntax thing.....
augroup filetypedetect
    au! BufRead,BufNewFile *.ino set filetype=cpp
    au! BufRead,BufNewFile *.launch set filetype=xml
augroup END
