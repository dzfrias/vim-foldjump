" =============================================================================
" File: plugin/foldjump.vim
" Description: Jump between folds intuitively
" Author: Diego Frias <github.com/dzfrias>
" =============================================================================

if exists('g:loaded_foldjump') || &compatible
  finish
endif

let g:loaded_foldjump = 1

if !exists('g:foldjump_map_keys')
  let g:foldjump_map_keys = 1
endif

function! s:UpUntilFold(lnum) abort
  if a:lnum ==? 1
    return 1
  endif
  let foldlev = foldlevel(a:lnum)
  if foldlev > 0 && foldlevel(a:lnum - 1) < foldlev
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

function! s:FoldJumpUp() abort
  if foldlevel(line('.')) !=? foldlevel(line('.') - 1)
    normal! k
    execute 'normal! ' . s:UpUntilFold(line('.')) . 'gg'
  endif

  let lnum = line('.')
  let baselinefold = foldlevel(lnum)

  let jumpline = s:FoldUpInBlock(lnum, baselinefold)

  execute 'normal! ' . jumpline . 'gg'
endfunction

nnoremap <silent> <Plug>FoldJumpUp :<C-u> silent call <SID>FoldJumpUp()<CR>

if g:foldjump_map_keys
  noremap <s-k> <Plug>FoldJumpUp
endif
