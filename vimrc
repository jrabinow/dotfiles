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
endif

" Vim jumps to the last position when reopening a file
if has("autocmd")
	au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Vim loads indentation rules and plugins according to the detected filetype.
if has("autocmd")
	filetype plugin indent on
endif

" Use more natural key movement on wrapped lines.
nnoremap j gj
nnoremap k gk
nnoremap gj 5j
nnoremap gk 5k

" Keep selection when indent/dedenting in select mode.
vnoremap > >gv
vnoremap < <gv

" Center screen on next match
nnoremap n nzz
nnoremap N Nzz

" Make Y copy to end of line instead of be an alias for yy
nnoremap Y y$

" Who uses ';' anyways?
nnoremap ; :

set showcmd				" Show (partial) command in status line.
set showmatch				" Show matching brackets.
set ignorecase				" Ignore case when matching
set smartcase				" Do smart case matching
set incsearch				" Incremental search
set autowrite				" Automatically save before commands like :next and :make
set mouse=a				" Enable mouse usage (all modes)
set number				" display line numbers on left
set hlsearch				" highlighting of search term
set autoindent
set scrolloff=5				" show 5 lines above or below cursor position
set backspace=indent,eol,start		" allow backspace across lines and automatic indentation
set noexpandtab				" DONT REPLACE MY TABS BY FUCKING SPACES DAMMIT!!!
set splitright				" new window opens on right instead of left
set laststatus=2			" show status file even if for one file
set wildmenu				" show sexy menu when using tab completion
set pastetoggle=<F2>			" disable paste-unfriendly features when pasting in insert mode
set ttimeoutlen=60			" Fast escape out of insert mode


" highlight cursorline and cursorcolumn
highlight CursorLine   cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
highlight CursorColumn cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white

" \c will toggle highlighting on and off (to make it easy to locate the cursor in a large file)
nnoremap <Leader>c :set cursorline! cursorcolumn!<CR>

" compatibility with vim-latexsuite
set grepprg=grep\ -nH\ $*
let g:tex_flavor = "latex"

" highlight the 81st column when we go past it
highlight ColorColumn ctermbg=green
call matchadd('ColorColumn', '\%81v', 100)

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

noremap <silent>sw :call SelectWindowSwap()<CR>
noremap <silent>mw :call MoveWindowSwap()<CR>

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
	let oldhlsearch=ShowSpaces(1)
	execute a:firstline.",".a:lastline."substitute ///gec"
	let &hlsearch=oldhlsearch
endfunction

command! -bar -nargs=0 -range=% TrimSpaces <line1>,<line2>call TrimSpaces()

augroup pencil
  autocmd!
  autocmd FileType markdown,mkd call pencil#init()
  autocmd FileType text         call pencil#init()
augroup END
