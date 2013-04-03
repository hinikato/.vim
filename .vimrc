" The path to .vimrc file stored in the $MYVIMRC Vim's environment variable.

" This must be first, because it changes other options as a side effect.
set nocompatible

let g:is_win = has('win32') || has('win64')

" To disable a plugin, add it's bundle name to the following list
let g:pathogen_disabled = []
if g:is_win
  call add(g:pathogen_disabled, 'syntastic')
  source $VIM/vimfiles/bundle/pathogen/autoload/pathogen.vim
else
  source ~/.vim/bundle/pathogen/autoload/pathogen.vim
endif

call pathogen#infect()


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Language
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Задать файл меню. Файл выбирается по схеме:  'lang/menu_' . &langmenu .  '.vim'.
" Строка должна идти до задания filetype.
set langmenu=ru_ru

let termencoding=&encoding

" Order of detecting the <EOL>.
set ffs=unix
set fileformat=unix

" Vim internal encoding.
set encoding=utf-8
" Encoding for new files.
setglobal fenc=utf-8
" List of encodings to autodetect 'fileencoding'.
set fencs=ucs-bom,utf-8,cp1251,cp866,koi8-r


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Behavior.
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set backspace=indent,eol,start
set autoread
set nobackup
set tags=tags;/
"set wildmode=longest:full,full
set wildmenu

set confirm


" Scrolling options
"set scrolljump=5
"set scrolloff=3

" :help :filetype-overview
filetype indent off
filetype plugin indent on


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntax and colors
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

syntax on
if (!has('gui'))
  "colorscheme xoria256
else
  colorscheme myak
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Folding
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set foldmethod=indent
" All folds are open
set foldlevelstart=99


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" View
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Hide the mouse when typing text
set mousehide
"set cursorline
set nocursorline
set number
set ruler
set cmdheight=1
set showmatch


" Explicitly tell Vim that the terminal supports 256 colors
set t_Co=256


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Status line
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Always show the statusline
set laststatus=2
set showmode
set showcmd

""function! SyntaxItem()
""  return synIDattr(synID(line("."),col("."),1),"name")
""endfunction

