" AUTHOR: kanno <akapanna@gmail.com>
" License: This file is placed in the public domain.
let s:save_cpo = &cpo
set cpo&vim

function! vmock#matcher#with#any()
  let obj = s:prototype()
  function! obj.match(...)
    return 1 " true
  endfunction
  return obj
endfunction

function! s:prototype()
  let obj = {}
  function! obj.result()
    " TODO
    return 0
  endfunction
  return obj
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
