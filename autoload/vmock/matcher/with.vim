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

function! vmock#matcher#with#eq(expected)
  return s:build_eq_matcher(a:expected, 's:op_equals')
endfunction

function! vmock#matcher#with#not_eq(expected)
  return s:build_eq_matcher(a:expected, 's:op_not_equals')
endfunction

function! vmock#matcher#with#loose_eq(expected)
  return s:build_eq_matcher(a:expected, 's:op_loose_equals')
endfunction

function! vmock#matcher#with#loose_not_eq(expected)
  return s:build_eq_matcher(a:expected, 's:op_loose_not_equals')
endfunction

function! s:prototype()
  let matcher = {}
  function! matcher.result()
    " TODO
    return 0
  endfunction
  return matcher
endfunction

function! s:build_eq_matcher(expected, eq_op_name)
  let m = s:prototype()
  let m.__expected = a:expected
  let m.__eq_op_name = a:eq_op_name
  function! m.match(actual)
    return call(self.__eq_op_name, [self.__expected, a:actual])
  endfunction
  return m
endfunction

function! s:equals_type(a, b)
  return type(a:a) ==# type(a:b)
endfunction

function! s:equals(expected, actual, eq_op)
  return s:equals_type(a:expected, a:actual) && a:eq_op(a:expected, a:actual)
endfunction

function! s:op_equals(a, b)
  return s:equals_type(a:a, a:b) && a:a ==# a:b
endfunction

function! s:op_not_equals(a, b)
  return !s:op_equals(a:a, a:b)
endfunction

function! s:op_loose_equals(a, b)
  return s:equals_type(a:a, a:b) && a:a ==? a:b
endfunction

function! s:op_loose_not_equals(a, b)
  return !s:op_loose_equals(a:a, a:b)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
