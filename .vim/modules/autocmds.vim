if has("autocmd")
    " Vim loads indentation rules and plugins according to the detected filetype.
    filetype plugin indent on
    " Vim jumps to the last position when reopening a file
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
    " In some files, like HTML and XML files, tabs are fine and showing them is really annoying,
    autocmd filetype html,xml set listchars-=tab:>.

    " kill any trailing whitespace on save
    autocmd FileType c,cabal,cpp,haskell,javascript,php,python,readme,text
        \ autocmd BufWritePre <buffer>
        \ :call StripTrailingWhitespaces()

    " read various filetypes in vim
    " https://www.reddit.com/r/vim/comments/48zclk/i_just_found_a_simple_method_to_read_pdf_doc_odt/
    autocmd BufReadPost *.doc,*.docx,*.rtf,*.odp,*.odt silent %!pandoc "%" -tplain -o /dev/stdout
endif
