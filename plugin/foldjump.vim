function! s:UpUntilFold(lnum) abort
    if foldlevel(a:lnum) !=? 0
        return a:lnum
    endif

    return s:UpUntilFold(a:lnum - 1)
endfunction

function! s:FoldUpInBlock(lnum, baselinefold) abort
    if a:lnum ==? 1
        return 1
    endif
    if foldlevel(a:lnum) !=? a:baselinefold
        return a:lnum + 1
    endif

    return s:FoldUpInBlock(a:lnum - 1, a:baselinefold)
endfunction

function! FoldJumpUp() abort
    if foldlevel(line('.')) !=? foldlevel(line('.') - 1)
        normal! k
        execute "normal! " . s:UpUntilFold(line('.')) . "gg"
    endif

    let line = line('.')
    let baselinefold = foldlevel(line)

    let jumpline = s:FoldUpInBlock(line, baselinefold)

    execute "normal! " . jumpline . "gg"
endfunction

nnoremap <silent> <s-k> :call FoldJumpUp()<CR>
