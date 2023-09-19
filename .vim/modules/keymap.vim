" ==============================================================================
" ========================= VIM UNIVERSAL KEYBINDINGS ==========================
" ==============================================================================

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
" commands are more useful than repeat last search
nnoremap ; :
nnoremap : ;

" Shortcut to reference current file's path in command line mode
cnoremap <expr> %% expand('%:h').'/'


" ==============================================================================
" ================================= VIM EDITOR =================================
" ==============================================================================

" highlight cursorline and cursorcolumn
highlight CursorLine   cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
highlight CursorColumn cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
" \c will toggle highlighting on and off (to make it easy to locate the cursor in a large file)
nnoremap <Leader>vc :set cursorline! cursorcolumn!<CR>
nnoremap <leader>vk :split ~/.vim/modules/keymap.vim<CR>
nnoremap <leader>vimrc :split ~/.vim/vimrc<CR>
nnoremap <leader>vr :Reload<CR>
noremap <leader>vsw :call SelectWindowSwap()<CR>
noremap <leader>vmw :call MoveWindowSwap()<CR>
nnoremap <leader>vno :set nonumber<CR>:set norelativenumber<CR>
nnoremap <leader>vnb :set number<CR>:set norelativenumber<CR>
nnoremap <leader>vnr :set number<CR>:set relativenumber<CR>
inoremap <expr> <tab> InsertTabWrapper()
inoremap <s-tab> <c-n>
nnoremap <leader>vrename :call RenameFile()<CR>

" no root? no problem! save with 'w!!'
cmap w!! w !sudo tee % >/dev/null


" ==============================================================================
" =============================== BASIC PLUGINS ================================
" ==============================================================================

" dragvisuals plugin key bindings
vmap  <expr>  <LEFT>   DVB_Drag('left')
vmap  <expr>  <RIGHT>  DVB_Drag('right')
vmap  <expr>  <DOWN>   DVB_Drag('down')
vmap  <expr>  <UP>     DVB_Drag('up')
vmap  <expr>  D        DVB_Duplicate()

" vim-vmath keybindings
vmap <expr>  ++  VMATH_YankAndAnalyse()
nmap         ++  vip++


" ==============================================================================
" ==================================== GIT =====================================
" ==============================================================================

noremap <leader>gb :Git blame<CR>


" ==============================================================================
" ================================ CTAGS/CSCOPE ================================
" ==============================================================================
"
" ==============================================================================
" ================================ PROGRAMMING =================================
" ==============================================================================

" Ctrl+\ : open ctag definition in new tab
map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
" Alt+] : open ctag definition in vertical split
map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

nnoremap <leader>udt :UndotreeToggle<CR>

noremap <leader>pbash :r ~/.vim/snippets/bash-snippet<CR>kdd
noremap <leader>ppy :r ~/.vim/snippets/python-snippet<CR>kdd
noremap <leader>pclang :r ~/.vim/snippets/c-snippet<CR>kdd
noremap <leader>pjava :r ~/.vim/snippets/java-snippet<CR>kdd

"map <C-n> :cnext<CR>                " move to next error
"map <C-m> :cprevious<CR>            " move to previous error

" golang
if &filetype ==# 'go'
nnoremap <leader>pb :<C-u>call <SID>Build_go_files()<CR>
nnoremap <leader>pr <Plug>(go-run)
nnoremap <leader>pt <Plug>(go-test)
nnoremap <leader>pft <Plug>(go-test-func)
nnoremap <leader>pd <Plug>(go-describe)
"
nnoremap <expr> <leader>pi ":GoImport ".expand("<cword>")"<CR>"

nnoremap <leader>ptc <Plug>(go-coverage-toggle)
nnoremap <leader>ptg :GoAlternate<CR>
endif

" java
if &filetype ==# 'java'
" enable smart (trying to guess import option) inserting class imports
nmap <F5> <Plug>(JavaComplete-Imports-AddSmart)
imap <F5> <Plug>(JavaComplete-Imports-AddSmart)

" enable usual (will ask for import option) inserting class imports with F6, add:
nmap <F6> <Plug>(JavaComplete-Imports-Add)
imap <F6> <Plug>(JavaComplete-Imports-Add)

