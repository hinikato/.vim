" The gvimrc file is where GUI-specific startup commands should be placed. It is always sourced after the .vimrc file.
" The path to .gvimrc file stored in the $MYGVIMRC Vim's environment variable.

let is_win = has('win32') || has('win64')

fun! SolarizedTheme()
  set guifont=Consolas:h10:b:cRUSSIAN
  let g:solarized_termcolors=256
  let g:solarized_contrast="high"
  let g:solarized_visibility="normal"
  set background=light
  colorscheme solarized
  autocmd Filetype * IndentGuidesDisable
  hi WildMenu guibg=red
endf

fun! MyakTheme()
  set guifont=Courier_New:h10:cRUSSIAN
  colorscheme myak
endf

" Try to use the following command to see all available fonts:
" :set guifont=*

if is_win
  call MyakTheme()
  ""call SolarizedTheme()
else
"  let g:maximize_use_winctrl = 1
  set guifont=Droid\ Sans\ Mono\ 9
endif

if has("menu")
  " To see defined commands see $VIMRUNTIME/menu.vim
  amenu PopUp.Replace\ All\ From\ Clipboard ggVG"*P
endif

":highlight ExtraWhitespace ctermbg=red guibg=red
"" The following alternative may be less obtrusive.
":highlight ExtraWhitespace ctermbg=darkgreen guibg=lightgreen
"" Try the following if your GUI uses a dark background.
":highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
"
":autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red<S-Del>