set laststatus=2
" %-0{minwid}.{maxwid}{item}
set statusline+=Line:\ %l/%L\ (%2.3p%%)
set statusline+=,\ Column:\ %c
"set statusline+=%=%F
set statusline+=%=\ File:\ %t\ (%n)
set statusline+=,\ Format:\ %{&ff}
set statusline+=,\ Encoding:\ %{&fileencoding}
set statusline+=,\ Type:\ %{strlen(&ft)?&ft:'none'}\ %m%r%h%{((exists(\"+bomb\")\ &&\ &bomb)?'[BOM]':'')}
"""        set statusline+=%< " where truncate if line too long
"""set statusline+=%{SyntaxItem()}              " syntax highlight group under cursor


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Search
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Не учитывать регистр при поиске.
set ignorecase
" Учитывать его только, когда есть хотя бы одна большая буква.
set smartcase
" Искать по мере набора текста.
set incsearch
" Подсвечивать результаты поиска.
set hlsearch

"set gdefault                    " the /g flag on :s substitutions by default

" @TODO
"set iminsert=0
"set imsearch=0


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Indentation
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" A tab is 4 spaces
set tabstop=4
" When hitting <BS>, pretend like a tab is removed, even if spaces
set softtabstop=4
" Expand tabs by default (overloadable per file type later)
set expandtab
" Number of spaces to use for autoindenting
set shiftwidth=4
" Use multiple of shiftwidth when indenting with '<' and '>'
set shiftround
" Always set autoindenting on
set autoindent
" Copy the previous indentation on autoindenting
set copyindent
" Insert tabs on the start of a line according to shiftwidth, not tabstop
set smarttab

"imap <C-Return> <CR><CR><C-o>k<Tab>

set nosmartindent
" @TODO: setup cindent per filetype.
set nocindent

set list listchars=tab:»»,trail:·


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sessions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set sessionoptions+=unix,slash


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mapping
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" change the mapleader from \ to ,
let mapleader=","
let maplocalleader=","

" Edit .vimrc by <leader>e
nmap <leader>e :tabnew $MYVIMRC<CR>
" Reload .vimrc by <leader>s
" nmap <leader>s :so $MYVIMRC<CR>

" Saving with Ctrl-S.
noremap <C-S> :update<CR>
vnoremap <C-S> <C-C>:update<CR>
inoremap <C-S> <C-\><C-O>:update<CR>

" Saving with F3 -> strips spaces
noremap <silent> <F3> :call myak#normalize_spaces()<CR>
vnoremap <silent> <F3> <C-C>:call myak#normalize_spaces()<CR>
inoremap <silent> <F3> <C-\><C-O>:call myak#normalize_spaces()<CR>

" Moving rows
nmap <c-j> mz:m+<CR>`z==
nmap <c-k> mz:m-2<CR>`z==
imap <c-j> <Esc>:m+<CR>==gi
imap <c-k> <Esc>:m-2<CR>==gi
vmap <c-j> :m'>+<CR>gv=`<my`>mzgv`yo`z
vmap <c-k> :m'<-2<CR>gv=`>my`<mzgv`yo`z

" @TODO: Moving columns.

" Tab navigation like Firefox
nmap <C-S-tab> :tabprevious<CR>
nmap <C-tab> :tabnext<CR>
map <C-S-tab> :tabprevious<CR>
map <C-tab> :tabnext<CR>
imap <C-S-tab> <Esc>:tabprevious<CR>i
imap <C-tab> <Esc>:tabnext<CR>i

" Moving through windows with Alt key.
map <M-l> <C-W>l
map <M-h> <C-W>h
map <M-k> <C-W>k
map <M-j> <C-W>j

" Avoid to use arrows completly.
"imap <C-h> <C-o>h
"imap <C-j> <C-o>j
"imap <C-k> <C-o>k
"imap <C-l> <C-o>l

" cc and S keys is also useful in normal mode.
" http://vim.wikia.com/wiki/Restoring_indent_after_typing_hash
inoremap <CR> <CR><Space><BS>
nnoremap O O<Space><BS>
nnoremap o o<Space><BS>

" Folds.
nmap <Tab> zA

" Autocompletion fix
inoremap <expr> <C-[> pumvisible() ? "\<C-e><Esc>" : "\<Esc>"


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Menu
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set wcm=<Tab>
menu Encoding.koi8-r  :e ++enc=koi8-r<CR>
menu Encoding.cp1251  :e ++enc=cp1251<CR>
menu Encoding.cp866   :e ++enc=cp866<CR>
menu Encoding.ucs-2le :e ++enc=ucs-2le<CR>
menu Encoding.utf-8   :e ++enc=utf-8<CR>
map <F12> :emenu Encoding.<Tab>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Commands and plugins setup
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" preview
let PreviewBrowsers = 'firefox,opera,chromium-browser,google-chrome,safari,epiphany'

" matchit
runtime macros/matchit.vim

" netrw
let g:netrw_keepdir=0

" zencoding-vim
let g:user_zen_settings = {
\  'html' : {
\    'indentation' : '  '
\  },
\}
let g:use_zen_complete_tag=1
let g:user_zen_expandabbr_key = '<c-y>'

if exists('g:use_zen_complete_tag') && g:use_zen_complete_tag
  setlocal completefunc=zencoding#CompleteTag
endif

" nerdtree
function! s:CloseIfOnlyNerdTreeLeft()
  if exists("t:NERDTreeBufName")
    if bufwinnr(t:NERDTreeBufName) != -1
      if winnr("$") == 1
        q
      endif
    endif
  endif
endfunction
map <F2> :NERDTreeToggle<CR>
let NERDTreeWinSize = 40
let NERDTreeShowBookmarks = 1
let NERDTreeShowHidden = 1
let NERDTreeCaseSensitiveSort = 1
let NERDChristmasTree = 1
let NERDTreeChDirMode = 2
let g:NERDTreeMapOpenVSplit = "v"
let g:NERDTreeMapOpenSplit = "s"

" indentguides
let g:indent_guides_enable_on_vim_startup=0


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" snippets
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! s:SetupSnippets()
  if g:is_win
    let snippets_dir_path = $VIM . "/vimfiles/bundle/myak/snippets"
  else
    let snippets_dir_path = "~/.vim/bundle/myak/snippets"
  endif
  let file_paths = split(globpath(snippets_dir_path, "**/*.snippets", 1), "\n")
  for file_path in file_paths
    let ft = myak#chunk_of_path(file_path, -2)
    call ExtractSnipsFile(file_path, ft)
  endfor
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" autocmd
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"autocmd! BufWritePost .vimrc source %

autocmd! BufNewFile,BufRead *.module,*.inc,*.test,*.install,*.profile,*.phtml
  \ set filetype=php
""  \ set cindent

autocmd! BufNewFile,BufRead *.ts set filetype=typescript
autocmd! BufNewFile,BufRead *.html,*htm,*.twig,*.latte call ApplyHtmlFtRules()
autocmd! BufNewFile,BufRead *.markdown,*.md,*.mdown,*.mkd,*.mkdn,*.txt set filetype=markdown

autocmd! BufEnter * silent! lcd %:p:h

" nerdtree specific commands.
autocmd! WinEnter * call s:CloseIfOnlyNerdTreeLeft()
autocmd! ShellCmdPost,ShellFilterPost * :execute "normal \<S-R>"

" We need to disable the 'acp' for Python due problems with automatically exit.
autocmd! Filetype python AcpDisable

autocmd! Filetype css,php,javascript,php,ruby,html,xml,cpp,markdown call ApplyCommonCodingRules()
autocmd! Filetype vim set shiftwidth=2 tabstop=2

fun! ApplyHtmlFtRules()
  set filetype=xhtml
"  autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags noci
"  autocmd FileType html set omnifunc=htmlcomplete#CompleteTags noci
"  runtime vimfiles/bundle/xmledit/ftplugin/xml.vim
endfunction

fun! ApplyCommonCodingRules()
  if (has('gui'))
    call indent_guides#enable()
    let g:indent_guides_auto_colors = 0
    hi IndentGuidesEven guifg=yellow
    hi IndentGuidesOdd guifg=yellow
  else
    call indent_guides#disable()
  endif
  "highlight phpRegion guibg=yellow guifg=yellow
endfunction

autocmd vimenter * call s:SetupSnippets()
