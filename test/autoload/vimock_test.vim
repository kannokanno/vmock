let s:t = vimtest#new('mock of global function(g:)')

function! s:t.setup()
  function! g:vimmock_global_func()
    return 10
  endfunction
endfunction

function! s:t.teardown()
  delfunction g:vimmock_global_func
endfunction

function! s:t.not_return()
  call self.assert.fail("未実装")
endfunction

function! s:t.no_args()
  call self.assert.equals(10, g:vimmock_global_func())
  let mock = vimock#mock()
  call mock.function('g:vimmock_global_func').return(100)
  call self.assert.equals(100, g:vimmock_global_func())
endfunction

function! s:t.with_args_default()
  " 引数1つ
  " 引数複数
  " 引数の型ごとに
  call self.assert.fail("未実装")
endfunction

function! s:t.with_args_any()
  call self.assert.fail("未実装")
endfunction

function! s:t.with_args_type()
  call self.assert.fail("未実装")
endfunction

function! s:t.with_args_equals()
  call self.assert.fail("未実装")
endfunction

function! s:t.with_args_strict_equals()
  call self.assert.fail("未実装")
endfunction

function! s:t.throw()
  call self.assert.fail("未実装")
endfunction

function! s:t.once()
  call self.assert.fail("未実装")
endfunction

function! s:t.times()
  call self.assert.fail("未実装")
endfunction

function! s:t.any()
  call self.assert.fail("未実装")
endfunction

function! s:t.never()
  call self.assert.fail("未実装")
endfunction

function! s:t.at_least()
  call self.assert.fail("未実装")
endfunction

function! s:t.at_most()
  call self.assert.fail("未実装")
endfunction

function! s:t.callback()
  " 仕様決めから
  call self.assert.fail("未実装")
endfunction
