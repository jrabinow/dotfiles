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

" open help command on current word under cursor
nnoremap <F1> :exec("help ".expand("<cword>"))<CR>

" highlight cursorline and cursorcolumn
highlight CursorLine   cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
highlight CursorColumn cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
" \c will toggle highlighting on and off (to make it easy to locate the cursor in a large file)
nnoremap <Leader>c :set cursorline! cursorcolumn!<CR>

noremap <leader>bash :r ~/.vim/snippets/bash-snippet<CR>kdd
noremap <leader>py :r ~/.vim/snippets/python-snippet<CR>kdd
noremap <leader>clang :r ~/.vim/snippets/c-snippet<CR>kdd
noremap <leader>java :r ~/.vim/snippets/java-snippet<CR>kdd

nnoremap <leader>no :set nonumber<CR>:set norelativenumber<CR>
nnoremap <leader>nb :set number<CR>:set norelativenumber<CR>
nnoremap <leader>nr :set number<CR>:set relativenumber<CR>

" to please the Olde Gods
iabbrev cthuf Ia! Ia! Cthulhu fhtagn! Ph'nglui mglw'nafh Cthulhu R'lyeh wgah'nagl fhtagn! Cthulhu fhtagn! Cthulhu fhtagn!

" Plugin keymapping
" Ctrl+\ : open ctag definition in new tab
map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
" Alt+] : open ctag definition in vertical split
map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

nnoremap <leader>udt :UndotreeToggle<CR>

" Use `[g` and `]g` to navigate diagnostics
" nmap <silent> [g <Plug>(coc-diagnostic-prev)
" nmap <silent> ]g <Plug>(coc-diagnostic-next)
"
" " Remap keys for gotos
" nmap <silent> gd <Plug>(coc-definition)
" nmap <silent> gy <Plug>(coc-type-definition)
" nmap <silent> gi <Plug>(coc-implementation)
" nmap <silent> gr <Plug>(coc-references)
"
" " Use K to show documentation in preview window
" nnoremap <silent> K :call <SID>show_documentation()<CR>
"function! s:show_documentation()
"  if (index(['vim','help'], &filetype) >= 0)
"    execute 'h '.expand('<cword>')
"  else
"    call CocAction('doHover')
"  endif
"endfunction
"
"" Highlight symbol under cursor on CursorHold
"autocmd CursorHold * silent call CocActionAsync('highlight')
"
"" Remap for rename current word
"nmap <F2> <Plug>(coc-rename)
"
"" Remap for format selected region
"xmap <leader>f  <Plug>(coc-format-selected)
"nmap <leader>f  <Plug>(coc-format-selected)"
"" Using CocList
"" Show all diagnostics
"nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
"" Manage extensions
"nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
"" Show commands
"nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
"" Find symbol of current document
"nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
"" Search workspace symbols
"nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
"" Do default action for next item.
"nnoremap <silent> <space>j  :<C-u>CocNext<CR>
"" Do default action for previous item.
"nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
"" Resume latest coc list
"nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
"
"" Use `:Format` to format current buffer
" command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
" command! -nargs=? Fold :call     CocAction('fold', <f-args>)
"
" " use `:OR` for organize import of current buffer
" command! -nargs=0 OR   :call     CocAction('runCommand',
" 'editor.action.organizeImport')
"
" " Add status line support, for integration with other plugin, checkout `:h
" coc-status`
" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" navigation
" syntax: <leader>n WHAT HOW
" All key combos start with <leader>, usually \ (backslash)
" WHAT: a -> ag (silver searcher) in quickfix mode
"      f -> files in subdirs
"      F -> files historical
"      l -> lines in this file
"      L -> lines in all buffers
"      r -> ripgrep
" HOW:  e -> edit
"       v -> vsplit
"       s -> hsplit
"       t -> new tab
nnoremap <Leader>na :Ag
nnoremap <expr> <Leader>nae ":Ag ".expand("<cword>")
nnoremap <expr> <Leader>nat ":tabnew<CR>:Ag ".expand("<cword>")
nnoremap <expr> <Leader>nav ":vsp<CR>:Ag ".expand("<cword>")

nnoremap <Leader>nf :Files<CR>
nnoremap <expr> <Leader>nfe ":Files<CR>".expand("<cword>")
nnoremap <expr> <Leader>nft ":tabnew<CR>:Files<CR>".expand("<cword>")
nnoremap <expr> <Leader>nfv ":vsp<CR>:Files<CR>".expand("<cword>")

nnoremap <Leader>nF :History<CR>
nnoremap <expr> <Leader>nFe ":History<CR>".expand("<cword>")
nnoremap <expr> <Leader>nFv ":vsp<CR>:History<CR>".expand("<cword>")
nnoremap <expr> <Leader>nFt ":tabnew<CR>:History<CR>".expand("<cword>")

nnoremap <Leader>nl :BLines<CR>
nnoremap <expr> <Leader>nle ":BLines ".expand("<cword>")
nnoremap <expr> <Leader>nlt ":tabnew<CR>:BLines<CR>".expand("<cword>")
nnoremap <expr> <Leader>nlv ":vsp<CR>:BLines<CR>".expand("<cword>")

nnoremap <Leader>nL :Lines<CR>
nnoremap <expr> <Leader>nLe ":Lines ".expand("<cword>")
nnoremap <expr> <Leader>nLt ":tabnew<CR>:LinesgCR>".expand("<cword>")
nnoremap <expr> <Leader>nLv ":vsp<CR>:Lines<CR>".expand("<cword>")

nnoremap <Leader>nr :Rg<CR>
nnoremap <expr> <Leader>nre ":Rg<CR>".expand("<cword>")
nnoremap <expr> <Leader>nrt ":tabnew<CR>:Rg<CR>".expand("<cword>")
nnoremap <expr> <Leader>nrv ":vsp<CR>:Rg<CR>".expand("<cword>")
