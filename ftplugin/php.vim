" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

"compiler php

" PHP parser check (CTRL-L)
"autocmd FileType php noremap <C-L> :!php -l %<CR>
function! Drupal()
  set tabstop=2
  set shiftwidth=2
endfunction

fun! Psr()
  set tabstop=4
  set shiftwidth=4
endf

if has("gui") && has("menu")
  " To see defined commands see $VIMRUNTIME/menu.vim
"  amenu PopUp.Close.\ Window :confirm close<CR>
"  amenu PopUp.Close.\ Other :confirm only<CR>
  amenu PopUp.Replace\ All\ With\ PHP\ code ggVG"*Pggi<?php<CR><Esc>
endif
 
function! TabCmd(cmd)
  redir => message
  silent execute a:cmd
  redir END
  tabnew
  silent put=message
  set nomodified
endfunction
command! -nargs=+ -complete=command TabCmd call TabCmd(<q-args>)

fun! PHPUnit(tabit)
  let file_path = myak#find_file_up(myak#__dir__(0), 'bootstrap.php', 0)
  let cmd = '!phpunit -v'
  if strlen(file_path) > 0
    let cmd = cmd . ' --bootstrap ' . file_path
  endif
  let cmd = cmd . ' %:p'

  call PHPUnitRun(cmd, a:tabit)
endfunction

fun! PHPUnitRun(cmd, tabit)
  if (a:tabit)
    redir => output
  endif

  exe 'wa'
  exe a:cmd

  if (a:tabit)
    redir END
    tabnew
    silent put=output
    set nomodified
  endif
endfunction

" Run current PHPUnit test with F4.
map <silent> <F4> <Esc>:call PHPUnit(0)<CR>

" Run php with F5
map <silent> <F5> <Esc>:!php %<CR>
map! <silent> <F5> <Esc>:!php %<CR>
