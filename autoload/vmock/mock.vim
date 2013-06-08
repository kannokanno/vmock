" AUTHOR: kanno <akapanna@gmail.com>
" License: This file is placed in the public domain.
let s:save_cpo = &cpo
set cpo&vim

let s:expects = {}

function! vmock#mock#new()
  let mock = {'__original_defines': {}}

  function! mock.function(funcname)
    let original_define = vmock#function_define#get(a:funcname)
    if !has_key(self.__original_defines, a:funcname)
      let self.__original_defines[a:funcname] = original_define
    endif

    call vmock#function_define#override_mock(original_define)
    let expect = vmock#expect#new(a:funcname)
    let s:expects[a:funcname] = expect
    return expect
  endfunction

  function! mock.verify()
    " TODO 結果保持の仕様
    " for expect in self.__expects
    "   call expect.verify()
    " endfor
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
  return expect.get_matcher().match(a:args)
endfunction

function! vmock#mock#return(funcname)
  if !has_key(s:expects, a:funcname)
    call vmock#exception#throw(printf('The mock(%s) is not registered.', a:funcname))
  endif
  let expect = s:expects[a:funcname]
  return expect.get_return_value()
endfunction

function! s:remembar_define(original_define)
  call vmock#function_define#override(a:original_define.funcname, a:original_define.arg_names, a:original_define.body)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
