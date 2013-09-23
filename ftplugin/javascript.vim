if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

" Run node with F5
map <silent> <F5> <Esc>:!node %<CR>
map! <silent> <F5> <Esc>:!node %<CR>

"fun s:InsertJsHeader()
"  let cursor_pos = getpos(".")
"  keepjumps exe 's/^$/use strict;/e'
"  call setpos('.', cursor_pos)
"endf
"
"autocmd BufEnter * call s:InsertJsHeader()
