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
    execute s:UpUntilFold(line('.'))
  endif

  let lnum = line('.')
  let baselinefold = foldlevel(lnum)

  let jumpline = s:FoldUpInBlock(lnum, baselinefold)
  execute jumpline
endfunction

function! s:FoldJumpGo() abort
  let repeat = v:count
  if repeat ==? 0
    let repeat = 1
  endif

  while repeat > 0
    call s:FoldJumpUp()
    let repeat -= 1
  endwhile
endfunction

nnoremap <silent> <Plug>FoldJumpUp :<C-u> call <SID>FoldJumpGo()<CR>

if g:foldjump_map_keys
  noremap <s-k> <Plug>FoldJumpUp
endif
