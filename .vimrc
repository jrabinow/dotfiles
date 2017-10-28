" Source a global configuration file if available… How about no
"if filereadable("/etc/vim/vimrc.local")
"	source /etc/vim/vimrc.local
"endif

" ensures compatibility with ViM-related packages in Debian
runtime! debian.vim

set nocompatible

" For Vim5 and later
syntax on
colorscheme koehler

" Remove toolbar from gvim
if has('gui_running')
	set guioptions=-t
	set cursorline
	map <silent><A-t> :tabnew<CR>
	map <silent><A-Right> :tabnext<CR>
	map <silent><A-Left> :tabprevious<CR>
endif

if has("autocmd")
" Vim loads indentation rules and plugins according to the detected filetype.
	filetype plugin indent on
" Vim jumps to the last position when reopening a file
	au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

if has('cmdline_info')
    " a ruler
    set ruler
    " a ruler on steroids
    set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%)
    " show partial commands in status line and selected characters/lines in
    " visual mode
    set showcmd
endif
if has('statusline')
    " always show a status line
    set laststatus=2
    " a statusline, also on steroids
    set statusline=%<%f\ %=\:\b%n\[%{strlen(&ft)?&ft:'none'}/%{&encoding}/%{&fileformat}]%m%r%w\ %l,%c%V\ %P
endif

" Undolist tree, graphical (requires gundo plugin)
nnoremap <F5> :GundoToggle<CR>
let g:gundo_width = 60
let g:gundo_preview_height = 40
let g:gundo_right = 0


" File browsing:
let g:netrw_banner=0
let g:netrw_browse_split=4
let g:netrw_altv=1
let g:netrw_liststyle=3
"let g:netrw_list_hide=netrw_gitignore#Hide()
"let g:netrw_list_hide.=',\(^\|\s\s)\zs\.\S\+'

" highlight cursorline and cursorcolumn
highlight CursorLine   cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
highlight CursorColumn cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white

" \c will toggle highlighting on and off (to make it easy to locate the cursor in a large file)
nnoremap <Leader>c :set cursorline! cursorcolumn!<CR>

" compatibility with vim-latexsuite
set grepprg=grep\ -nH\ $*
let g:tex_flavor = "latex"

" Create the 'tags' file
command! MakeTags !maketags

set showcmd								" Show (partial) command in status line.
set showmatch							" Show matching brackets.
set ignorecase							" Ignore case when matching
set smartcase							" Do smart case matching
set incsearch							" Incremental search
set autowrite							" Automatically save before commands like :next and :make
set mouse=a								" Enable mouse usage (all modes)
set number								" display line numbers on left
set hlsearch							" highlighting of search term
set autoindent
set scrolloff=5							" show 5 lines above or below cursor position
set backspace=indent,eol,start			" allow backspace across lines and automatic indentation
set noexpandtab							" expand tabs to spaces
set tabstop=4                           " tabs have a width of 4 chars
set splitright							" new window opens on right instead of left
set splitbelow                          " new window opens on bottom instead of top
set wildmenu							" show menu when using tab completion
set wildmode=list:longest,full          " list matches and complete longest common part, then cycle through matches
set wildignore=*.pyc,*.o,*.obj,*.swp
set pastetoggle=<F2>	                " disable paste-unfriendly features when pasting in insert mode
set ttimeoutlen=60						" Fast escape out of insert mode
set path+=**							" search down into subfolders, provides tab completion for all related tasks
set encoding=utf-8                      " welcome to the 21st century
set lazyredraw                          " faster macros
set nomodeline                          " disable modelines (security)
set shortmess+=a                        " avoid 'hit enter'
set ttyfast                             " fast internet connection
set autoread                            " automatically reread modified files, this turns out to be BS but I'm leaving it anyways


" Use more natural key movement on wrapped lines.
nnoremap j gj
nnoremap k gk
nnoremap gj 5j
nnoremap gk 5k

" Keep selection when indent/dedenting in select mode.
vnoremap > >gv
vnoremap < <gv

" Center screen on next match disabled because too much jumping around
"nnoremap n nzz
"nnoremap N Nzz

" Make Y copy to end of line instead of be an alias for yy
nnoremap Y y$

" Who uses ';' anyways?
nnoremap ; :

" Ctrl+\ : open ctag definition in new tab
map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
" Alt+] : open ctag definition in vertical split
map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

" highlight the 81st column when we go past it
"highlight ColorColumn ctermbg=green ctermfg=white
call matchadd('ColorColumn', '\%81v', 100)
"set colorcolumn=81,101 " absolute columns to highlight "
"set colorcolumn=+1,+21 " relative (to textwidth) columns to highlight "

" hlnext blink next match
"nnoremap <silent> n n:call HLNext(0.4)<cr>
"nnoremap <silent> N N:call HLNext(0.4)<cr>

function! HLNext (blinktime)
	let [bufnum, lnum, col, off] = getpos('.')
	let matchlen = strlen(matchstr(strpart(getline('.'),col-1),@/))
	let target_pat = '\c\%#'.@/
	let ring = matchadd('WhiteOnRed', target_pat, 101)
	redraw
	exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
	call matchdelete(ring)
	redraw
endfunction

vmap  <expr>  <LEFT>   DVB_Drag('left')
vmap  <expr>  <RIGHT>  DVB_Drag('right')
vmap  <expr>  <DOWN>   DVB_Drag('down')
vmap  <expr>  <UP>     DVB_Drag('up')
vmap  <expr>  D        DVB_Duplicate()

" Swap 2 panes with 4 keystrokes
" 'sw' to select 1st pane
" move to new pane
" 'mw' to exchange selected pane with current pane
function! SelectWindowSwap()
	let g:markedWinNum = winnr()
endfunction

function! MoveWindowSwap()
	"Mark destination
	let curNum = winnr()
	let curBuf = bufnr( "%" )
	exe g:markedWinNum . "wincmd w"
	"Switch to source and shuffle dest->source
	let markedBuf = bufnr( "%" )
	"Hide and open so that we aren't prompted and keep history
	exe 'hide buf' curBuf
	"Switch to dest and shuffle source->dest
	exe curNum . "wincmd w"
	"Hide and open so that we aren't prompted and keep history
	exe 'hide buf' markedBuf
endfunction

noremap <leader>sw :call SelectWindowSwap()<CR>
noremap <leader>mw :call MoveWindowSwap()<CR>

function! ShowSpaces(...)
	let @/='\v(\s+$)|( +\ze\t)'
	let oldhlsearch=&hlsearch
	if !a:0
		let &hlsearch=!&hlsearch
	else
		let &hlsearch=a:1
	end
	return oldhlsearch
endfunction

function! TrimSpaces() range
	let oldhlsearch=ShowSpaces(0)
	execute a:firstline.",".a:lastline."substitute ///gec"
	let &hlsearch=oldhlsearch
endfunction

command! -bar -nargs=0 -range=% TrimSpaces <line1>,<line2>call TrimSpaces()

let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts=1

if $TMUX == ''
  set clipboard+=unnamed
endif

command! -nargs=0 FlappyVird call flappyvird#start()

" to please the Olde Gods
iabbrev cthuf Ia! Ia! Cthulhu fhtagn! Ph'nglui mglw'nafh Cthulhu R'lyeh wgah'nagl fhtagn! Cthulhu fhtagn! Cthulhu fhtagn!
