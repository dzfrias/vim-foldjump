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

" FoldUpInBlock returns the top of a block whose foldlevel is greater than 0.
function! s:FoldUpInBlock(lnum, baselinefold) abort
  let lnum = a:lnum

  while foldlevel(lnum) ==? a:baselinefold
    if lnum ==? 1
      return a:lnum
    endif
    let lnum -= 1
  endwhile

  return lnum + 1
endfunction

" FoldJumpUp jumps the cursor to the nearest fold that is at the top of a
" block whose foldlevel is greater than 0.
function! s:FoldJumpUp() abort
  let lnum = line('.')
  if foldclosed(lnum) !=? -1
    let lnum = foldclosed(lnum)
  endif

  while foldlevel(lnum) >=? foldlevel(lnum - 1)
    if lnum ==? 1
      return
    endif
    let lnum -= 1
  endwhile
  let lnum -= 1

  let baselinefold = foldlevel(lnum)

  let jumpline = s:FoldUpInBlock(lnum, baselinefold)
  execute jumpline
endfunction

" FoldJumpGo uses FoldJumpUp but repeats it the number the times the user
" specifies in a number prefix.
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

nnoremap <Plug>FoldJumpUp <Cmd>call <SID>FoldJumpGo()<CR>

if g:foldjump_map_keys
  noremap <s-k> <Plug>FoldJumpUp
endif
