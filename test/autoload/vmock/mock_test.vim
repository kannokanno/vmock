let s:t = vimtest#new('vmock#mock#new function()') "{{{

function! s:t.setup()
  function! g:vmock_global_func()
    return 10
  endfunction
endfunction

function! s:t.teardown()
  delfunction g:vmock_global_func
endfunction

function! s:t.exception_when_not_global_func()
  let mock = vmock#mock#new()
  call self.assert.throw('VMockException:There is the necessity for a global function.')
  call mock.func('s:vmock_script_func')
endfunction

function! s:t.add_original_defines()
  let mock = vmock#mock#new()
  call self.assert.equals(0, len(mock.__original_defines))
  call mock.func('g:vmock_global_func')
  call self.assert.equals(1, len(mock.__original_defines))

  let expected = deepcopy(mock.__original_defines)
  " 同じ関数に対しては重複登録しない
  call mock.func('g:vmock_global_func')
  call self.assert.equals(1, len(mock.__original_defines))
  call self.assert.equals(expected, mock.__original_defines)
endfunction

function! s:t.override_mock()
  let mock = vmock#mock#new()
  call self.assert.equals(10, g:vmock_global_func())
  call mock.func('g:vmock_global_func')
  " モック化したあとのreturnの初期値は0
  call self.assert.equals(0, g:vmock_global_func())
endfunction
"}}}
let s:t = vimtest#new('vmock#mock#new teardown()') "{{{

function! s:t.setup()
  function! g:vmock_global_func()
    return 10
  endfunction
endfunction

function! s:t.teardown()
  delfunction g:vmock_global_func
endfunction

function! s:t.nothing_when_original_define_is_empty()
  let mock = vmock#mock#new()
  call mock.teardown()
endfunction

function! s:t.remembar_original_define()
  call self.assert.equals(10, g:vmock_global_func())
  let mock = vmock#mock#new()
  call mock.func('g:vmock_global_func')
  " 再定義
  function! g:vmock_global_func()
    return 100
  endfunction
  call self.assert.equals(100, g:vmock_global_func())
  call mock.teardown()
  call self.assert.equals(10, g:vmock_global_func())
endfunction
"}}}
let s:t = vimtest#new('vmock#mock#return()') "{{{

function! s:t.setup()
  function! g:vmock_global_func()
    return 10
  endfunction
endfunction

function! s:t.teardown()
  delfunction g:vmock_global_func
endfunction

function! s:t.get_expect_return_value()
  let expected = 'StubReturn'
  call vmock#mock#new().func('g:vmock_global_func').return(expected)
  call self.assert.equals(expected, vmock#mock#return('g:vmock_global_func'))
endfunction

function! s:t.exception_when_not_exists_function_1()
  call self.assert.throw('VMockException:The mock(g:vmock_not_exists_func) is not registered.')
  call vmock#mock#return('g:vmock_not_exists_func')
endfunction

function! s:t.exception_when_not_exists_function_2()
  call self.assert.throw('VMockException:The mock(VmockNotExistsFunc) is not registered.')
  call vmock#mock#return('VmockNotExistsFunc')
endfunction
"}}}
let s:t = vimtest#new('vmock#mock#called()') "{{{

function! s:t.setup()
  function! g:vmock_global_func(arg)
    return a:arg + 10
  endfunction
endfunction

function! s:t.teardown()
  delfunction g:vmock_global_func
endfunction

" TODO 今のところ疎通テスト(動かしてエラーが起きない確認)のみ
function! s:t.success()
  call vmock#mock#new().func('g:vmock_global_func').with(20).return(10)
  call self.assert.equals(1, vmock#mock#called('g:vmock_global_func', [20]))
endfunction

function! s:t.exception_when_not_exists_function_1()
  call self.assert.throw('VMockException:The mock(g:vmock_not_exists_func) is not registered.')
  call vmock#mock#called('g:vmock_not_exists_func', [])
endfunction

function! s:t.exception_when_not_exists_function_2()
  call self.assert.throw('VMockException:The mock(VmockNotExistsFunc) is not registered.')
  call vmock#mock#called('VmockNotExistsFunc', [])
endfunction
"}}}
