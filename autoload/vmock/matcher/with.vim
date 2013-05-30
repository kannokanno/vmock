" AUTHOR: kanno <akapanna@gmail.com>
" License: This file is placed in the public domain.
let s:save_cpo = &cpo
set cpo&vim

function! vmock#matcher#with#any()
  let m = s:prototype()
  function! m.match(...)
    return 1 ==# 1
  endfunction
  return m
endfunction

function! vmock#matcher#with#loose_eq(...)
  let m = s:prototype()
  let m.__expected_args = a:000
  function! m.match(...)
    let expected_size = len(self.__expected_args)
    if expected_size !=# len(a:000)
      return 0
    endif

    for i in range(expected_size)
      let expected = self.__expected_args[i]
      let actual = a:000[i]
      if s:not_equals_type(expected, actual) || expected !=? actual
        return 0
      endif
      unlet expected
      unlet actual
    endfor
    return 1
  endfunction
  return m
endfunction

function! s:prototype()
  let matcher = {}
  function! matcher.result()
    " TODO
    return 0
  endfunction
  return matcher
endfunction

function! s:equals_type(a, b)
  return type(a:a) ==# type(a:b)
endfunction

function! s:not_equals_type(a, b)
  return !s:equals_type(a:a, a:b)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
