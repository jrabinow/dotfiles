" built-in file browsing:
let g:netrw_banner = 0
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_liststyle = 3
"let g:netrw_list_hide=netrw_gitignore#Hide()
"let g:netrw_list_hide.=',\(^\|\s\s)\zs\.\S\+'

" coc config
let g:coc_data_home = '~/.local/share/vim/plugin-data/coc/'
let g:node_client_debug = 0
autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()

hi link CocUnderline ErrorMsg
hi CocCurColumn ctermfg=15 ctermbg=7
hi CocErrorSign ctermfg=12 ctermbg=7

autocmd FileType java setlocal omnifunc=javacomplete#Complete

" vimspector
let g:vimspector_base_dir=expand( '$HOME/.local/share/vim/plugin-data/vimspector' )

function! g:Vimspector_toggle_active()
    if exists('g:vimspector_session_windows')
                \ && exists('g:vimspector_session_windows["mode"]')    " if vimspector is on
        call vimspector#Reset()
    else
        call vimspector#Launch()
    endif
endfunction

" compatibility with vim-latexsuite
set grepprg=grep\ -nH\ $*
let g:tex_flavor = "latex"

" vimwiki setup
let g:vimwiki_list = [{'path': '~/Documents/notes/vimwiki'}]

" vim-vmath keybindings
vmap <expr>  ++  VMATH_YankAndAnalyse()
nmap         ++  vip++

" dragvisuals plugin key bindings
vmap  <expr>  <LEFT>   DVB_Drag('left')
vmap  <expr>  <RIGHT>  DVB_Drag('right')
vmap  <expr>  <DOWN>   DVB_Drag('down')
vmap  <expr>  <UP>     DVB_Drag('up')
vmap  <expr>  D        DVB_Duplicate()

" FZF
let g:fzf_preview_window = ['up:40%:hidden', 'ctrl-/']
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}), <bang>0)

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
    \         [ 'gutentags', 'fileformat', 'fileencoding', 'filetype' ]
    \     ]
    \ },
    \ 'component_function': {
    \     'gitbranch': 'FugitiveHead',
    \     'cocstatus': 'coc#status',
    \     'gutentags': 'gutentags#statusline'
    \ },
    \ 'component': {
    \     'charvaluehex': '0x%B'
    \ }
\ }

" " Add status line support, for integration with other plugin, checkout `:h coc-status`
if exists('g:did_coc_loaded') && g:did_coc_loaded == 1
    set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
endif

" run :GoBuild or :GoTestCompile based on the go file
function! s:Build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

let g:go_auto_type_info = 1
let g:go_list_type = "quickfix"

"" Use `:Format` to format current buffer
" command! -nargs=0 Format :call CocAction('format')

"" Use `:Fold` to fold current buffer
"command! -nargs=? Fold :call     CocAction('fold', <f-args>)

"" use `:OR` for organize import of current buffer
"command! -nargs=0 OR   :call     CocAction('runCommand',
" 'editor.action.organizeImport')

