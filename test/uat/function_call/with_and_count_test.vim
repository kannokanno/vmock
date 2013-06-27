function! s:make_test(name) "{{{
  let t = vimtest#new(a:name)

  function! t.setup()
    call vmock#container#clear()

    function! g:vmock_test_func_no_args()
    endfunction
    function! g:vmock_test_func_one_args(one)
    endfunction
    function! g:vmock_test_func_two_args(one, two)
    endfunction
    function! g:vmock_test_func_variable_args(...)
    endfunction
  endfunction

  function! t.teardown()
    delfunction g:vmock_test_func_no_args
    delfunction g:vmock_test_func_one_args
    delfunction g:vmock_test_func_two_args
    delfunction g:vmock_test_func_variable_args
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
let s:t = s:make_test('UAT - with and count ') "{{{

function! s:t.match_success_and_count_success()
  call vmock#mock('g:vmock_test_func_two_args')
        \.with(vmock#eq('hoge'), vmock#eq([1, 2])).return(100).times(3)
  call self.assert.equals(100, g:vmock_test_func_two_args('hoge', [1, 2]))
  call self.assert.equals(100, g:vmock_test_func_two_args('hoge', [1, 2]))
  call self.assert.equals(100, g:vmock_test_func_two_args('hoge', [1, 2]))
  call self._assert_verify_is_success()
endfunction

function! s:t.match_success_and_count_fail()
  call vmock#mock('g:vmock_test_func_two_args')
        \.with(vmock#eq('hoge'), vmock#eq([1, 2])).return(100).times(3)
  call self.assert.equals(100, g:vmock_test_func_two_args('hoge', [1, 2]))
  call self.assert.equals(100, g:vmock_test_func_two_args('hoge', [1, 2]))
  call self._assert_verify_is_fail("expected: exactly 3 times. but received: 2 times.")
endfunction

function! s:t.match_fail_and_count_success()
  call vmock#mock('g:vmock_test_func_two_args')
        \.with(vmock#eq('hoge'), vmock#eq([1, 2])).return(100).times(3)
  call self.assert.equals(100, g:vmock_test_func_two_args('hoge', [1, 2]))
  call self.assert.equals(100, g:vmock_test_func_two_args('hoge', [1, 2]))
  call self.assert.equals(100, g:vmock_test_func_two_args('piyo', [1, 2]))
  call self._assert_verify_is_fail("The args[0] expected: 'hoge'. but received: 'piyo'.")
endfunction

function! s:t.match_fail_and_count_fail()
  call vmock#mock('g:vmock_test_func_two_args')
        \.with(vmock#eq('hoge'), vmock#eq([1, 2])).return(100).times(3)
  call self.assert.equals(100, g:vmock_test_func_two_args('hoge', [1, 2]))
  call self.assert.equals(100, g:vmock_test_func_two_args('hoge', [1, 2]))
  call self.assert.equals(100, g:vmock_test_func_two_args('piyo', [1, 2]))
  call self.assert.equals(100, g:vmock_test_func_two_args('hoge', [1, 2]))
  call self._assert_verify_is_fail("expected: exactly 3 times. but received: 4 times.")
endfunction
"}}}
