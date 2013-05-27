" AUTHOR: kanno <akapanna@gmail.com>
" License: This file is placed in the public domain.
let s:save_cpo = &cpo
set cpo&vim

let s:expects = {}

function! vmock#mock#new()
  let mock = {}

  function! mock.function(funcname)
    " " オリジナルを記憶
    " let original_define = s:get_original_define(funcname)
    " call add(self.__original_defines, original_define)
    " " 関数定義を上書き
    " call s:override_mock_define(self.__original_define)
    let expect = vmock#expect#new(a:funcname)
    " call s:expects[funcname] = expect
    return expect
  endfunction

  function! mock.verify()
    " TODO 結果保持の仕様
    " for expect in self.__expects
    "   call expect.verify()
    " endfor
  endfunction

  function! mock.teardown()
    " for define in self.__original_defines
    "   call s:remembar_define(define)
    " endfor
  endfunction

  return mock
endfunction

function! vmock#mock#called(funcname, args)
  "let expect = s:expects[a:funcname]
  "call expect.get_counter().called()
  "call expect.get_matcher().match(a:args)
endfunction

function! s:override_mock_define(define)
  let body = printf("call vmock#mock#called('%s', [%s])\n%s", a:define.funcname, join(a:define.args, ','), a:define.body)
  execute printf("function! %s(%s)\n%s\nendfunction", a:define.funcname, a:define.args, body)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
