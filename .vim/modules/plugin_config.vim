" built-in file browsing:
let g:netrw_banner=0
let g:netrw_browse_split=4
let g:netrw_altv=1
let g:netrw_liststyle=3
"let g:netrw_list_hide=netrw_gitignore#Hide()
"let g:netrw_list_hide.=',\(^\|\s\s)\zs\.\S\+'

" coc config
let g:coc_data_home = '~/.local/share/coc/'
let g:node_client_debug = 0
autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()

hi link CocUnderline ErrorMsg
hi CocCurColumn ctermfg=15 ctermbg=7
hi CocErrorSign ctermfg=12 ctermbg=7

" compatibility with vim-latexsuite
set grepprg=grep\ -nH\ $*
let g:tex_flavor = "latex"

" vim-vmath keybindings
vmap <expr>  ++  VMATH_YankAndAnalyse()
nmap         ++  vip++

" dragvisuals plugin key bindings
vmap  <expr>  <LEFT>   DVB_Drag('left')
vmap  <expr>  <RIGHT>  DVB_Drag('right')
vmap  <expr>  <DOWN>   DVB_Drag('down')
vmap  <expr>  <UP>     DVB_Drag('up')
vmap  <expr>  D        DVB_Duplicate()

" lightline
" https://github.com/itchyny/lightline.vim/blob/master/README.md#advanced-configuration
let g:lightline = {
    \ 'colorscheme': 'wombat',
    \ 'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
    \ 'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" },
    \ 'active': {
    \     'left': [
    \         [ 'mode', 'paste' ],
    \         [ 'gitbranch', 'readonly', 'relativepath', 'modified', 'charvaluehex', 'cocstatus']
    \     ],
    \     'right': [
    \         [ 'lineinfo' ],
    \         [ 'column', 'line', 'percent' ],
    \         [ 'fileformat', 'fileencoding', 'filetype' ]
    \     ]
    \ },
    \ 'component_function': {
    \     'gitbranch': 'FugitiveHead',
    \     'cocstatus': 'coc#status'
    \ },
    \ 'component': {
    \     'charvaluehex': '0x%B'
    \ }
\ }
