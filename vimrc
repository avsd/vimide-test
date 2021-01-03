set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
set encoding=UTF-8
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
Plugin 'klen/python-mode'
Plugin 'scrooloose/nerdtree'
Plugin 'davidhalter/jedi-vim'
Plugin 'avsd/Conque-Shell'
Plugin 'mattn/emmet-vim'
Plugin 'scrooloose/syntastic'
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'
Plugin 'mcepl/cucutags'
Plugin 'mustache/vim-mustache-handlebars'
"Plugin 'ternjs/tern_for_vim'
Plugin 'ajh17/VimCompletesMe'

call vundle#end()            " required
" End of Bundles <<<<

filetype plugin indent on
syntax on
set backspace=2
set scrolloff=10
"filetype plugin on
"filetype indent on
"let g:pydiction_location = '/home/david/.vim/pydiction-1.2/complete-dict'
"let g:pydiction_menu_height = 20

"WatchTheDocs
au BufRead,BufNewFile *.watch set filetype=yaml

"set smartindent
set tabstop=4
set shiftwidth=4
set expandtab
set colorcolumn=110
highlight ColorColumn ctermbg=7

autocmd FileType javascript setlocal shiftwidth=2 tabstop=2
autocmd FileType json setlocal shiftwidth=2 tabstop=2
autocmd FileType html setlocal shiftwidth=2 tabstop=2
autocmd FileType css setlocal shiftwidth=2 tabstop=2
autocmd FileType scss setlocal shiftwidth=2 tabstop=2
autocmd FileType yaml setlocal shiftwidth=2 tabstop=2


" Rope
let g:pymode_rope = 0
"map <leader>j :RopeGotoDefinition<CR>

" Additional paths for Buildout
" let g:pymode_paths = ['/home/david/src/ebm/eggs', './develop_eggs']
" let g:pymode_paths = ['/home/david/src/ebm/eggs/Django-1.4.1-py2.7.egg', './develop_eggs']
" let g:pymode_paths = ['/home/david/src/chameleonpage/eggs/Django-1.4.1-py2.7.egg']

" Shortcuts for Tabs
map <C-F10> :tabp<CR>
map <C-F11> :tabe 
map <C-F12> :tabn<CR>
map <C-o> :tabe 

map <S-left> :tabp<CR>
map <S-right> :tabn<CR>
map <S-up> :tabe 
map <S-down> :q<CR>

map <A-left> :tabp<CR>
map <A-right> :tabn<CR>
map <A-up> :tabe 
map <A-down> :q<CR>
map <Tab> :wincmd w<CR>


" Disable folding
let g:pymode_folding = 0

" Disable pylint error - underindentation
" let g:pymode_lint_ignore = "E128"
let g:pymode_lint = 0
let g:pymode_lint_ignore = "E501,E128,W504,E123"
let g:syntastic_python_flake8_args='--ignore=E501,W504,E123'
let g:syntastic_python_pylint_args = "--load-plugins pylint_django"

" Color column for Python
let g:pymode_options_max_line_length = 110
let g:pymode_options_colorcolumn = 110

" Python: Go to definition in tabs
let g:jedi#use_tabs_not_buffers = 1
let g:jedi#completions_enabled = 0

" NERDTree settings
let NERDTreeIgnore = ['\.pyc$', '\.diff$', '\.egg-info$', '^__pycache__$']
let g:NERDTreeWinSize = 40
autocmd VimEnter * NERDTree
" autocmd BufEnter * NERDTreeMirror
autocmd VimEnter * wincmd w



" Java
let java_highlight_all=1
let java_highlight_functions="style"
let java_allow_cpp_keywords=1
set makeprg=vimAnt
" set efm=\ %#[javac]\ %#%f:%l:%c:%*\\d:%*\\d:\ %t%[%^:]%#:%m,
"           \%A\ %#[javac]\ %f:%l:\ %m,%-Z\ %#[javac]\ %p^,%-C%.%#

" Powerline & Python
set laststatus=2


" JavaScript & ReactJS
let g:jsx_ext_required = 0 " Allow JSX in normal JS files
let g:syntastic_javascript_checkers = ['eslint']
let local_eslint = finddir('node_modules', '.;') . '/.bin/eslint'
if matchstr(local_eslint, "^\/\\w") == ''
    let local_eslint = getcwd() . "/" . local_eslint
endif
if executable(local_eslint)
    let g:syntastic_javascript_eslint_exec = local_eslint
endif
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
