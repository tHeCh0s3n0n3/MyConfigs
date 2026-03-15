"" My .vimrc file

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
   " Color theme
   color elflord

   " Enable syntax highlighting
   syntax on
   
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
   hi clear SpellBad
   hi SpellBad cterm=underline gui=underline

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

"""
" Plug-ins
"""

" vim: syntax=vim ts=3 sw=3 sts=3 sr et
