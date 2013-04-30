" 'myak' theme is a tweaked 'desert'

" :he group-name
" :he highlight-groups
" :he cterm-colors

" List of colors can be found here:
" http://choorucode.files.wordpress.com/2011/07/20110729-vim-named-colors.png

set background=dark
if version > 580
 " no guarantees for version 5.8 and below, but this makes it stop
 " complaining
 hi clear
 if exists("syntax_on")
 syntax reset
 endif
endif
let g:colors_name="myak"

hi Normal guifg=White guibg=grey20

" Vim >= 7.0 specific colors
if version >= 700
" hi CursorLine guibg=#2d2d2d
" hi CursorColumn guibg=#2d2d2d
" hi MatchParen guifg=#f6f3e8 guibg=#857b6f gui=bold
 hi Pmenu guifg=#f6f3e8 guibg=grey40
 hi PmenuSel guifg=grey20 guibg=white
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" highlight groups
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

hi Cursor guibg=khaki guifg=slategrey
hi lCursor guifg=Cyan guibg=Cyan
"hi CursorIM
"hi Directory
"hi DiffAdd
"hi DiffChange
"hi DiffDelete
"hi DiffText
"hi ErrorMsg
hi VertSplit guibg=#c2bfa5 guifg=grey50 gui=none
hi Folded guibg=grey30 guifg=gold
hi FoldColumn guibg=grey30 guifg=tan
hi IncSearch guifg=slategrey guibg=khaki
"hi LineNr
hi ModeMsg guifg=goldenrod
hi MoreMsg guifg=SeaGreen
hi NonText guifg=SkyBlue guibg=grey20
hi Question guifg=springgreen
hi Search guibg=peru guifg=wheat
hi SpecialKey guifg=yellowgreen

" Status line
hi StatusLine guibg=#c2bfa5 guifg=black gui=bold
hi StatusLineNC guibg=#c2bfa5 guifg=grey50 gui=none

hi Title guifg=indianred
hi Visual gui=none guifg=khaki guibg=olivedrab
"hi VisualNOS
hi WarningMsg guifg=salmon
"hi WildMenu
"hi Menu
"hi Scrollbar
"hi Tooltip
hi ColorColumn guibg=gray30


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" syntax groups
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" syntax highlighting groups
hi Comment guifg=SkyBlue
hi Constant guifg=#ffa0a0
hi Identifier guifg=palegreen
hi Statement guifg=khaki
hi PreProc guifg=indianred
hi Type guifg=darkkhaki
hi Special guifg=navajowhite
"hi Underlined
hi Ignore guifg=grey40
"hi Error
hi Todo guifg=orangered guibg=yellow2

" color terminal definitions
hi SpecialKey ctermfg=darkgreen
hi NonText cterm=bold ctermfg=darkblue
hi Directory ctermfg=darkcyan
hi ErrorMsg cterm=bold ctermfg=7 ctermbg=1
hi IncSearch cterm=NONE ctermfg=yellow ctermbg=green
hi Search cterm=NONE ctermfg=grey ctermbg=blue
hi MoreMsg ctermfg=darkgreen
hi ModeMsg cterm=NONE ctermfg=brown
hi LineNr ctermfg=3
hi Question ctermfg=green
hi StatusLine cterm=bold,reverse
hi StatusLineNC cterm=reverse
hi VertSplit cterm=reverse
hi Title ctermfg=5
hi Visual cterm=reverse
hi VisualNOS cterm=bold,underline
hi WarningMsg ctermfg=1
hi WildMenu ctermfg=0 ctermbg=3
hi Folded ctermfg=darkgrey ctermbg=NONE
hi FoldColumn ctermfg=darkgrey ctermbg=NONE
hi DiffAdd ctermbg=4
hi DiffChange ctermbg=5
hi DiffDelete cterm=bold ctermfg=4 ctermbg=6
hi DiffText cterm=bold ctermbg=1
hi Comment ctermfg=darkcyan
hi Constant ctermfg=brown
hi Special ctermfg=5
hi Identifier ctermfg=6
hi Statement ctermfg=3
hi PreProc ctermfg=5
hi Type ctermfg=2
hi Underlined cterm=underline ctermfg=5
hi Ignore cterm=bold ctermfg=7
hi Ignore ctermfg=darkgrey
hi Error cterm=bold ctermfg=7 ctermbg=1
