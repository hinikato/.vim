1. Installation
---------------

### 1.1. Linux

```
    git clone https://github.com/hinikato/.vim.git ~/.vim
    cd ~/.vim && chmod +x *.sh && source vim-init.sh
```

### 1.2. Windows

1. Run the following commands (you can do the same commands by other way or you can install the DevKit:
https://github.com/downloads/oneclick/rubyinstaller/DevKit-tdm-32-4.5.2-20111229-1559-sfx.exe):

```
    git clone https://github.com/hinikato/.vim.git $VIM/vimfiles
    cp $VIM/vimfiles/.vimrc $VIM
    cp $VIM/vimfiles/.gvimrc $VIM
```
where $VIM variable should be replaced with path where the gvim.exe executable can be found. You can find it with
the following command:

```
    :echo $VIM
```

This command should be executed in Vim.

2. After that run the following commands:

```
    cd $VIM/vimfiles
    git submodule update --init
```


2. Keys
-------

<table>
    <tr>
        <th>
            Keys
        </th>
        <th>
            Description
        </th>
        <th>
            Mode
        </th>
    </tr>
    <tr>
        <td>,</td>
        <td>Leader key</td>
        <td>Mode independent</td>
    </tr>
    <tr>
        <td>
            Ctrl+k
        </td>
        <td>
            Move line up (author Skip)
        </td>
        <td>
            Insert, Normal
        </td>
    </tr>
    <tr>
        <td>
            Ctrl+j
        </td>
        <td>
            Move line down (author Skip)
        </td>
        <td>
            Insert, Normal
        </td>
    </tr>
    <tr>
        <td>
            Ctrl+s
        </td>
        <td>
            Save current file
        </td>
        <td>
            Insert, Normal
        </td>
    </tr>
    <tr>
        <td>
            Alt+h
        </td>
        <td>
            Move cursor to the left window
        </td>
        <td>
            Normal
        </td>
    </tr>
    <tr>
        <td>
            Alt+j
        </td>
        <td>
            Move cursor to the below window
        </td>
        <td>
            Normal
        </td>
    </tr>
    <tr>
        <td>
            Alt+k
        </td>
        <td>
            Move cursor to the above window
        </td>
        <td>
            Normal
        </td>
    </tr>
    <tr>
        <td>
            Alt+l
        </td>
        <td>
            Move cursor to the right window.
        </td>
        <td>
            Normal
        </td>
    </tr>
    <tr>
        <td>
            F2
        </td>
        <td>
            Show NERDTree explorer in the left window.
        </td>
        <td>
            Normal
        </td>
    </tr>
    <tr>
        <td>
            F3
        </td>
        <td>
            Save file and strip trailing spaces at the end of lines.
        </td>
        <td>
            Normal
        </td>
    </tr>
    <tr>
        <td>
            F4
        </td>
        <td>
            Search for bootstrap.php file in the current directory and if not found in subdirectories recursively and
            run the
<pre><code>phpunit --bootstrap bootstrap.php current_file.php</code></pre>
            command.
        </td>
        <td>
            Normal
        </td>
    </tr>
    <tr>
        <td>
            F5
        </td>
        <td>
            Run the python, php, node or dart with current file as argument.
        </td>
        <td>
            Insert, Normal, Command-line
        </td>
    </tr>
    <tr>
        <td>
            Ctrl+Enter
        </td>
        <td>
            Paste of the selected text to the command line
        </td>
        <td>
            Normal
        </td>
    </tr>
    <tr>
        <td>
            Ctrl+Tab
        </td>
        <td>
            Next tab
        </td>
        <td>
            Insert, Normal
        </td>
    </tr>
    <tr>
        <td>
            Ctrl+Shift+Tab
        </td>
        <td>
            Previous tab
        </td>
        <td>
            Insert, Normal
        </td>
    </tr>
</table>


3. Language switcher fix (Windows only)
---------------------------------------

In the bundle/myak/myak.vim there is the following block of code:

```
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
```
It responsible for switching language to English when Vim enters to the Insert mode and
for the restoring previos language back when Vim leaves the Insert mode. To allow it work we use the
.dll file that has been attached to the following [article (ru language)](http://habrahabr.ru/post/162483/).

This approach don't work for the Ctrl-[ combination, so additional fix must be applied, using the following
[AutoHotkey](http://www.autohotkey.com/) script:

```
; If you don't need switch keyboard with Caps Lock just comment out
; the next 3 lines below.
CapsLock::Send, {Alt Down}{Shift Down}{Shift Up}{Alt Up}
return

!CapsLock::CapsLock

; The $ prevents AutoHotkey from confusing sent keystrokes (via Send commands) with keypresses made by the user.
; If we didn't put that, we would get an infinite loop,
; see http://stackoverflow.com/questions/15840608/autohotkey-send-default-behavior-if-condition-not-met 
; The ^ means Ctrl
; The :: means execute next command.
$^[::
if WinActive("ahk_class Vim") {
    Send {Esc}
} else {
    Send ^[
}

return
```
Just compile it with the Ahk2Exe.exe (it included in the AutoHotkey installation) and ensure that
the produced .exe is autoloaded during Windows boot.
