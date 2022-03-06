" Use more natural key movement on wrapped lines.
nnoremap j gj
nnoremap k gk
nnoremap gj 5j
nnoremap gk 5k
" Keep selection when indent/dedenting in select mode.
vnoremap > >gv
vnoremap < <gv
" Make Y copy to end of line instead of be an alias for yy
nnoremap Y y$
" Who uses ';' anyways?
nnoremap ; :

" Ctrl+\ : open ctag definition in new tab
map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
" Alt+] : open ctag definition in vertical split
map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

" highlight cursorline and cursorcolumn
highlight CursorLine   cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
highlight CursorColumn cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
" \c will toggle highlighting on and off (to make it easy to locate the cursor in a large file)
nnoremap <Leader>c :set cursorline! cursorcolumn!<CR>
nnoremap <Leader>tf :tabnew<CR>:FZF<CR>
nnoremap <Leader>ta :tabnew<CR>:Ag 

noremap <leader>bash :r ~/.vim/snippets/bash-snippet<CR>kdd
noremap <leader>py :r ~/.vim/snippets/python-snippet<CR>kdd
noremap <leader>clang :r ~/.vim/snippets/c-snippet<CR>kdd
noremap <leader>java :r ~/.vim/snippets/java-snippet<CR>kdd

nnoremap <leader>udt :UndotreeToggle<CR>

nnoremap <leader>no :set nonumber<CR>:set norelativenumber<CR>
nnoremap <leader>nb :set number<CR>:set norelativenumber<CR>
nnoremap <leader>nr :set number<CR>:set relativenumber<CR>

" to please the Olde Gods
iabbrev cthuf Ia! Ia! Cthulhu fhtagn! Ph'nglui mglw'nafh Cthulhu R'lyeh wgah'nagl fhtagn! Cthulhu fhtagn! Cthulhu fhtagn!
