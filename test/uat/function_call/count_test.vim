function! s:make_test(name)
  let t = themis#suite(a:name)

  function! t.before_each()
    call vmock#clear()
    function! VMockTestFunc()
      return 10
    endfunction
  endfunction

  function! t.after_each()
    delfunction VMockTestFunc
  endfunction

  return t
endfunction

let s:assert = themis#helper('assert')

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
      call s:assert.equals(result.message, a:expected)
      return
    endif
  endfor
  call s:assert.fail('Expected failed but success')
endfunction

let s:t = s:make_test('UAT - count - none')
function! s:t.success_on_not_call()
  call vmock#mock('VMockTestFunc').return(100)
  call s:_assert_verify_is_success()
endfunction

function! s:t.none_equal_any()
  let expect = vmock#mock('VMockTestFunc').return(100)
  call s:assert.equals(vmock#matcher#count#default(), expect.get_counter())
  call s:_assert_verify_is_success()
endfunction

let s:t = s:make_test('UAT - count - once')

function! s:t.success()
  call vmock#mock('VMockTestFunc').return(100).once()
  call s:assert.equals(100, VMockTestFunc())
  call s:_assert_verify_is_success()
endfunction

function! s:t.fail_on_not_call()
  call vmock#mock('VMockTestFunc').return(100).once()
  call s:_assert_verify_is_fail('expected: only once. but received: 0 times.')
endfunction

function! s:t.fail_on_more_once()
  call vmock#mock('VMockTestFunc').return(100).once()
  call s:assert.equals(100, VMockTestFunc())
  call s:assert.equals(100, VMockTestFunc())
  call s:_assert_verify_is_fail('expected: only once. but received: 2 times.')
endfunction

let s:t = s:make_test('UAT - count - times')
function! s:t.success()
  call vmock#mock('VMockTestFunc').return(100).times(2)
  call s:assert.equals(100, VMockTestFunc())
  call s:assert.equals(100, VMockTestFunc())
  call s:_assert_verify_is_success()
endfunction

function! s:t.fail_on_not_call()
  call vmock#mock('VMockTestFunc').return(100).times(2)
  call s:_assert_verify_is_fail('expected: exactly 2 times. but received: 0 times.')
endfunction

function! s:t.fail_on_more_once()
  call vmock#mock('VMockTestFunc').return(100).times(2)
  call s:assert.equals(100, VMockTestFunc())
  call s:assert.equals(100, VMockTestFunc())
  call s:assert.equals(100, VMockTestFunc())
  call s:_assert_verify_is_fail('expected: exactly 2 times. but received: 3 times.')
endfunction

let s:t = s:make_test('UAT - count - any')
function! s:t.success_on_not_call()
  call vmock#mock('VMockTestFunc').return(100).any()
  call s:_assert_verify_is_success()
endfunction

function! s:t.success()
  call vmock#mock('VMockTestFunc').return(100).any()
  call s:assert.equals(100, VMockTestFunc())
  call s:assert.equals(100, VMockTestFunc())
  call s:assert.equals(100, VMockTestFunc())
  call s:_assert_verify_is_success()
endfunction

let s:t = s:make_test('UAT - count - never')
function! s:t.success()
  call vmock#mock('VMockTestFunc').return(100).never()
  call s:_assert_verify_is_success()
endfunction

function! s:t.fail_on_call()
  call vmock#mock('VMockTestFunc').return(100).never()
  call s:assert.equals(100, VMockTestFunc())
  call s:assert.equals(100, VMockTestFunc())
  call s:_assert_verify_is_fail('expected: never call. but received: 2 times.')
endfunction


let s:t = s:make_test('UAT - count - at_least')
function! s:t.fail_on_not_call()
  call vmock#mock('VMockTestFunc').return(100).at_least(2)
  call s:_assert_verify_is_fail('expected: at least 2 times. but received: 0 times.')
endfunction

function! s:t.fail_on_less_than()
  call vmock#mock('VMockTestFunc').return(100).at_least(2)
  call s:assert.equals(100, VMockTestFunc())
  call s:_assert_verify_is_fail('expected: at least 2 times. but received: 1 times.')
endfunction

function! s:t.success()
  call vmock#mock('VMockTestFunc').return(100).at_least(2)
  call s:assert.equals(100, VMockTestFunc())
  call s:assert.equals(100, VMockTestFunc())
  call s:_assert_verify_is_success()
endfunction

function! s:t.exception_on_multiple_caled()
  try
    call vmock#mock('VMockTestFunc').return(100).at_most(3).any()

    " ここに到達したら失敗の証
    call s:assert.true(0)
  catch
    call s:assert.equals(v:exception, 'VMock:count is already set up.')
  endtry
endfunction

let s:t = s:make_test('UAT - count - at_most')
function! s:t.success_on_not_call()
  call vmock#mock('VMockTestFunc').return(100).at_most(2)
  call s:_assert_verify_is_success()
endfunction

function! s:t.success()
  call vmock#mock('VMockTestFunc').return(100).at_most(3)
  call s:assert.equals(100, VMockTestFunc())
  call s:assert.equals(100, VMockTestFunc())
  call s:assert.equals(100, VMockTestFunc())
  call s:_assert_verify_is_success()
endfunction

function! s:t.fail_on_more_than()
  call vmock#mock('VMockTestFunc').return(100).at_most(3)
  call s:assert.equals(100, VMockTestFunc())
  call s:assert.equals(100, VMockTestFunc())
  call s:assert.equals(100, VMockTestFunc())
  call s:assert.equals(100, VMockTestFunc())
  call s:_assert_verify_is_fail('expected: at most 3 times. but received: 4 times.')
endfunction


let s:t = s:make_test('UAT - count - multiple called')
function! s:t.at_most_to_any()
  try
    call vmock#mock('VMockTestFunc').return(100).at_most(3).any()

    " ここに到達したら失敗の証
    call s:assert.true(0)
  catch
    call s:assert.equals(v:exception, 'VMock:count is already set up.')
  endtry
endfunction

function! s:t.times_to_never()
  try
    call vmock#mock('VMockTestFunc').return(100).times(2).never()

    " ここに到達したら失敗の証
    call s:assert.true(0)
  catch
    call s:assert.equals(v:exception, 'VMock:count is already set up.')
  endtry
endfunction

function! s:t.any_to_any()
  try
    call vmock#mock('VMockTestFunc').return(100).any().any()

    " ここに到達したら失敗の証
    call s:assert.true(0)
  catch
    call s:assert.equals(v:exception, 'VMock:count is already set up.')
  endtry
endfunction

