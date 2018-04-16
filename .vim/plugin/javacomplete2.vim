autocmd FileType java setlocal omnifunc=javacomplete#Complete

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
