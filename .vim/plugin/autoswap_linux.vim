"" Vim global plugin for automating response to swapfiles
"" Maintainer: Damian Conway
"" License: This file is placed in the public domain.
"
"" If already loaded, we're done...
"if exists("loaded_autoswap_linux")
"	finish
"endif
"let loaded_autoswap_linux = 1
"
"" Preserve external compatibility options, then enable full vim compatibility...
"let s:save_cpo = &cpo
"set cpo&vim
"
"" Invoke the behaviour whenever a swapfile is detected...
""
"augroup AutoSwap_Linux
"	autocmd!
"	autocmd SwapExists * call AS_M_HandleSwapfile(expand('<afile>:p'))
"augroup END
"
"
"" The automatic behaviour...
""
"function! AS_M_HandleSwapfile (filename)
"
"	" Is file already open in another Vim session in some other Terminal window???
"	let active_window = AS_M_DetectActiveWindow(a:filename)
"
"	" If so, go there instead and terminate this attempt to open the file...
"	if (strlen(active_window) > 0)
"		call AS_M_DelayedMsg('Switched to existing session in another window')
"		call AS_M_SwitchToActiveWindow(a:filename)
"		let v:swapchoice = 'q'
"
"		" Otherwise, if swapfile is older than file itself, just get rid of it...
"	elseif getftime(v:swapname) < getftime(a:filename)
"		call AS_M_DelayedMsg("Old swapfile detected...and deleted")
"		call delete(v:swapname)
"		let v:swapchoice = 'e'
"
"		" Otherwise, open file read-only...
"	else
"		call AS_M_DelayedMsg("Swapfile detected...opening read-only")
"		let v:swapchoice = 'o'
"	endif
"endfunction
"
"
"" Print a message after the autocommand completes
"" (so you can see it, but don't have to hit <ENTER> to continue)...
""
"function! AS_M_DelayedMsg (msg)
"	" A sneaky way of injecting a message when swapping into the new buffer...
"	augroup AutoSwap_Linux_Msg
"		autocmd!
"		" Print the message on finally entering the buffer...
"		autocmd BufWinEnter * echohl WarningMsg
"		exec 'autocmd BufWinEnter * echon "\r'.printf("%-60s", a:msg).'"'
"		autocmd BufWinEnter * echohl NONE
"
"		" And then remove these autocmds, so it's a "one-shot" deal...
"		autocmd BufWinEnter * augroup AutoSwap_Linux_Msg
"		autocmd BufWinEnter * autocmd!
"		autocmd BufWinEnter * augroup END
"	augroup END
"endfunction
"
"
""#################################################################
""## ##
""## Rewrite the following two functions to port this plugin ##
""## to other operating systems. ##
""## ##
""#################################################################
"
"" Return an identifier for a terminal window already editing the named file
"" (Should either return a string identifying the active window,
"" or else return an empty string to indicate "no active window")...
""
"function! AS_M_DetectActiveWindow (filename)
"	let shortname = fnamemodify(a:filename,":t")
"	let active_window = system('xdotool search --name "'.shortname.'"')
"	return active_window
"endfunction
"
"
"" Switch to terminal window specified...
""
"function! AS_M_SwitchToActiveWindow (filename)
"	let shortname = fnamemodify(a:filename, ":t")
"	call system('xdotool search --name "'.shortname.'" windowactivate')
"endfunction
"
"
"" Restore previous external compatibility options
"let &cpo = s:save_cpo
