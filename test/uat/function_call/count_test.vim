function! s:make_test(name)
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
        call self.assert.fail(result.get_message())
      endif
    endfor
    call self.assert.success()
  endfunction

  return t
endfunction

" TODO failケース

let s:t = s:make_test('UAT - count - none') "{{{

function! s:t.none_equal_any()
  call vmock#mock('g:vmock_test_func').return(100)
  call self.assert.equals(100, g:vmock_test_func())
  call self.assert.equals(100, g:vmock_test_func())
  call self.assert.equals(100, g:vmock_test_func())
  call self._assert_verify_is_success()
endfunction
"}}}
let s:t = s:make_test('UAT - count - once') "{{{

function! s:t.once_success()
  call vmock#mock('g:vmock_test_func').return(100).once()
  call self.assert.equals(100, g:vmock_test_func())
  call self._assert_verify_is_success()
endfunction
"}}}
let s:t = s:make_test('UAT - count - times') "{{{
function! s:t.two_times_success()
  call vmock#mock('g:vmock_test_func').return(100).times(2)
  call self.assert.equals(100, g:vmock_test_func())
  call self.assert.equals(100, g:vmock_test_func())
  call self._assert_verify_is_success()
endfunction
"}}}
let s:t = s:make_test('UAT - count - any') "{{{
function! s:t.any_success()
  call vmock#mock('g:vmock_test_func').return(100).any()
  call self.assert.equals(100, g:vmock_test_func())
  call self.assert.equals(100, g:vmock_test_func())
  call self.assert.equals(100, g:vmock_test_func())
  call self._assert_verify_is_success()
endfunction
"}}}
let s:t = s:make_test('UAT - count - never') "{{{
function! s:t.never_success()
  call vmock#mock('g:vmock_test_func').return(100).never()
  call self._assert_verify_is_success()
endfunction
"}}}
let s:t = s:make_test('UAT - count - at_least') "{{{
function! s:t.at_least_two_success()
  call vmock#mock('g:vmock_test_func').return(100).at_least(2)
  call self.assert.equals(100, g:vmock_test_func())
  call self.assert.equals(100, g:vmock_test_func())
  call self._assert_verify_is_success()
endfunction
"}}}
let s:t = s:make_test('UAT - count - at_most') "{{{
function! s:t.at_most_two_success()
  call vmock#mock('g:vmock_test_func').return(100).at_least(3)
  call self.assert.equals(100, g:vmock_test_func())
  call self.assert.equals(100, g:vmock_test_func())
  call self.assert.equals(100, g:vmock_test_func())
  call self._assert_verify_is_success()
endfunction
"}}}
