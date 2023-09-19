function! StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction

command! -bar -nargs=0 -range=% TrimSpaces <line1>,<line2>call StripTrailingWhitespaces()

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

command! -nargs=0 Reload source ~/.vim/vimrc

" Multipurpose tab key
" Indent if we're at the beginning of a line. Else, do completion
" https://github.com/katzien/dotfiles/blob/master/.vimrc#L102
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction

" Rename current file
" https://github.com/katzien/dotfiles/blob/master/.vimrc#L123
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction
