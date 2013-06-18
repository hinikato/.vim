if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

" Run python with F5
map <silent> <F5> <Esc>:!python %<CR>
map! <silent> <F5> <Esc>:!python %<CR>
