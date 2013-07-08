" AUTHOR: kanno <akapanna@gmail.com>
" License: This file is placed in the public domain.
let s:save_cpo = &cpo
set cpo&vim

let s:expects = {}

function! vmock#mock#new()
  let mock = {'__original_defines': {}}

  " TODO これ自体がmock#new(func)になるべきじゃないのか
        " そうなるとmock#new()の戻り値がexpectなのは変なので修正しないとダメ
  function! mock.func(funcname)
    if stridx(a:funcname, 's:') ==# 0
      call vmock#exception#throw('There is the necessity for a global function.')
    endif

    let original_define = vmock#function_define#get(a:funcname)
    if !has_key(self.__original_defines, a:funcname)
      let self.__original_defines[a:funcname] = original_define
    endif

    call vmock#function_define#override_mock(original_define)
    let expect = vmock#expect#new(a:funcname)
    let self.__expect = expect

    let s:expects[a:funcname] = expect
    return expect
  endfunction

  function! mock.verify()
    return self.__expect.verify()
  endfunction

  function! mock.teardown()
    for define in values(self.__original_defines)
      call s:remembar_define(define)
    endfor
  endfunction

  return mock
endfunction

" @args 引数の配列。([] | [arg1, arg2 ...])
function! vmock#mock#called(funcname, args)
  if !has_key(s:expects, a:funcname)
    call vmock#exception#throw(printf('The mock(%s) is not registered.', a:funcname))
  endif
  let expect = s:expects[a:funcname]
  call expect.get_counter().called()
  call expect.get_matcher().record(a:args)
  return 1
endfunction

function! vmock#mock#return(funcname)
  if !has_key(s:expects, a:funcname)
    call vmock#exception#throw(printf('The mock(%s) is not registered.', a:funcname))
  endif
  let expect = s:expects[a:funcname]
  return expect.get_return_value()
endfunction

function! s:remembar_define(original_define)
  if exists('*' . a:original_define.funcname)
    call vmock#function_define#override(a:original_define.funcname, a:original_define.arg_names, a:original_define.body)
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