" add all missing imports with F7:
nmap <F7> <Plug>(JavaComplete-Imports-AddMissing)
imap <F7> <Plug>(JavaComplete-Imports-AddMissing)

" remove all unused imports with F8:
nmap <F8> <Plug>(JavaComplete-Imports-RemoveUnused)
imap <F8> <Plug>(JavaComplete-Imports-RemoveUnused)
endif

" ==============================================================================
" ================================= DEBUGGING ==================================
" ==============================================================================
nnoremap <Leader>dd :<C-u>call Vimspector_toggle_active()<CR>
nnoremap <Leader>dc :call vimspector#Continue()<CR>

nnoremap <Leader>db :call vimspector#ToggleBreakpoint()<CR>
nnoremap <Leader>dC :call vimspector#ClearBreakpoints()<CR>

nmap <Leader>dr <Plug>VimspectorRestart
nmap <Leader>dso <Plug>VimspectorStepOut
nmap <Leader>dsi <Plug>VimspectorStepInto
nmap <Leader>dn <Plug>VimspectorStepOver

" ==============================================================================
" ================================ FUZZY SEARCH ================================
" ==============================================================================

" navigation search
" syntax:
"   - <leader>n HOW WHAT
"   - <leader>y HOW WHAT
" All key combos start with <leader>, usually \ (backslash)
" HOW:  e -> edit
"       v -> vsplit
"       s -> hsplit
"       t -> new tab
" WHAT: a -> ag (silver searcher) in quickfix mode
"      f -> files in subdirs
"      h -> files historical
"      l -> lines in this file
"      b -> lines in all buffers
"      r -> ripgrep
nnoremap <Leader>nea :Ag 
nnoremap <Leader>nta :tabnew<CR>:Ag 
nnoremap <Leader>nva :vsp<CR>:Ag 
nnoremap <Leader>nsa :sp<CR>:Ag 
nnoremap <expr> <Leader>yea ":Ag ".expand("<cword>")."<CR>"
nnoremap <expr> <Leader>yta ":tabnew<CR>:Ag ".expand("<cword>")."<CR>"
nnoremap <expr> <Leader>yva ":vsp<CR>:Ag ".expand("<cword>")."<CR>"
nnoremap <expr> <Leader>ysa ":sp<CR>:Ag ".expand("<cword>")."<CR>"

nnoremap <Leader>nef :Files<CR>
nnoremap <Leader>ntf :tabnew<CR>:Files<CR>
nnoremap <Leader>nvf :vsp<CR>:Files<CR>
nnoremap <Leader>nsf :sp<CR>:Files<CR>
nnoremap <expr> <Leader>yef ":Files<CR>".expand("<cword>")
nnoremap <expr> <Leader>ytf ":tabnew<CR>:Files<CR>".expand("<cword>")
nnoremap <expr> <Leader>yvf ":vsp<CR>:Files<CR>".expand("<cword>")
nnoremap <expr> <Leader>ysf ":sp<CR>:Files<CR>".expand("<cword>")

nnoremap <Leader>neh :History<CR>
nnoremap <Leader>nth :tabnew<CR>:History<CR>
nnoremap <Leader>nvh :vsp<CR>:History<CR>
nnoremap <Leader>nsh :sp<CR>:History<CR>
nnoremap <expr> <Leader>yeh ":History<CR>".expand("<cword>")
nnoremap <expr> <Leader>yth ":tabnew<CR>:History<CR>".expand("<cword>")
nnoremap <expr> <Leader>yvh ":vsp<CR>:History<CR>".expand("<cword>")
nnoremap <expr> <Leader>ysh ":sp<CR>:History<CR>".expand("<cword>")

nnoremap <Leader>nel :Blines<CR>
nnoremap <Leader>ntl :tabnew<CR>:Blines<CR>
nnoremap <Leader>nvl :vsp<CR>:Blines<CR>
nnoremap <Leader>nsl :sp<CR>:Blines<CR>
nnoremap <expr> <Leader>yel ":BLines ".expand("<cword>")
nnoremap <expr> <Leader>ytl ":tabnew<CR>:BLines<CR>".expand("<cword>")
nnoremap <expr> <Leader>yvl ":vsp<CR>:BLines<CR>".expand("<cword>")
nnoremap <expr> <Leader>ysl ":sp<CR>:BLines<CR>".expand("<cword>")

