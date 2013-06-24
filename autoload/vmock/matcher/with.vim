" AUTHOR: kanno <akapanna@gmail.com>
" License: This file is placed in the public domain.
let s:save_cpo = &cpo
set cpo&vim

" TODO make_fail_messageは型の網羅テストしたほうがいい

function! vmock#matcher#with#any()
  let m = s:prototype()
  function! m.match(...)
    return 1 ==# 1
  endfunction
  return m
endfunction

function! vmock#matcher#with#eq(expected)
  let m = s:build_eq_matcher(a:expected, 's:op_equals')
  let m.__fail_format = 'The args[%d] expected: %s. but received: %s.'
  return m
endfunction

function! vmock#matcher#with#not_eq(expected)
  let m = s:build_eq_matcher(a:expected, 's:op_not_equals')
  let m.__fail_format = 'The args[%d] expected not equal(==#) %s. but received: %s.'
  return m
endfunction

function! vmock#matcher#with#loose_eq(expected)
  let m = s:build_eq_matcher(a:expected, 's:op_loose_equals')
  let m.__fail_format = 'The args[%d] expected: %s. but received: %s.'
  return m
endfunction

function! vmock#matcher#with#loose_not_eq(expected)
  let m = s:build_eq_matcher(a:expected, 's:op_loose_not_equals')
  let m.__fail_format = 'The args[%d] expected not equal(==) %s. but received: %s.'
  return m
endfunction

function! vmock#matcher#with#type(type_value)
  let m = s:build_eq_matcher(a:type_value, 's:equals_type')
  function! m.make_fail_message(args_index, actual)
    return printf('The args[%d] expected: %s. but received: %s.',
          \ a:args_index, s:get_type_string(self.__expected), s:get_type_string(a:actual))
  endfunction
  return m
endfunction

" TODO ここは網羅テスト必要かな
function! s:get_type_string(val)
  let subject = type(a:val)
  if type('') ==# subject
    return 'type("")'
  elseif type(0) ==# subject
    return 'type(0)'
  elseif type([]) ==# subject
    return 'type([])'
  elseif type({}) ==# subject
    return 'type({})'
  elseif type(function('tr')) ==# subject
    return 'type(function("tr"))'
  else
    return 'unknown'
  endif
endfunction

" TODO UATない
function! vmock#matcher#with#not_type(type_value)
  return s:build_eq_matcher(a:type_value, 's:not_equals_type')
endfunction

" TODO UATない
function! vmock#matcher#with#has(key)
  return s:build_eq_matcher(a:key, 's:op_has')
endfunction

" TODO UATない
function! vmock#matcher#with#custom(eq_op_name)
  let m = s:prototype()
  let m.__eq_op_name = a:eq_op_name
  function! m.match(actual)
    return call(self.__eq_op_name, [a:actual])
  endfunction
  return m
endfunction

function! s:prototype()
  let m = {'__fail_format': ''}

  function! m.make_fail_message(args_index, actual)
    if empty(self.__fail_format)
      return ''
    endif
    return printf(self.__fail_format, a:args_index, string(self.__expected), string(a:actual))
  endfunction

  return m
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

function! s:not_equals_type(a, b)
  return !s:equals_type(a:a, a:b)
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

function! s:op_has(key, args)
  if type({}) ==# type(a:args)
    return has_key(a:args, a:key)
  elseif type([]) ==# type(a:args)
    return index(a:args, a:key) !=# -1
  endif
  return 0
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
