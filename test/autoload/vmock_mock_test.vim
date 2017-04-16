let s:suite = themis#suite('vmock')
let s:assert = themis#helper('assert')

function! s:suite.before_each()
  " 毎回mock用のglobalの関数を定義する
  function! VMockGlobalFunc()
    return 10
  endfunction
endfunction

function! s:suite.after_each()
  delfunction VMockGlobalFunc
  call vmock#clear()
endfunction

" mockを作って何もしない -> success
function! s:suite.do_nothing()
  let mock = vmock#mock('VMockGlobalFunc')
  call s:assert.true(1)
endfunction

" 存在しない関数をmockにしようとするとexceptionを投げる
function! s:suite.exeception_when_not_exists_func()
  try
    call vmock#mock('VMockTestNotExistsFunc')

    " ここに到達したら失敗の証
    call s:assert.true(0)
  catch
    call s:assert.equals(v:exception, 'VMock:E123: Undefined function: VMockTestNotExistsFunc')
  endtry
endfunction

" mockを作成するとcontainerに追加される
function! s:suite.add_container_when_new_mock()
  call s:assert.equals(len(vmock#container#get_mocks()), 0)
  call vmock#mock('VMockGlobalFunc')
  call s:assert.equals(len(vmock#container#get_mocks()), 1)
endfunction

" 同名の関数の場合は追加ではなく上書きされる
function! s:suite.override_on_same_funcname()
  call s:assert.equals(len(vmock#container#get_mocks()), 0)
  call vmock#mock('VMockGlobalFunc')
  call s:assert.equals(len(vmock#container#get_mocks()), 1)
  call vmock#mock('VMockGlobalFunc')
  " TODO 上書きしたかどうかのテストができていない
  call s:assert.equals(len(vmock#container#get_mocks()), 1)
endfunction

" loadされていないautoloadでもmockに出来る
function! s:suite.success_by_unloaded_autoload_func()
  call s:assert.equals(len(vmock#container#get_mocks()), 0)
  call vmock#mock('vmock#for_test#autoload_testdata#func')
  call s:assert.equals(len(vmock#container#get_mocks()), 1)
endfunction

" loadされていないautoloadでもmockに出来る(引数定義ありの関数)
function! s:suite.success_by_unloaded_autoload_func_with_arg()
  call s:assert.equals(len(vmock#container#get_mocks()), 0)
  call vmock#mock('vmock#for_test#autoload_testdata#func_with_arg')
  call s:assert.equals(len(vmock#container#get_mocks()), 1)
endfunction
