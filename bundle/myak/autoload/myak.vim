" Fixed version of pathogen#helptags()
function! myak#helptags()
  let sep = pathogen#separator()
  for dir in pathogen#split(&rtp)
    if filewritable(dir.sep.'doc') == 2 && !empty(filter(split(glob(dir.sep.'doc'.sep.'*'),"\n>"),'!isdirectory(v:val)')) && (!filereadable(dir.sep.'doc'.sep.'tags') || filewritable(dir.sep.'doc'.sep.'tags'))
      helptags `=dir.'/doc'`
    endif
  endfor
endfunction

fun myak#is_win()
  return has('win32') || has('win64')
endf

" return string|array
fun myak#__dir__(as_list)
  let path = substitute(expand('%:p:h'), '\\', '/', 'g')
  if a:as_list
    return split(path, '/')
  endif
  return path
endf

fun myak#show_how_expand()
  echo expand('<sfile>:p')
  ":p    expand to full path
  ":h    head (last path component removed)
  ":t    tail (last path component only)
  ":r    root (one extension removed)
  ":e    extension only
endf

fun myak#normalize_spaces()
  silent exe ':%s/\r$//ge'
  silent exe ':%s/\s\+$//ge'
  silent exe ':%s/\t/    /ge'
  silent exe ':update'
endf

fun myak#list_to_path(list)
  if (has('win32') || has('win64'))
    let root_dir_path = ''
  else
    let root_dir_path = '/'
  endif
  return root_dir_path . join(a:list, '/')
endf

fun myak#path_to_list(path)
  return split(substitute(a:path, '\\', '/', 'g'), '/')
endf

fun myak#chunk_of_path(path, index)
  let chunks = myak#path_to_list(a:path)
  return chunks[a:index]
endf

fun myak#is_file(path)
  return filereadable(a:path)
endf

fun myak#is_dir(path)
  return isdirectory(a:path)
endf

fun myak#find_file_up(file_path, file_name, is_dir)
  let chunks = myak#path_to_list(a:file_path)
  while len(chunks) > 0
    let tmp_file_path = myak#list_to_path(chunks) . '/' . a:file_name
    let chunks = chunks[:-2]
    if a:is_dir
      if myak#is_dir(tmp_file_path)
        return tmp_file_path
      endif
    else
      if myak#is_file(tmp_file_path)
        return tmp_file_path
      endif
    end
  endwhile
  return ''
endf

fun myak#test()
"  let t = myak#find_file_up(myak#__dir__(0), 'soft', 1)
endf

" Escape special characters in a string for exact matching.
" This is useful to copying strings from the file to the search tool
" Based on this - http://peterodding.com/code/vim/profile/autoload/xolox/escape.vim
function! myak#escape_string(string)
  let string=a:string
  " Escape regex characters
  let string = escape(string, '^$.*\/~[]')
  " Escape the line endings
  let string = substitute(string, '\n', '\\n', 'g')
  return string
endfunction

" Get the current visual block for search and replaces
" This function passed the visual block through a string escape function
" Based on this - http://stackoverflow.com/questions/676600/vim-replace-selected-text/677918#677918
function! myak#get_visual() range
  " Save the current register and clipboard
  let reg_save = getreg('"')
  let regtype_save = getregtype('"')
  let cb_save = &clipboard
  set clipboard&

  " Put the current visual selection in the " register
  normal! ""gvy
  let selection = getreg('"')

  " Put the saved registers and clipboards back
  call setreg('"', reg_save, regtype_save)
  let &clipboard = cb_save

  "Escape any special characters in the selection
  let escaped_selection = myak#escape_string(selection)

  return escaped_selection
endfunction

fun myak#echo_silent(msg)
""  :silent echo a:msg
  ""redraw
  ""echon a:msg
endf

fun myak#init_myvim()
  let dir_path = myak#find_file_up(myak#__dir__(0), '.myvim', 1)
  if strlen(dir_path) > 0
    let myvim_file_path = dir_path . '/myvim.vim'
    if myak#is_file(myvim_file_path)
      exe "source " . l:myvim_file_path
      call myak#echo_silent("Sourced the '" . myvim_file_path . "' file.")
    endif
  endif
endf

fun myak#pre_it(line1, line2)
  let old_ft=&ft
  setlocal ft=

  "let text = myak#get_visual()
  let savepos = getpos('.')
  execute a:line1 . ',' . a:line2 . "s/&/\&amp;/ge"
  execute a:line1 . ',' . a:line2 . 's/</\&lt;/ge'
  execute a:line1 . ',' . a:line2 . 's/>/\&gt;/ge'
  execute a:line1 . ',' . a:line2 . 's/''/\&#039;/ge'
  execute a:line1 . ',' . a:line2 . 's/"/\&quot;/ge'

  normal `<
  exe "normal I<pre>"
  normal `>
  exe "normal A</pre>"

  call histdel('search', -1)
  call setpos('.', savepos)

  " &l:option means setlocal
  let &l:ft=old_ft
endf

call myak#init_myvim()


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CMD
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

command! -complete=command -range=% Pre call myak#pre_it(<line1>, <line2>)
command! -bar HelpTags :call myak#helptags()


" Return indent (all whitespace at start of a line), converted from
" tabs to spaces if what = 1, or from spaces to tabs otherwise.
" When converting to tabs, result has no redundant spaces.
function! Indenting(indent, what, cols)
  let spccol = repeat(' ', a:cols)
  let result = substitute(a:indent, spccol, '\t', 'g')
  let result = substitute(result, ' \+\ze\t', '', 'g')
  if a:what == 1
    let result = substitute(result, '\t', spccol, 'g')
  endif
  return result
endfunction

" Convert whitespace used for indenting (before first non-whitespace).
" what = 0 (convert spaces to tabs), or 1 (convert tabs to spaces).
" cols = string with number of columns per tab, or empty to use 'tabstop'.
" The cursor position is restored, but the cursor will be in a different
" column when the number of characters in the indent of the line is changed.
function! IndentConvert(line1, line2, what, cols)
  let savepos = getpos('.')
  let cols = empty(a:cols) ? &tabstop : a:cols
  execute a:line1 . ',' . a:line2 . 's/^\s\+/\=Indenting(submatch(0), a:what, cols)/e'
  call histdel('search', -1)
  call setpos('.', savepos)
endfunction

command! -nargs=? -range=% Space2Tab call IndentConvert(<line1>,<line2>,0,<q-args>)
command! -nargs=? -range=% Tab2Space call IndentConvert(<line1>,<line2>,1,<q-args>)
command! -nargs=? -range=% RetabIndent call IndentConvert(<line1>,<line2>,&et,<q-args>)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mapping
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Paste selected text with the <C-Enter>
vmap <C-Enter> <Esc>:%s/<c-r>=myak#get_visual()<cr>/
