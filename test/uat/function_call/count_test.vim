function! s:make_test(name)
  let t = vimtest#new(a:name)

  function! t.setup()
    function! g:vmock_test_func()
      return 10
    endfunction
  endfunction

  function! t.teardown()
    delfunction g:vmock_test_func
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
endfunction
"}}}
let s:t = s:make_test('UAT - count - once') "{{{

function! s:t.once_success()
  call vmock#mock('g:vmock_test_func').return(100).once()
  call self.assert.equals(100, g:vmock_test_func())
endfunction
"}}}
let s:t = s:make_test('UAT - count - times') "{{{
function! s:t.two_times_success()
  call vmock#mock('g:vmock_test_func').return(100).times(2)
  call self.assert.equals(100, g:vmock_test_func())
  call self.assert.equals(100, g:vmock_test_func())
endfunction
"}}}
let s:t = s:make_test('UAT - count - any') "{{{
function! s:t.any_success()
  call vmock#mock('g:vmock_test_func').return(100).any()
  call self.assert.equals(100, g:vmock_test_func())
  call self.assert.equals(100, g:vmock_test_func())
  call self.assert.equals(100, g:vmock_test_func())
endfunction
"}}}
let s:t = s:make_test('UAT - count - never') "{{{
function! s:t.never_success()
  call vmock#mock('g:vmock_test_func').return(100).never()
endfunction
"}}}
let s:t = s:make_test('UAT - count - at_least') "{{{
function! s:t.at_least_two_success()
  call vmock#mock('g:vmock_test_func').return(100).at_least(2)
  call self.assert.equals(100, g:vmock_test_func())
  call self.assert.equals(100, g:vmock_test_func())
endfunction
"}}}
let s:t = s:make_test('UAT - count - at_most') "{{{
function! s:t.at_most_two_success()
  call vmock#mock('g:vmock_test_func').return(100).at_least(3)
  call self.assert.equals(100, g:vmock_test_func())
  call self.assert.equals(100, g:vmock_test_func())
  call self.assert.equals(100, g:vmock_test_func())
endfunction
"}}}
