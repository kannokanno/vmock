let s:suite = themis#suite('vmock#mock')
let s:assert = themis#helper('assert')

function! s:suite.before_each()
  function! VMockGlobalFunc()
    return 10
  endfunction

  function! VMockGlobalFuncWith(arg)
    return a:arg + 10
  endfunction
endfunction

function! s:suite.after_each()
  delfunction VMockGlobalFunc
  delfunction VMockGlobalFuncWith
endfunction

" グローバル関数でなければmock化できない
function! s:suite.exception_when_not_global_func()
  try
    let mock = vmock#mock#new()
    call mock.func('s:vmock_script_func')

    " 到達したら失敗の証
    call s:assert.true(0)
  catch
    call s:assert.equals(v:exception, 'VMock:There is the necessity for a global function.')
  endtry
endfunction

" mock化すると元の関数定義を内部に保持する
function! s:suite.add_original_defines()
  let mock = vmock#mock#new()
  call s:assert.equals(len(mock.__original_defines), 0)
  call mock.func('VMockGlobalFunc')
  call s:assert.equals(len(mock.__original_defines), 1)

  let expected = deepcopy(mock.__original_defines)
  " 同じ関数に対しては重複登録しない
  call mock.func('VMockGlobalFunc')
  call s:assert.equals(len(mock.__original_defines), 1)
  call s:assert.equals(expected, mock.__original_defines)
endfunction

" 何もmock化してなければ何も起きない
function! s:suite.nothing_when_original_define_is_empty()
  let mock = vmock#mock#new()
  call mock.teardown()
endfunction

" teardown後には元の関数定義に戻す
function! s:suite.remembar_original_define()
  call s:assert.equals(10, VMockGlobalFunc()) " mock前の呼び出しを確認
  let mock = vmock#mock#new()
  call mock.func('VMockGlobalFunc')
  call s:assert.equals(0, VMockGlobalFunc()) " mock後のデフォルト値
  call mock.teardown()
  call s:assert.equals(10, VMockGlobalFunc()) " 元に戻っている
endfunction

" 定義したreturn値を返す
function! s:suite.get_expect_return_value()
  let expected = 'StubReturn'
  call vmock#mock#new().func('VMockGlobalFunc').return(expected)
  call s:assert.equals(expected, vmock#mock#return('VMockGlobalFunc'))
endfunction

" 指定した関数がglobalじゃないか存在しなければエラー
function! s:suite.exception_when_not_exists_function()
  try
    call vmock#mock#return('VmockNotExistsFunc')

    " 到達したら失敗の証
    call s:assert.true(0)
  catch
    call s:assert.equals(v:exception, 'VMock:The mock(VmockNotExistsFunc) is not registered.')
  endtry
endfunction

" TODO 今のところ疎通テスト(動かしてエラーが起きない確認)のみ
function! s:suite.called_is_success()
  call vmock#mock#new().func('VMockGlobalFuncWith').with(20).return(10)
  call s:assert.equals(1, vmock#mock#called('VMockGlobalFuncWith', [20]))
endfunction

function! s:suite.exception_when_not_exists_function()
  try
    call vmock#mock#called('VmockNotExistsFunc', [])

    " 到達したら失敗の証
    call s:assert.true(0)
  catch
    call s:assert.equals(v:exception, 'VMock:The mock(VmockNotExistsFunc) is not registered.')
  endtry
endfunction
