set nu  " numbers
set rnu  " relative numbers
set ru  " ruler
set mouse=a
set noeb  " noerrorbells

set sts=4  " softtab
set ts=4  " tabstop
set shiftwidth=4
set cin  " cindent

set hls  " highlight search
set is  " incremental search
set sc  " show command

set nowrap
set so=8  " scroll offset

set undofile
sy on  " syntax

let mapleader = " "
no <leader>ww :w<CR>
no <leader>wq :wq<CR>
no <leader>q :q<CR>

nn <leader>yy "+yy
vn <leader>y "+y

no x "_x
no X "_X

no <leader>c :norm 0i// <CR>


" compact version
" set nu rnu ru mouse=a nowrap so=8 hls is noeb
" set sts=4 ts=4 shiftwidth=4 cin
" set undofile
" sy on
" 
" let mapleader=" "
" no <leader>ww :w<CR>
" no <leader>q :q<CR>
" no <leader>wq :wq<CR>
" nn <leader>yy "+yy
" vn <leader>y "+y
" no x "_x
" no <leader>c :norm 0i// <CR>
