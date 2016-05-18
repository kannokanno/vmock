scriptencoding utf-8
" AUTHOR: kanno <akapanna@gmail.com>
" License: This file is placed in the public domain.
let s:save_cpo = &cpo
set cpo&vim

let s:expects = {}

function! vmock#mock#new()
  " __original_defines = {モック対象の関数名: 元の関数定義}
  let mock = {'__original_defines': {}}

  " TODO これ自体がmock#new(func)になるべきじゃないのか
        " そうなるとmock#new()の戻り値がexpectなのは変なので修正しないとダメ
  " TODO 構造および処理フローが複雑
  " ---
  " <funcname>のモックを作成します。
  " この処理で対象の関数を再定義していることに注意してください。
  "
  " スクリプトローカルな関数はサポートしていないので、指定されると例外を発生します。
  "
  " @funcname モック対象の関数名
  "
  " Return
  "   モックオブジェクト(vmock#expect#new)
  " ---
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

  " ---
  " モック化されていた関数を元々の定義に戻します。
  "
  " Return なし
  " ---
  function! mock.teardown()
    for define in values(self.__original_defines)
      call s:remembar_define(define)
    endfor
  endfunction

  return mock
endfunction

" ---
" モック対象の関数が呼び出される時にフックする処理です。
" 呼び出し回数の記録と、渡された引数を記録します。
" この時点では検証を行いません。
"
" この関数が呼ばれたにも関わらず、対象の関数がモック化されていない場合には例外が発生します。
" 通常では起こり得ない状態です。
"
" @funcname 呼び出された関数名
" @args 渡された引数の配列([arg1, arg2])
"       何も引数がなければ空配列([])
"
" Return
"   必ず1を返します。
" ---
function! vmock#mock#called(funcname, args)
  if !has_key(s:expects, a:funcname)
    call vmock#exception#throw(printf('The mock(%s) is not registered.', a:funcname))
  endif
  let expect = s:expects[a:funcname]
  call expect.get_counter().called()
  call expect.get_matcher().recording(a:args)
  return 1
endfunction

" ---
" モック対象の関数が呼び出される時にフックする処理です。
" 設定されている戻り値を返します。
"
" この関数が呼ばれたにも関わらず、対象の関数がモック化されていない場合には例外が発生します。
" 通常では起こり得ない状態です。
"
" @funcname 呼び出された関数名
"
" Return
"   ユーザー側にて指定したモックの戻り値
" ---
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
