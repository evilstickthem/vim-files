" --- plugins (vim-plug; bootstraps itself on first run) -----------------------
let s:plug = expand('~/.vim/autoload/plug.vim')
if empty(glob(s:plug))
  silent execute '!curl -fLo ' . s:plug . ' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
" look
Plug 'nanotech/jellybeans.vim'
Plug 'vim-airline/vim-airline'            " replaces powerline
Plug 'vim-airline/vim-airline-themes'
Plug 'luochen1990/rainbow'                " replaces kien/rainbow_parentheses
Plug 'ap/vim-css-color'                   " replaces vim-coloresque

" navigation / search
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'                   " replaces ctrlp + ack.vim
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'

" editing
Plug 'preservim/nerdcommenter'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-endwise'
Plug 'tmhedberg/SimpylFold'

" git
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'                  " :GBrowse for GitHub
Plug 'airblade/vim-gitgutter'

" languages
Plug 'sheerun/vim-polyglot'               " replaces haml/javascript/cucumber/indentpython
Plug 'tpope/vim-rails'
Plug 'dense-analysis/ale'                 " replaces syntastic + vim-flake8
Plug 'neoclide/coc.nvim', { 'branch': 'release' }  " replaces YouCompleteMe (LSP)

" terminal / remote
Plug 'ojroques/vim-oscyank', { 'branch': 'main' }  " yank to local clipboard over ssh/tmux
call plug#end()

" --- filetypes / colors -------------------------------------------------------
filetype plugin indent on
syntax on
let python_highlight_all=1
set background=dark
if has('termguicolors') && $COLORTERM =~# 'truecolor\|24bit'
  set termguicolors
else
  set t_Co=256
endif
silent! colorscheme jellybeans

" --- settings -----------------------------------------------------------------
set nocompatible                " don't hack around for vi compatiblity
set encoding=utf-8
set mouse=a                     " because i'm lame
set nu                          " line numbers
set backup                      " do backups
set backupdir=~/.vimbackup//    " put backups in one place
set directory=~/.vimtmp//       " put tmp files in one place
set undofile                    " persistent undo
set undodir=~/.vimundo//
set noswapfile
set hidden                      " hide buffers, rather than closing them
set modelines=0                 " don't allow modelines
set smartindent                 " let vim indent for you
set autoindent                  " always set autoindenting on
set copyindent                  " copy the previous indent on autoindenting
set tabstop=2                   " two-space tabs
set shiftwidth=2                " two-space tabs
set expandtab                   " use spaces for tabs
set incsearch                   " show search matches while you type
set ignorecase                  " ignore case when searching
set smartcase                   " ignore search case if all lowercase
set hlsearch                    " highlight search terms
set gdefault                    " default to global replace
set backspace=eol,start,indent  " allow backspace to delete linebreaks
set scrolloff=10                " lines of offset when scrolling
set sidescroll=10               " horizontal buffer as well
set wildmenu                    " make tab completion for files/buffers act like bash
set wildmode=list:full          " show a list when pressing tab and complete first full match
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg
set pastetoggle=<F2>            " toggle paste indentation w/ F2
set clipboard=unnamed           " share clipboard (local)
set more                        " page on extended output
set ttyfast                     " smoother redraws
set lazyredraw                  " do not redraw while executing macros
set showcmd                     " show command being typed
set tags=./tags;,~/.tags        " search for tags upward, then ~/.tags
set title                       " set the title
set laststatus=2
set ruler
set updatetime=300              " snappier gitgutter / coc
set signcolumn=yes
set ttimeoutlen=10              " fast esc, esp. inside tmux

" cursor shape: bar in insert, block in normal (iTerm2 + tmux)
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

for s:d in ['~/.vimbackup', '~/.vimtmp', '~/.vimundo']
  if !isdirectory(expand(s:d)) | call mkdir(expand(s:d), 'p') | endif
endfor

" --- plugin config ------------------------------------------------------------
let g:airline_powerline_fonts = 1
let g:airline_theme = 'jellybeans'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#ale#enabled = 1
let g:rainbow_active = 1

" fzf: Ctrl-P like before, plus ripgrep search (was :Ack)
nnoremap <C-p> :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>a :Rg<Space>
nnoremap <leader>g :GFiles?<CR>
command! -nargs=* Ack Rg <args>

" nerdtree
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader>f :NERDTreeFind<CR>

" ale: lint + fix (ruff/black/eslint/prettier/rubocop if installed)
let g:ale_fix_on_save = 0
let g:ale_linters = { 'python': ['ruff', 'flake8'] }
let g:ale_fixers = {
  \ '*': ['remove_trailing_lines', 'trim_whitespace'],
  \ 'python': ['ruff', 'black'],
  \ 'javascript': ['prettier', 'eslint'],
  \ 'typescript': ['prettier', 'eslint'],
  \ 'ruby': ['rubocop'],
  \}
let g:ale_disable_lsp = 1       " coc owns LSP
nnoremap <leader>F :ALEFix<CR>

" coc: completion + go-to-definition
let g:coc_global_extensions = ['coc-json', 'coc-pyright', 'coc-tsserver', 'coc-sh', 'coc-yaml', 'coc-solargraph']
inoremap <silent><expr> <TAB> coc#pum#visible() ? coc#pum#next(1) : "\<Tab>"
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gi <Plug>(coc-implementation)
nmap <leader>rn <Plug>(coc-rename)
nnoremap <silent> K :call CocActionAsync('doHover')<CR>

" over ssh the system clipboard isn't ours: send yanks home via OSC 52
if !empty($SSH_CONNECTION)
  set clipboard=
  autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '' | execute 'OSCYankRegister "' | endif
endif

" --- filetypes ----------------------------------------------------------------
if has('autocmd')
  au filetype php set tabstop=4                 " four spaces for PHP tabs
  au filetype php set shiftwidth=4              " four spaces for PHP tabs
  au filetype python set tabstop=4 shiftwidth=4
  au filetype ruby,javascript set list          " list chars in ruby/js
  au filetype ruby,javascript set listchars=tab:>-,trail:- " list trailing spaces + all tabs

  au BufNewFile,BufRead *.ejs set filetype=html " ejs suppport
  au BufNewFile,BufRead *.tpl set filetype=ruby " tpl support for ruby
  au BufRead,BufNewFile *.todo setfiletype todo
  au BufRead,BufNewFile Rakefile,Capfile,Gemfile,.autotest,.irbrc,*.treetop,*.tt set ft=ruby syntax=ruby
endif

" highlight merge conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
nnoremap <silent> <leader><space> :nohlsearch<CR>
