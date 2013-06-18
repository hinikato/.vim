if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

" Run dart with F5
map <silent> <F5> <Esc>:!dart %<CR>
map! <silent> <F5> <Esc>:!dart %<CR>
