function! s:make_test(name) "{{{
  let t = vimtest#new(a:name)

  function! t.setup()
    call vmock#container#clear()
    function! g:vmock_test_func()
      return 10
    endfunction
  endfunction

  function! t.teardown()
    delfunction g:vmock_test_func
  endfunction

  function! t._assert_verify_is_success()
    for mock in vmock#container#get_mocks()
      let result = mock.verify()
      if result.is_fail
        call self.assert.fail(result.message)
      endif
    endfor
    call self.assert.success()
  endfunction

  function! t._assert_verify_is_fail(expected)
    for mock in vmock#container#get_mocks()
      let result = mock.verify()
      if result.is_fail
        call self.assert.equals(a:expected, result.message)
        return
      endif
    endfor
    call self.assert.fail('Expected failed but success')
  endfunction

  return t
endfunction
"}}}
let s:t = s:make_test('UAT - count - none') "{{{
function! s:t.success_on_not_call()
  call vmock#mock('g:vmock_test_func').return(100)
  call self._assert_verify_is_success()
endfunction

function! s:t.none_equal_any()
  call vmock#mock('g:vmock_test_func').return(100)
  call self.assert.equals(100, g:vmock_test_func())
  call self.assert.equals(100, g:vmock_test_func())
  call self.assert.equals(100, g:vmock_test_func())
  call self._assert_verify_is_success()
endfunction
"}}}
let s:t = s:make_test('UAT - count - once') "{{{

function! s:t.success()
  call vmock#mock('g:vmock_test_func').return(100).once()
  call self.assert.equals(100, g:vmock_test_func())
  call self._assert_verify_is_success()
endfunction

function! s:t.fail_on_not_call()
  call vmock#mock('g:vmock_test_func').return(100).once()
  call self._assert_verify_is_fail('expected: only once. but received: 0 times.')
endfunction

function! s:t.fail_on_more_once()
  call vmock#mock('g:vmock_test_func').return(100).once()
  call self.assert.equals(100, g:vmock_test_func())
  call self.assert.equals(100, g:vmock_test_func())
  call self._assert_verify_is_fail('expected: only once. but received: 2 times.')
endfunction
"}}}
let s:t = s:make_test('UAT - count - times') "{{{
function! s:t.success()
  call vmock#mock('g:vmock_test_func').return(100).times(2)
  call self.assert.equals(100, g:vmock_test_func())
  call self.assert.equals(100, g:vmock_test_func())
  call self._assert_verify_is_success()
endfunction

function! s:t.fail_on_not_call()
  call vmock#mock('g:vmock_test_func').return(100).times(2)
  call self._assert_verify_is_fail('expected: exactly 2 times. but received: 0 times.')
endfunction

function! s:t.fail_on_more_once()
  call vmock#mock('g:vmock_test_func').return(100).times(2)
  call self.assert.equals(100, g:vmock_test_func())
  call self.assert.equals(100, g:vmock_test_func())
  call self.assert.equals(100, g:vmock_test_func())
  call self._assert_verify_is_fail('expected: exactly 2 times. but received: 3 times.')
endfunction
"}}}
let s:t = s:make_test('UAT - count - any') "{{{
function! s:t.success_on_not_call()
  call vmock#mock('g:vmock_test_func').return(100).any()
  call self._assert_verify_is_success()
endfunction

function! s:t.success()
  call vmock#mock('g:vmock_test_func').return(100).any()
  call self.assert.equals(100, g:vmock_test_func())
  call self.assert.equals(100, g:vmock_test_func())
  call self.assert.equals(100, g:vmock_test_func())
  call self._assert_verify_is_success()
endfunction
"}}}
let s:t = s:make_test('UAT - count - never') "{{{
function! s:t.success()
  call vmock#mock('g:vmock_test_func').return(100).never()
  call self._assert_verify_is_success()
endfunction

function! s:t.fail_on_call()
  call vmock#mock('g:vmock_test_func').return(100).never()
  call self.assert.equals(100, g:vmock_test_func())
  call self.assert.equals(100, g:vmock_test_func())
  call self._assert_verify_is_fail('expected: never call. but received: 2 times.')
endfunction

"}}}
let s:t = s:make_test('UAT - count - at_least') "{{{
function! s:t.fail_on_not_call()
  call vmock#mock('g:vmock_test_func').return(100).at_least(2)
  call self._assert_verify_is_fail('expected: at least 2 times. but received: 0 times.')
endfunction

function! s:t.fail_on_less_than()
  call vmock#mock('g:vmock_test_func').return(100).at_least(2)
  call self.assert.equals(100, g:vmock_test_func())
  call self._assert_verify_is_fail('expected: at least 2 times. but received: 1 times.')
endfunction

function! s:t.success()
  call vmock#mock('g:vmock_test_func').return(100).at_least(2)
  call self.assert.equals(100, g:vmock_test_func())
  call self.assert.equals(100, g:vmock_test_func())
  call self._assert_verify_is_success()
endfunction
"}}}
let s:t = s:make_test('UAT - count - at_most') "{{{
function! s:t.success_on_not_call()
  call vmock#mock('g:vmock_test_func').return(100).at_most(2)
  call self._assert_verify_is_success()
endfunction

function! s:t.success()
  call vmock#mock('g:vmock_test_func').return(100).at_most(3)
  call self.assert.equals(100, g:vmock_test_func())
  call self.assert.equals(100, g:vmock_test_func())
  call self.assert.equals(100, g:vmock_test_func())
  call self._assert_verify_is_success()
endfunction

function! s:t.fail_on_more_than()
  call vmock#mock('g:vmock_test_func').return(100).at_most(3)
  call self.assert.equals(100, g:vmock_test_func())
  call self.assert.equals(100, g:vmock_test_func())
  call self.assert.equals(100, g:vmock_test_func())
  call self.assert.equals(100, g:vmock_test_func())
  call self._assert_verify_is_fail('expected: at most 3 times. but received: 4 times.')
endfunction
"}}}
