if exists('did_myak') || &cp || version < 700
  finish
endif
let did_myak = 1

let s:this_dir_path = expand('<sfile>:h')

" http://habrahabr.ru/post/162483/
fun! <SID>lib_kb_switch(mode)
  let dll_file_path = s:this_dir_path . '/libdxlsw' . (has('win64') ? '64' : '') . '.dll'
  let cur_layout = libcallnr(dll_file_path, 'dxGetLayout', 0)
  if a:mode == 0
  if cur_layout != 1033
    call libcallnr(dll_file_path, 'dxSetLayout', 1033)
  endif
    let b:lib_kb_layout = cur_layout
  elseif a:mode == 1
    if exists('b:lib_kb_layout') && b:lib_kb_layout != cur_layout
      call libcallnr(dll_file_path, 'dxSetLayout', b:lib_kb_layout)
    endif
  endif
endfun
if myak#is_win()
  autocmd InsertEnter * call <SID>lib_kb_switch(1)
  autocmd InsertLeave * call <SID>lib_kb_switch(0)
endif
