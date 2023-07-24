colorscheme hypsteria

set nocompatible
set showcmd                             " Show partial command in status line and selected characters/lines in visual mode
set showmatch                           " Show matching brackets.
set ignorecase                          " Ignore case when matching
set smartcase                           " Do smart case matching
set incsearch                           " Incremental search
set autowrite                           " Automatically save before commands like :next and :make
set mouse=a                             " Enable mouse usage (all modes)
set number                              " display line numbers on left
set relativenumber                      " display relative numbers
set hlsearch                            " highlighting of search term
set autoindent
set scrolloff=5                         " show 5 lines above or below cursor position
set backspace=indent,eol,start          " allow backspace across lines and automatic indentation
set expandtab                           " expand tabs to spaces
set shiftwidth=4                        " number of spaces to use for autoindenting
set smarttab                            " insert tabs on the start of a line according to shiftwidth, not tabstop
set shiftround                          " use multiple of shiftwidth when indenting with '<' and '>'
set tabstop=4                           " tabs have a width of 4 chars
set splitright                          " new window opens on right instead of left
set splitbelow                          " new window opens on bottom instead of top
set wildmenu                            " show menu when using tab completion
set wildmode=list:longest,full          " list matches and complete longest common part, then cycle through matches
set wildignore=*.pyc,*.o,*.obj,*.swp
set pastetoggle=<F2>                    " disable paste-unfriendly features when pasting in insert mode
set ttimeoutlen=60                      " Fast escape out of insert mode
set path+=**                            " search down into subfolders, provides tab completion for all related tasks
set encoding=utf-8                      " welcome to the 21st century
set lazyredraw                          " faster macros
set nomodeline                          " disable modelines (security)
set shortmess+=aI                       " avoid 'hit enter', no welcome message
set ttyfast                             " fast internet connection
set autoread                            " automatically reread modified files, this turns out to be BS but I'm leaving it anyways
set title                               " change the terminal's title
set list
set listchars=tab:>.,trail:.,extends:#,nbsp:. " show trailing tabs and spaces
set secure                              " autocmd commands not allowed in vimrc/exrc in current directory

" https://old.reddit.com/r/vim/comments/cn20tv/tip_histogrambased_diffs_using_modern_vim/
" https://github.com/agude/dotfiles/issues/2#issuecomment-843639956
if (has('patch-8.1.0360') && (!has('mac') || $VIM != '/usr/share/vim')) || has('nvim-0.3.2')
    set diffopt+=filler,internal,algorithm:histogram,indent-heuristic   " make diff actually usable
endif

if $TMUX == ''
  set clipboard+=unnamed
endif

" nvim uses viminfo as a backwards-incompatible alias, so don't muck with it
" and let it do its thing
if ! has('nvim')
    set viminfo+=n~/.local/share/vim/viminfo " store viminfo somewhere sensible
endif

if has("persistent_undo")
    set undodir=~/.local/share/vim/undos    " set persistent undo dir
    set undofile                            " activate persistent undo
endif

if has('cmdline_info')
    " a ruler
    set ruler
    " a ruler on steroids
    set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%)
endif

if has('statusline')
    " always show a status line
    set laststatus=2
    " a statusline, also on steroids
    " set statusline=%<%f\ %=\:\b%n\[%{strlen(&ft)?&ft:'none'}/%{&encoding}/%{&fileformat}]%m%r%w\ %l,%c%V\ %P
endif

" highlight the 81st column when we go past it
call matchadd('ColorColumn', '\%81v', 100)
