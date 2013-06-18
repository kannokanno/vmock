" AUTHOR: kanno <akapanna@gmail.com>
" License: This file is placed in the public domain.
let s:save_cpo = &cpo
set cpo&vim

function! vmock#result#make_success(expected, actual)
  return s:make_struct(a:expected, a:actual, 1, '')
endfunction

function! vmock#result#make_fail(expected, actual, message)
  return s:make_struct(a:expected, a:actual, 0, a:message)
endfunction

function! s:make_struct(expected, actual, is_success, message)
  return {'expected': a:expected,
        \ 'actual': a:actual,
        \ 'is_success': a:is_success,
        \ 'is_fail': a:is_success !=# 1,
        \ 'message': a:message
        \ }
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo


