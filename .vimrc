set nocompatible
filetype off
set tabstop=4
set shiftwidth=4
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

Plugin 'amdt/vim-niji'
Plugin 'petdance/vim-perl'
Plugin 'hotchpotch/perldoc-vim'
Plugin 'Shougo/neocomplcache'
Plugin 'thinca/vim-quickrun'
Plugin 'scrooloose/syntastic'
Plugin 'fatih/vim-go'
Plugin 'vim-jp/vim-go-extra'
Plugin 'posva/vim-vue'

call vundle#end()

:set autoindent
:set smartindent
:set backupskip=/tmp/*,/private/tmp/* 
:set number
:set cursorline
:set noswapfile

filetype plugin on
filetype indent on

if has("autocmd")

  autocmd FileType js setlocal sw=4 sts=4 ts=4 et
  autocmd FileType vue setlocal sw=2 sts=2 ts=2 et
  autocmd FileType sql setlocal sw=2 sts=2 ts=2 et
  autocmd FileType json setlocal sw=2 sts=2 ts=2 et
endif


:highlight CursorLine cterm=underline ctermfg=NONE ctermbg=NONE
:syntax on

nmap <Leader>r <plug>(quickrun)
autocmd BufNewFile,BufRead *.psgi set filetype=perl
autocmd BufNewFile,BufRead *.t set filetype=perl
autocmd BufNewFile,BufRead *.php set dictionary=~/.vim/dict/php.dict

let g:syntastic_go_checkers = ['golint']
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use underbar completion.
let g:neocomplcache_enable_underbar_completion = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

 " Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Use camel case completion.
let g:neocomplcache_enable_camel_case_completion = 1
" Select with <TAB>
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

let g:neocomplcache_ctags_arguments_list = {
  \ 'perl' : '-R -h ".pm"'
  \ }
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default'    : '',
    \ 'perl'       : $HOME . '/git/.vim/dict/perl.dict',
    \ 'sql'        : '',
    \ }

" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
  let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

set rtp+=$GOROOT/misc/vim
exe "set rtp+=".globpath($GOPATH, "src/github.com/nsf/gocode/vim")
" let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_functions = 1
let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': ['go'] }
let g:syntastic_go_checkers = ['go', 'golint']
set backspace=indent,eol,start
syntax on
