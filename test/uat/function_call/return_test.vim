let s:suite  = themis#suite('UAT - return')
let s:assert = themis#helper('assert')

function! s:suite.after_each()
  if exists('VMockTestFunc')
    delfunction VMockTestFunc
  endif
endfunction

function! s:suite.override_value()
  function! VMockTestFunc()
    return 10
  endfunction

  let mock = vmock#mock('VMockTestFunc')
  let data_patterns = [
    \ -1, -0.2, 0, 3.0, 100,
    \ '', 'hoge', '日本語', 'Two word',
    \ [], [1], [1, 4], [0.5, 'a'],
    \ {}, {'a': 1}, {'a': {'b': 2}},
    \ function('tr'),
  \ ]

  for Expected in data_patterns
    call mock.return(Expected)
    call s:assert.equals(Expected, VMockTestFunc())
    unlet! Expected
  endfor
endfunction

function! s:suite.override_value_even_if_no_return_statement()
  function! VMockTestFunc()
  endfunction
  " return 0 is Vim script specification
  call s:assert.equals(0, VMockTestFunc())
  call vmock#mock('VMockTestFunc').return(100)
  call s:assert.equals(100, VMockTestFunc())
endfunction

" return指定がなければ結果は0になる
function! s:suite.default_return_value_is_0()
  function! VMockTestFunc()
    return 10
  endfunction
  call s:assert.equals(10, VMockTestFunc())
  call vmock#mock('VMockTestFunc')
  call s:assert.equals(0, VMockTestFunc())
endfunction

function! s:suite.more_mocks_can_be_created()
  function! VMockTestFunc1()
    return 10
  endfunction
  function! VMockTestFunc2()
    return 20
  endfunction

  call s:assert.equals(10, VMockTestFunc1())
  call s:assert.equals(20, VMockTestFunc2())

  call vmock#mock('VMockTestFunc1').return(100)
  call s:assert.equals(100, VMockTestFunc1())
  call vmock#mock('VMockTestFunc2').return(200)
  call s:assert.equals(200, VMockTestFunc2())

  delfunction VMockTestFunc1
  delfunction VMockTestFunc2
endfunction
