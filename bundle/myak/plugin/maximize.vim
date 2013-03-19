if exists('g:maximize_loaded')
  finish
endif
let g:maximize_loaded = 1

let s:dllfile = expand('<sfile>:h').'/maximize.dll'
let s:is_win = has('win32') || has('win64')

function s:Maximize()
  winpos 0 0
  if (s:is_win)
    call s:MaximizeWinWindow()
  else
    call s:MaximizeLinWindow()
  endif
endfunction

autocmd GUIEnter * call s:Maximize()

" Different strategies to maximize window

function s:MaximizeWinWindow()
  let s:save_cpoptions=&cpoptions
  set cpoptions&vim
  call libcallnr(s:dllfile, 'Maximize', 1)
  let &cpoptions=s:save_cpoptions
endfunction

function s:MaximizeLinWindow()
  call system("wmctrl -ir " . v:windowid . " -b add,maximized_vert,maximized_horz")
  "call s:MaximizeToogleFullScreenLin()
endfunction

function s:MaximizeToogleFullScreenLin()
  if exists("g:maximize_fullscreen") && g:maximize_fullscreen == 1
    let g:maximize_fullscreen = 0
    let mod = "remove"
  else
    let g:maximize_fullscreen = 1
    let mod = "add"
  endif
  call system("wmctrl -ir " . v:windowid . " -b " . mod . ",fullscreen")
endfunction

function! MaximizeToggleFullscreen()
  if (!s:is_win)
    call s:MaximizeToogleFullScreenLin()
  endif
endfunction

map <silent> <F11> :call MaximizeToggleFullscreen()<CR>
