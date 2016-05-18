scriptencoding utf-8
" AUTHOR: kanno <akapanna@gmail.com>
" License: This file is placed in the public domain.
let s:save_cpo = &cpo
set cpo&vim

" 各matcherの詳細はヘルプを参照してください。

function! vmock#matcher#with#any()
  let m = s:make_prototype()
  function! m.match(...)
    return 1 ==# 1
  endfunction
  return m
endfunction

function! vmock#matcher#with#eq(expected)
  let m = s:make_eq_matcher(a:expected, 's:op_equals')
  let m.__fail_msg_format = 'The args[%d] expected: %s. but received: %s.'
  return m
endfunction

function! vmock#matcher#with#not_eq(expected)
  let m = s:make_eq_matcher(a:expected, 's:op_not_equals')
  let m.__fail_msg_format = 'The args[%d] expected: not equal(==#) %s. but received: %s.'
  return m
endfunction

function! vmock#matcher#with#loose_eq(expected)
  let m = s:make_eq_matcher(a:expected, 's:op_loose_equals')
  let m.__fail_msg_format = 'The args[%d] expected: %s. but received: %s.'
  return m
endfunction

function! vmock#matcher#with#loose_not_eq(expected)
  let m = s:make_eq_matcher(a:expected, 's:op_loose_not_equals')
  let m.__fail_msg_format = 'The args[%d] expected: not equal(==) %s. but received: %s.'
  return m
endfunction

function! vmock#matcher#with#type(type_value)
  let m = s:make_eq_matcher(a:type_value, 's:op_equals_type')
  function! m.make_fail_message(args_index, actual)
    return printf('The args[%d] expected: %s. but received: %s.',
          \ a:args_index, s:get_type_string(self.__expected), s:get_type_string(a:actual))
  endfunction
  return m
endfunction

function! vmock#matcher#with#not_type(type_value)
  let m = s:make_eq_matcher(a:type_value, 's:op_not_equals_type')
  function! m.make_fail_message(args_index, actual)
    return printf('The args[%d] expected: except %s. but received: %s.',
          \ a:args_index, s:get_type_string(self.__expected), s:get_type_string(a:actual))
  endfunction
  return m
endfunction

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
  elseif type(0.0) ==# subject
    return 'type(0.0)'
  else
    return 'unknown'
  endif
endfunction

function! vmock#matcher#with#has(key)
  let m = s:make_eq_matcher(a:key, 's:op_has')
  function! m.make_fail_message(args_index, actual)
    return printf('The args[%d] expected: has(%s). but not found.',
          \ a:args_index, string(self.__expected))
  endfunction
  return m
endfunction

function! vmock#matcher#with#not_has(key)
  let m = s:make_eq_matcher(a:key, 's:op_not_has')
  function! m.make_fail_message(args_index, actual)
    return printf('The args[%d] expected: has not(%s). but found.',
          \ a:args_index, string(self.__expected))
  endfunction
  return m
endfunction

function! vmock#matcher#with#custom(eq_op_name)
  let m = s:make_prototype()
  let m.__eq_op_name = a:eq_op_name

  function! m.match(actual)
    return call(self.__eq_op_name, [a:actual])
  endfunction

  function! m.make_fail_message(args_index, actual)
    return printf('Failed custom matcher. The args[%d] match function: %s, args: %s',
          \ a:args_index, self.__eq_op_name, string(a:actual))
  endfunction
  return m
endfunction

function! s:make_eq_matcher(expected, eq_op_name)
  let m = s:make_prototype()
  let m.__expected = a:expected
  let m.__eq_op_name = a:eq_op_name

  function! m.match(actual)
    return call(self.__eq_op_name, [self.__expected, a:actual])
  endfunction

  return m
endfunction

function! s:make_prototype()
  let m = {'__fail_msg_format': ''}

  function! m.make_fail_message(args_index, actual)
    if empty(self.__fail_msg_format)
      return ''
    endif
    return printf(self.__fail_msg_format, a:args_index, string(self.__expected), string(a:actual))
  endfunction

  return m
endfunction

" 無名関数の代わり "{{{
function! s:op_equals_type(a, b)
  return type(a:a) ==# type(a:b)
endfunction

function! s:op_not_equals_type(a, b)
  return !s:op_equals_type(a:a, a:b)
endfunction

function! s:op_equals(a, b)
  return s:op_equals_type(a:a, a:b) && a:a ==# a:b
endfunction

function! s:op_not_equals(a, b)
  return !s:op_equals(a:a, a:b)
endfunction

function! s:op_loose_equals(a, b)
  return s:op_equals_type(a:a, a:b) && a:a ==? a:b
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

function! s:op_not_has(key, args)
  if type({}) ==# type(a:args)
    return !has_key(a:args, a:key)
  elseif type([]) ==# type(a:args)
    return index(a:args, a:key) ==# -1
  endif
  return 0
endfunction
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo
