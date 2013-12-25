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
" Functions (called from other sections of .vimrc)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function SetLineWrapWidth(width)
  set wrap
  let &textwidth=a:width
  if exists('+colorcolumn')
    set colorcolumn=+1  " highlight next column after 'textwidth'
"  else
"au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
  endif
endfunction

function SetIndentWidth(numberOfSpaces)
  " A tab is 4 spaces
  let &tabstop=a:numberOfSpaces
  " When hitting <BS>, pretend like a tab is removed, even if spaces
  let &softtabstop=a:numberOfSpaces
  " Number of spaces to use for autoindenting
  let &shiftwidth=a:numberOfSpaces
endfunction

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

function! s:CloseIfOnlyNerdTreeLeft()
  if exists("t:NERDTreeBufName")
    if bufwinnr(t:NERDTreeBufName) != -1
      if winnr("$") == 1
        q
      endif
    endif
  endif
endfunction

function! s:ApplyHtmlFtRules()
  set filetype=xhtml
"  autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags noci
"  autocmd FileType html set omnifunc=htmlcomplete#CompleteTags noci
"  runtime vimfiles/bundle/xmledit/ftplugin/xml.vim
endfunction

function! s:ApplyCommonCodingRules()
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


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntax and colors
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

syntax on
if (!has('gui'))
  colorscheme xoria256
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
set statusline+=Line:\ %l/%L\ (%1.3p%%)
set statusline+=,\ Col:\ %v\ (%c)
set statusline+=%=\ File:\ %t\ (%n)
set statusline+=,\ Format:\ %{&ff}
set statusline+=,\ Enc:\ %{&fileencoding}
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

" :help :filetype-overview
filetype indent off
filetype plugin indent on

call SetLineWrapWidth(120)
call SetIndentWidth(4)

" Expand tabs by default (overloadable per file type later)
set expandtab
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

