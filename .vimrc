set nocompatible              " be iMproved, required
set shell=/bin/zsh
filetype off                  " required

" set the runtime path to include Vundle and initialize
 set rtp+=~/.vim/bundle/Vundle.vim
 call vundle#begin()
" let Vundle manage Vundle, required
 Plugin 'VundleVim/Vundle.vim'
 Plugin 'vim-ruby/vim-ruby'
 Plugin 'wincent/command-t'
 Plugin 'itchyny/lightline.vim'
 Plugin 'scrooloose/nerdtree'
 Plugin 'junegunn/fzf'
 Plugin 'junegunn/fzf.vim'
 Plugin 'scrooloose/nerdcommenter'
 Plugin 'universal-ctags/ctags'
 Plugin 'tpope/vim-fugitive'
 Plugin 'rust-lang/rust.vim'
 Plugin 'joshdick/onedark.vim'
 Plugin 'jremmen/vim-ripgrep'
 Plugin 'airblade/vim-gitgutter'
 Plugin 'tomasr/molokai'
 Plugin 'morhetz/gruvbox'
 Plugin 'cstrahan/vim-capnp'
 Plugin 'github/copilot.vim'
 Plugin 'dense-analysis/ale'

" " All of your Plugins must be added before the following line
call vundle#end()            " required
" " Brief help
" " :PluginList       - lists configured plugins
" " :PluginInstall    - installs plugins; append `!` to update or just
" :PluginUpdate
" " :PluginSearch foo - searches for foo; append `!` to refresh local cache
" " :PluginClean      - confirms removal of unused plugins; append `!` to
" auto-approve removal

 set rtp+=~/.fzf
 let g:fzf_layout = { 'down': '40%' }


" Enable filetype plugin
filetype plugin on
filetype indent on

" making space the leader key
let mapleader=" "

" make sure backspace works!
set backspace=indent,eol,start

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
au FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab nosmartindent

autocmd FileType cpp set colorcolumn=81

"UI things for vim
set t_Co=256
set colorcolumn=101
autocmd FileType python set colorcolumn=80
syntax on
set bg=dark
colorscheme gruvbox
set wildmenu  "visual auto-complete for command menu
filetype indent on  "load filetype specific indent files
set smartindent "for indentation
set showmatch "show highlighted matching parenthesis
set showcmd " shows the commands typed in the bottom bar.
set number  " Shows line numbers
set rnu " Shows relative line numbers
set guioptions-=T   " TODO
set guioptions+=c   " TODO Console messages
set guifont=SourceCodePro:h12

" split right and below
set splitbelow
set splitright

" permanent undo
set undodir=~/.vimdd
set undofile

" start lightline
set laststatus=2

" biniding for nerd tree
map <C-o> :NERDTreeToggle %<CR>

" nerd commenter
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" ale linting??
let g:ale_lint_on_text_changed = "normal"
let g:ale_linters = {
\  'rust': ['analyzer'],
\}

""Highlight trailing whitespaces (+ keybindings below)
highlight ExtraWhitespace ctermbg=red guibg=red

" Remove any trailing whitespaces
function! StripTrailingWhitespaces()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfu

""highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
" au InsertLeave * match ExtraWhitespace /\s\+$/

" don't jump just highlight
nnoremap * *``
nnoremap # #``

" find all files, not just git ones
map ; :Files<CR>

" Custom shortcut keys
noremap <leader>f :GFiles<CR>
noremap <leader>hv :call ToggleCpp("v")<CR>
noremap <leader>hh :call ToggleCpp("h")<CR>
noremap <leader>ht :call ToggleCpp("t")<CR>
noremap <leader>bv :call ToggleBazelScons("v")<CR>
noremap <leader>bh :call ToggleBazelScons("h")<CR>
noremap <leader>bt :call ToggleBazelScons("t")<CR>
noremap <leader>Rg :Ripgrep<CR>
noremap <leader>rg :execute "Ripgrep ".expand("<cword>")<CR>

" Custom Syntax thing.....
augroup filetypedetect
    au! BufRead,BufNewFile *.ino set filetype=cpp
    au! BufRead,BufNewFile *.launch set filetype=xml
    au! BufRead,BufNewFile BUILD set filetype=python
    au! BufRead,BufNewFile *.bzl set filetype=python
    au! BufRead,BufNewFile WORKSPACE{,.bazel} set filetype=python
    au! BufRead,BufNewFile SCons* set filetype=python
    au! BufRead,BufNewFile Dockerfile set filetype=python
augroup END

""""""" Custom function definitions
" Toggle between cpp/hpp files.
function! ToggleCpp(splitMode)
  let file = expand('%:p')
  let ext = expand('%:t:e')
  let prefix = strpart(file, 0, strlen(file) - strlen(ext))
  let header = ['hpp', 'h']
  let source = ['cpp', 'cc', 'c']
  let dest = []
  if index(header, ext) != -1
    let dest = source
  elseif index(source, ext) != -1
    let dest = header
  endif
  for e in dest
    if filereadable(prefix.e)
      call OpenFileSplit(prefix.e, a:splitMode)
    endif
  endfor
endfunction

" Toggle between bazel & scons files.
function! ToggleBazelScons(splitMode)
  let direc = expand('%:p:h')
  let file = expand('%:t')
  let other = ''
  if file == "BUILD"
    let other = "SConscript"
  elseif file == "SConscript"
    let other = "BUILD"
  endif
  let otherfile = direc.'/'.other
  if filereadable(otherfile)
    call OpenFileSplit(otherfile, a:splitMode)
  endif
endfunction

" Open a file in split
function! OpenFileSplit(file, splitMode)
  if a:splitMode == "v"
    exe 'vsp '.a:file
  elseif a:splitMode == "h"
    exe 'sp '.a:file
  elseif a:splitMode == "t"
    exe 'tabe '.a:file
  endif
endfunction

" Custom Ripgrep to not match case, and ignore useful dirs
command! -bang -nargs=* Ripgrep
  \ call fzf#vim#grep(
  \   'rg -g "!app/*" -g "!go/third-party/*" --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