nnoremap <Leader>neb :Lines<CR>
nnoremap <Leader>ntb :tabnew<CR>:Lines<CR>
nnoremap <Leader>nvb :vsp<CR>:Lines<CR>
nnoremap <Leader>nsb :sp<CR>:Lines<CR>
nnoremap <expr> <Leader>yeb ":Lines ".expand("<cword>")
nnoremap <expr> <Leader>ytb ":tabnew<CR>:LinesgCR>".expand("<cword>")
nnoremap <expr> <Leader>yvb ":vsp<CR>:Lines<CR>".expand("<cword>")
nnoremap <expr> <Leader>ysb ":vsp<CR>:Lines<CR>".expand("<cword>")

nnoremap <Leader>ner :Rg<CR>
nnoremap <Leader>ntr :tabnew<CR>:Rg<CR>
nnoremap <Leader>nvr :vsp<CR>:Rg<CR>
nnoremap <Leader>nsr :sp<CR>:Rg<CR>
nnoremap <expr> <Leader>yer ":Rg<CR>".expand("<cword>")
nnoremap <expr> <Leader>ytr ":tabnew<CR>:Rg<CR>".expand("<cword>")
nnoremap <expr> <Leader>yvr ":vsp<CR>:Rg<CR>".expand("<cword>")
nnoremap <expr> <Leader>ysr ":sp<CR>:Rg<CR>".expand("<cword>")


" ==============================================================================
" ============================== COC NAVIGAT%ION ===============================
" ==============================================================================

" Use `[g` and `]g` to navigate diagnostics
" nmap <silent> [g <Plug>(coc-diagnostic-prev)
" nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> ged <Plug>(coc-definition)
nmap <silent> gtd :call CocAction('jumpDefinition', 'tabe')<CR>
nmap <silent> gvd :call CocAction('jumpDefinition', 'vsp')<CR>
nmap <silent> gsd :call CocAction('jumpDefinition', 'sp')<CR>

nmap <silent> gey <Plug>(coc-type-definition)
nmap <silent> gty :call CocAction('jumpTypeDefinition', 'tabe')<CR>
nmap <silent> gvy :call CocAction('jumpTypeDefinition', 'vsp')<CR>
nmap <silent> gsy :call CocAction('jumpTypeDefinition', 'sp')<CR>

nmap <silent> gei <Plug>(coc-implementation)
nmap <silent> gti :call CocAction('jumpImplementation', 'tabe')<CR>
nmap <silent> gvi :call CocAction('jumpImplementation', 'vsp')<CR>
nmap <silent> gsi :call CocAction('jumpImplementation', 'sp')<CR>

nmap <silent> ger <Plug>(coc-references)
nmap <silent> gtr :call CocAction('jumpReferences', 'tabe')<CR>
nmap <silent> gvr :call CocAction('jumpReferences', 'vsp')<CR>
nmap <silent> gsr :call CocAction('jumpReferences', 'sp')<CR>

" Remap for rename current word
nmap <F2> <Plug>(coc-rename)

" Highlight symbol under cursor on CursorHold
nnoremap <leader>gh :silent call CocActionAsync('highlight')<CR>
"autocmd CursorHold * silent call CocActionAsync('highlight')

" Use K to show documentation in preview window
" nnoremap <silent> K :call <SID>show_documentation()<CR>
"function! s:show_documentation()
"  if (index(['vim','help'], &filetype) >= 0)
"    execute 'h '.expand('<cword>')
"  else
"    call CocAction('doHover')
"  endif
"endfunction

"" Remap for format selected region
"xmap <leader>f  <Plug>(coc-format-selected)
"nmap <leader>f  <Plug>(coc-format-selected)
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

" to please the Olde Gods
iabbrev cthuf Ia! Ia! Cthulhu fhtagn! Ph'nglui mglw'nafh Cthulhu R'lyeh wgah'nagl fhtagn! Cthulhu fhtagn! Cthulhu fhtagn!