" Autocompletion fix, complete with Tab, Escape with C-[
inoremap <expr> <C-[> pumvisible() ? "\<C-e><Esc>" : "\<Esc>"
"inoremap <expr> <Tab> <C-R>=pumvisible() ? "\<lt>C-N>" : "\<lt>Tab>"<CR>
"inoremap <expr> <CR> <C-R>=pumvisible() ? "\<lt>ESC>o" : "\<lt>CR>"<CR>

" Menu
map <F9> :emenu Encoding.<Tab>
map <F10> :emenu File\ Format.<Tab>

" nerdtree
map <F2> :NERDTreeToggle<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Menu
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Key to switch between menu items.
set wildcharm=<Tab>

menu Encoding.koi8-r                :e ++enc=koi8-r<CR>
menu Encoding.cp1251                :e ++enc=cp1251<CR>
menu Encoding.cp866                 :e ++enc=cp866<CR>
menu Encoding.ucs-2le               :e ++enc=ucs-2le<CR>
menu Encoding.utf-8                 :e ++enc=utf-8<CR>

menu File\ Format.dos\ (hide\ CRLF) :e ++ff=dos<CR>
menu File\ Format.unix\ (hide\ LF)  :e ++ff=unix<CR>
menu File\ Format.mac\ (hide\ CR)   :e ++ff=mac<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Commands and plugins setup
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""
" matchit
""""""""""
runtime macros/matchit.vim

""""""""
" netrw
""""""""
let g:netrw_keepdir=0

""""""""""""
" zencoding
""""""""""""
"let g:user_zen_settings = {
"\  'html' : {
"\    'indentation' : '  '
"\  },
"\}
"let g:use_zen_complete_tag=1
"let g:user_zen_expandabbr_key = '<c-l>'
"
"if exists('g:use_zen_complete_tag') && g:use_zen_complete_tag
"  setlocal completefunc=zencoding#CompleteTag
"endif

""""""""""""
" lightline
""""""""""""

"let g:lightline = {
"      \ 'colorscheme': 'Tomorrow_Night',
"      \ }

let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}}
let s:p.normal.left = [ ['darkestgreen', 'brightgreen', 'bold'], ['white', 'gray4'] ]
let s:p.normal.right = [ ['gray5', 'gray10'], ['gray9', 'gray4'], ['gray8', 'gray2'] ]
let s:p.inactive.right = [ ['gray1', 'gray5'], ['gray4', 'gray1'], ['gray4', 'gray0'] ]
let s:p.inactive.left = s:p.inactive.right[1:]
let s:p.insert.left = [ ['darkestcyan', 'white', 'bold'], ['white', 'darkblue'] ]
let s:p.insert.right = [ [ 'darkestcyan', 'mediumcyan' ], [ 'mediumcyan', 'darkblue' ], [ 'mediumcyan', 'darkestblue' ] ]
let s:p.replace.left = [ ['white', 'brightred', 'bold'], ['white', 'gray4'] ]
let s:p.visual.left = [ ['darkred', 'brightorange', 'bold'], ['white', 'gray4'] ]
let s:p.normal.middle = [ [ 'gray6', 'gray50' ] ]
let s:p.insert.middle = [ [ 'mediumcyan', 'darkestblue' ] ]
let s:p.replace.middle = s:p.normal.middle
let s:p.replace.right = s:p.normal.right
"let g:lightline#colorscheme#powerline#palette = lightline#colorscheme#fill(s:p)

"""""""""""
" nerdtree
"""""""""""
let NERDTreeWinSize = 40
let NERDTreeShowBookmarks = 1
let NERDTreeShowHidden = 1
let NERDTreeCaseSensitiveSort = 1
let NERDChristmasTree = 1
let NERDTreeChDirMode = 2
let g:NERDTreeMapOpenVSplit = "v"
let g:NERDTreeMapOpenSplit = "s"

"""""""""""""""
" indentguides
"""""""""""""""
let g:indent_guides_enable_on_vim_startup=0

""""""""
" unite
""""""""
" The prefix key.
"nnoremap [unite] <Nop>
"nmap f [unite]
"
"nnoremap <silent> [unite]c :<C-u>UniteWithCurrentDir
"\ -buffer-name=files buffer file_mru bookmark file<CR>
"nnoremap <silent> [unite]b :<C-u>UniteWithBufferDir
"\ -buffer-name=files -prompt=%\ buffer file_mru bookmark file<CR>
"nnoremap <silent> [unite]r :<C-u>Unite
"\ -buffer-name=register register<CR>
"nnoremap <silent> [unite]o :<C-u>Unite outline<CR>
"nnoremap <silent> [unite]f
"\ :<C-u>Unite -buffer-name=resume resume<CR>
"nnoremap <silent> [unite]d
"\ :<C-u>Unite -buffer-name=files -default-action=lcd directory_mru<CR>
"nnoremap <silent> [unite]ma
"\ :<C-u>Unite mapping<CR>
"nnoremap <silent> [unite]me
"\ :<C-u>Unite output:message<CR>
"nnoremap [unite]f :<C-u>Unite source<CR>
"
"nnoremap <silent> [unite]s
"\ :<C-u>Unite -buffer-name=files -no-split
"\ jump_point file_point buffer_tab
"\ file_rec:! file file/new file_mru<CR>

" Start insert.
"let g:unite_enable_start_insert = 1
"let g:unite_enable_short_source_names = 1

" To track long mru history.
"let g:unite_source_file_mru_long_limit = 3000
"let g:unite_source_directory_mru_long_limit = 3000

" Like ctrlp.vim settings.
"let g:unite_enable_start_insert = 1
"let g:unite_winheight = 10
"let g:unite_split_rule = 'botright'

" Prompt choices.
"let g:unite_prompt = '❫ '
"let g:unite_prompt = '» '

" autocmd FileType unite call s:unite_my_settings()
" function! s:unite_my_settings()"{{{
" " Overwrite settings.
" 
" nmap <buffer> <ESC> <Plug>(unite_exit)
" imap <buffer> jj <Plug>(unite_insert_leave)
" "imap <buffer> <C-w> <Plug>(unite_delete_backward_path)
" 
" imap <buffer><expr> j unite#smart_map('j', '')
" imap <buffer> <TAB> <Plug>(unite_select_next_line)
" imap <buffer> <C-w> <Plug>(unite_delete_backward_path)
" imap <buffer> ' <Plug>(unite_quick_match_default_action)
" nmap <buffer> ' <Plug>(unite_quick_match_default_action)
" imap <buffer><expr> x
" \ unite#smart_map('x', "\<Plug>(unite_quick_match_choose_action)")
" nmap <buffer> x <Plug>(unite_quick_match_choose_action)
" nmap <buffer> <C-z> <Plug>(unite_toggle_transpose_window)
" imap <buffer> <C-z> <Plug>(unite_toggle_transpose_window)
" imap <buffer> <C-y> <Plug>(unite_narrowing_path)
" nmap <buffer> <C-y> <Plug>(unite_narrowing_path)
" nmap <buffer> <C-j> <Plug>(unite_toggle_auto_preview)
" nmap <buffer> <C-r> <Plug>(unite_narrowing_input_history)
" imap <buffer> <C-r> <Plug>(unite_narrowing_input_history)
" nnoremap <silent><buffer><expr> l
" \ unite#smart_map('l', unite#do_action('default'))
" 
" let unite = unite#get_current_unite()
" if unite.buffer_name =~# '^search'
" nnoremap <silent><buffer><expr> r unite#do_action('replace')
" else
" nnoremap <silent><buffer><expr> r unite#do_action('rename')
" endif
" 
" nnoremap <silent><buffer><expr> cd unite#do_action('lcd')
" nnoremap <buffer><expr> S unite#mappings#set_current_filters(
" \ empty(unite#mappings#get_current_filters()) ? ['sorter_reverse'] : [])
" endfunction"}}}
" 
" let g:unite_source_file_mru_limit = 200
" let g:unite_cursor_line_highlight = 'TabLineSel'
" let g:unite_abbr_highlight = 'TabLine'
" 
" " For optimize.
" let g:unite_source_file_mru_filename_format = ''
" 
" if executable('jvgrep')
" " For jvgrep.
" let g:unite_source_grep_command = 'jvgrep'
" let g:unite_source_grep_default_opts = '--exclude ''\.(git|svn|hg|bzr)'''
" let g:unite_source_grep_recursive_opt = '-R'
" endif
" 
" " For ack.
" if executable('ack-grep')
" " let g:unite_source_grep_command = 'ack-grep'
" " let g:unite_source_grep_default_opts = '--no-heading --no-color -a'
" " let g:unite_source_grep_recursive_opt = ''
" endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" autocmd
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"autocmd! BufWritePost .vimrc source %

autocmd! BufNewFile,BufRead *.module,*.inc,*.test,*.install,*.profile,*.phtml
  \ set filetype=php
""  \ set cindent

" Associate extensions with .syntax file.
autocmd! BufNewFile,BufRead *.ts set filetype=typescript
autocmd! BufNewFile,BufRead *.html,*htm,*.twig,*.latte call s:ApplyHtmlFtRules()
autocmd! BufNewFile,BufRead *.markdown,*.md,*.mdown,*.mkd,*.mkdn,*.txt set filetype=markdown
autocmd! BufNewFile,BufRead *.stg set filetype=stg

autocmd! BufEnter * silent! lcd %:p:h

" nerdtree specific commands.
autocmd! WinEnter * call s:CloseIfOnlyNerdTreeLeft()
autocmd! ShellCmdPost,ShellFilterPost * :execute "normal \<S-R>"

" Disable the 'acp' for Python due problems with automatically exit.
autocmd! Filetype python AcpDisable
autocmd! Filetype css,php,javascript,php,ruby,html,xml,cpp,markdown call s:ApplyCommonCodingRules()
autocmd! Filetype vim set shiftwidth=2 tabstop=2

autocmd vimenter * call s:SetupSnippets()
