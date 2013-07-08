let s:t = vimtest#new('UAT - return')

function! s:t.teardown()
  if exists('g:vmock_test_func')
    delfunction g:vmock_test_func
  endif
endfunction

function! s:t.override_value()
  function! g:vmock_test_func()
    return 10
  endfunction

  let mock = vmock#mock('g:vmock_test_func')
  for Expected in s:data_patterns()
    call mock.return(Expected)
    call self.assert.equals(Expected, g:vmock_test_func())
    unlet! Expected
  endfor
endfunction

function! s:t.override_value_even_if_no_return_statement()
  function! g:vmock_test_func()
  endfunction
  " return 0 is Vim script specification
  call self.assert.equals(0, g:vmock_test_func())
  call vmock#mock('g:vmock_test_func').return(100)
  call self.assert.equals(100, g:vmock_test_func())
endfunction

" return指定がなければ結果は0になる
function! s:t.default_return_value_is_0()
  function! g:vmock_test_func()
    return 10
  endfunction
  call self.assert.equals(10, g:vmock_test_func())
  call vmock#mock('g:vmock_test_func')
  call self.assert.equals(0, g:vmock_test_func())
endfunction

function! s:t.more_mocks_can_be_created()
  function! g:vmock_test_func1()
    return 10
  endfunction
  function! g:vmock_test_func2()
    return 20
  endfunction

  call self.assert.equals(10, g:vmock_test_func1())
  call self.assert.equals(20, g:vmock_test_func2())

  call vmock#mock('g:vmock_test_func1').return(100)
  call self.assert.equals(100, g:vmock_test_func1())
  call vmock#mock('g:vmock_test_func2').return(200)
  call self.assert.equals(200, g:vmock_test_func2())

  delfunction g:vmock_test_func1
  delfunction g:vmock_test_func2
endfunction

function! s:data_patterns()
  " TODO function('tr') => vimtestのバグ修正待ち
  return [-1, -0.2, 0, 3.0, 100,
        \ '', 'hoge', '日本語', 'Two word',
        \ [], [1], [1, 4], [0.5, 'a'],
        \ {}, {'a': 1}, {'a': {'b': 2}},
        \ ]
endfunction
