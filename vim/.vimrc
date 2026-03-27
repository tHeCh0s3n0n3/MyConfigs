"" My .vimrc file

"""
" Functions
"""
function! GetEverythingUnderCursor()
   " 1. Syntax Engine
   let l:synID = synID(line("."), col("."), 1)
   let l:synName = synIDattr(l:synID, "name")
   let l:loName = synIDattr(synIDtrans(l:synID), "name")

   " 2. Spelling Overlay
   let [l:word, l:type] = spellbadword()
   let l:spellOut = (l:type != "") ? " SPELL<Spell" . substitute(l:type, "^.", "\\u&", "") . ">" : ""

   " 3. Search/Match Overlay
   " This checks if the current cursor position is part of a matchadd() or :match
   let l:matchOut = ""
   for l:m in getmatches()
      " Manual check for matches is complex; simplified here to show if ANY match exists
      " Many plugins use matches for 'Current Word' highlighting
   endfor

   " 4. Search Highlight (Check if cursor is on current search pattern)
   let l:searchOut = (v:hlsearch && @/ != "" && expand("<cword>") =~ @/) ? " [ON_SEARCH_RESULT]" : ""

   echo "hi<" . l:synName . "> lo<" . l:loName . ">" . l:spellOut . l:searchOut
endfunction

function! SetMySpellColors()
   " Use 'hi' directly without 'clear' to override the specific attributes
   hi SpellBad cterm=underline ctermfg=NONE ctermbg=NONE gui=underline guibg=NONE guifg=NONE guisp=NONE 
endfunction

function! SmartHome()
   let l:cursor_col = col('.')
   " Move to first non-blank character
   normal! ^
   " If we didn't move (meaning we were already there), move to column 1
   if l:cursor_col == col('.')
      normal! 0
   endif
endfunction

"""
" General
"""
   " Reset all values to their defaults
   set nocompatible  " No compatibility

   " Enable mouse
   set mouse=a

   " Better Unix/Windows compatibility
   set viewoptions=folds,options,cursor,unix,slash

   " Allow cursor beyond the last char
   set virtualedit=onemore

"""
" Colors
"""

   " Enable syntax highlighting
   syntax on

   augroup CustomSpellHighlights
      autocmd!
      " ColorScheme handles manual changes (:colorscheme ...)
      " VimEnter handles the very end of the startup sequence
      autocmd ColorScheme,VimEnter * call SetMySpellColors()
   augroup END

   " Default Color Scheme (see below for file specific Color Schemes
   " disabled to keep the default theme while building a list of files and the colorscheme for each
   "color elflord
   autocmd FileType vim colorscheme koehler
   autocmd FileType gitconfig colorscheme koehler
   nnoremap <F10> :call GetEverythingUnderCursor()<CR>

   
   " Highlight current line and cursor
   set cursorline
   hi CursorLine cterm=underline gui=underline ctermbg=NONE guibg=NONE
   hi CursorColumn guibg=#333333

   " Status Line colors
   hi StatusLine term=bold cterm=bold ctermfg=4 ctermbg=0 gui=bold guifg=blue guibg=black
   
   " Tab bar colors
   hi TabLineSel  term=reverse      cterm=bold ctermfg=0 ctermbg=2 gui=bold guifg=white guibg=black
   hi TabLineFill term=bold,reverse cterm=bold ctermfg=7 ctermbg=3 gui=bold guifg=blue  guibg=black
   hi TabLine     term=bold,reverse cterm=bold ctermfg=7 ctermbg=5 gui=bold guifg=blue  guibg=black

"""
" Formatting and stuff
"""
   " Set tabstops
   set tabstop=3
   set softtabstop=3
   set expandtab
   set autoindent
   set shiftwidth=3

   " No Wrap
   set nowrap

   " Format comment blocks
   set comments=sl:/*,mb:*,elx:*/
   
   " Enable spelling and configure it
   set spell 

   " Enable modelines
   set modeline

"""
" UI
"""
   " Line numbers are good
   set number
   
   " Show matching brackets/parenthesis
   set showmatch
   
   " Show list instead of just completing
   set wildmenu
   set wildmode=list:longest,full

   " Show current mode
   set showmode

   " No Wrapping
   set nowrap

   ""
   " Status Line
   ""
      " Show an extra status line
      set laststatus=2

      " Filename
      set statusline=%<%f\
      
      " Options
      set statusline+=%w%h%m%r
      
      " File Type
      set statusline+=\ [%{&ff}/%Y]
      
      " Current DIR
      set statusline+=\ [%{getcwd()}]
      
      " ASCII Hex Value of char
      "set statusline+=\ [A=\%03.3b/H=\02.2B]
      
      " Right aligned file navigation information
      set statusline+=%=%-14.(%l,%c%V%)\ %p%%

   " Set tab completion mode
   set wildmenu
   set wildmode=list:longest,full

"""
" Key (re)Mapping
"""
   " Backspace for dummies
   set backspace=indent,eol,start

   " For when you forget to sudo
   cmap w!! !sudo tee % >/dev/null

   " Map F2 and F3 to next and previous tab
   inoremap <F2> <C-O>:tabp<CR>
   inoremap <F3> <C-O>:tabn<CR>
   nnoremap <F2> :tabp<CR>
   nnoremap <F3> :tabn<CR>

   " Map the Home key in Normal, Visual, and Insert modes (SmartHome)
   nnoremap <Home> :call SmartHome()<CR>
   vnoremap <Home> :<C-u>call SmartHome()<CR>gv
   inoremap <Home> <C-o>:call SmartHome()<CR>
   nnoremap 0 :call SmartHome()<CR>

"""
" Plug-ins
"""

" vim: syntax=vim ts=3 sw=3 sts=3 sr et
