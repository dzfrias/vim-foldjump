function! s:PrevFoldLine(lnum)
    if foldlevel(a:lnum) ==? 0 then
        return a:lnum
    else
        return s:PrevFoldLine(a:lnum - 1)
    endif
endfunction

function! FoldJumpUp()
    let l:jumpline = s:PrevFoldLine(v:lnum)
    execute "normal! " . l:jumpline . "gg"
endfunction
