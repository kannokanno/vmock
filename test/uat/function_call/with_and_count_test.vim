let s:suite  = themis#suite('UAT - with and count ')
let s:assert = themis#helper('assert')

function! s:suite.before_each()
  call vmock#clear()

  function! VMockTestFunc_no_args()
  endfunction
  function! VMockTestFunc_one_args(one)
  endfunction
  function! VMockTestFunc_two_args(one, two)
  endfunction
  function! VMockTestFunc_variable_args(...)
  endfunction
endfunction

function! s:suite.after_each()
  delfunction VMockTestFunc_no_args
  delfunction VMockTestFunc_one_args
  delfunction VMockTestFunc_two_args
  delfunction VMockTestFunc_variable_args
endfunction

" mock呼び出しが期待通りに呼ばれたことをassertするヘルパー
function! s:_assert_verify_is_success()
  for mock in vmock#container#get_mocks()
    let result = mock.verify()
    if result.is_fail
      call s:assert.fail(result.message)
    endif
  endfor
  call s:assert.true(1)
endfunction

" mock呼び出しが期待通りに呼ばれなかったことをassertするヘルパー
function! s:_assert_verify_is_fail(expected)
  for mock in vmock#container#get_mocks()
    let result = mock.verify()
    if result.is_fail
      call s:assert.equals(a:expected, result.message)
      return
    endif
  endfor
  call s:assert.fail('Expected failed but success')
endfunction

function! s:suite.match_success_and_count_success()
  call vmock#mock('VMockTestFunc_two_args')
        \.with(vmock#eq('hoge'), vmock#eq([1, 2])).return(100).times(3)
  call s:assert.equals(100, VMockTestFunc_two_args('hoge', [1, 2]))
  call s:assert.equals(100, VMockTestFunc_two_args('hoge', [1, 2]))
  call s:assert.equals(100, VMockTestFunc_two_args('hoge', [1, 2]))
  call s:_assert_verify_is_success()
endfunction

function! s:suite.match_success_and_count_fail()
  call vmock#mock('VMockTestFunc_two_args')
        \.with(vmock#eq('hoge'), vmock#eq([1, 2])).return(100).times(3)
  call s:assert.equals(100, VMockTestFunc_two_args('hoge', [1, 2]))
  call s:assert.equals(100, VMockTestFunc_two_args('hoge', [1, 2]))
  call s:_assert_verify_is_fail("expected: exactly 3 times. but received: 2 times.")
endfunction

function! s:suite.match_fail_and_count_success()
  call vmock#mock('VMockTestFunc_two_args')
        \.with(vmock#eq('hoge'), vmock#eq([1, 2])).return(100).times(3)
  call s:assert.equals(100, VMockTestFunc_two_args('hoge', [1, 2]))
  call s:assert.equals(100, VMockTestFunc_two_args('hoge', [1, 2]))
  call s:assert.equals(100, VMockTestFunc_two_args('piyo', [1, 2]))
  call s:_assert_verify_is_fail("The args[0] expected: 'hoge'. but received: 'piyo'.")
endfunction

function! s:suite.match_fail_and_count_fail()
  call vmock#mock('VMockTestFunc_two_args')
        \.with(vmock#eq('hoge'), vmock#eq([1, 2])).return(100).times(3)
  call s:assert.equals(100, VMockTestFunc_two_args('hoge', [1, 2]))
  call s:assert.equals(100, VMockTestFunc_two_args('hoge', [1, 2]))
  call s:assert.equals(100, VMockTestFunc_two_args('piyo', [1, 2]))
  call s:assert.equals(100, VMockTestFunc_two_args('hoge', [1, 2]))
  call s:_assert_verify_is_fail("expected: exactly 3 times. but received: 4 times.")
endfunction

