" AUTHOR: kanno <akapanna@gmail.com>
" License: This file is placed in the public domain.
let s:save_cpo = &cpo
set cpo&vim

function! vmock#matcher#with#any()
  let m = s:prototype()
  function! m.match(...)
    return 1 ==# 1
  endfunction
  call m.update_status(1) " always success
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

function! vmock#matcher#with#type(type_value)
  return s:build_eq_matcher(a:type_value, 's:equals_type')
endfunction

function! vmock#matcher#with#not_type(type_value)
  return s:build_eq_matcher(a:type_value, 's:not_equals_type')
endfunction

function! vmock#matcher#with#has(key)
  return s:build_eq_matcher(a:key, 's:op_has')
endfunction

function! vmock#matcher#with#custom(eq_op_name)
  let m = s:prototype()
  let m.__eq_op_name = a:eq_op_name
  function! m.match(actual)
    return call(self.__eq_op_name, [a:actual])
  endfunction
  return m
endfunction

function! s:prototype()
  let matcher = {'__match_status': -1}
  function! matcher.result()
    return self.__match_status ==# -1 ? 0 : self.__match_status
  endfunction

  function! matcher.update_status(status)
    " 一度も失敗していない場合のみ更新する
    if self.__match_status !=# 0
      let self.__match_status = a:status
    endif
  endfunction
  return matcher
endfunction

function! s:build_eq_matcher(expected, eq_op_name)
  let m = s:prototype()
  let m.__expected = a:expected
  let m.__eq_op_name = a:eq_op_name
  function! m.match(actual)
    let result = call(self.__eq_op_name, [self.__expected, a:actual])
    call self.update_status(result)
    return result
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
