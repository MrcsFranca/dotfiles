" Vim settings
" -------------

"  enable wrap text when it goes beyond the screen length
set wrap

" force encoding
set encoding=utf-8

" set tab space
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smartindent

" set number
set number

" status bar
set laststatus=2

" remap keys

" close what need to be closed
inoremap ( ()<left>
inoremap ) ()<left>
inoremap [ []<left>
inoremap {<CR> {<CR>}<ESC>O
inoremap }<CR> {<CR>}<ESC>O
inoremap ' ''<left>
inoremap " ""<left>
