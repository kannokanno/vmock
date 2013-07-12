function! s:make_test(name) "{{{
  let t = vimtest#new(a:name)

  function! t.setup()
    call vmock#clear()

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
    let event = {'_test': self}

    function! event.on_success()
      call self._test.assert.success()
    endfunction

    function! event.on_failure(message)
      call self._test.assert.fail(a:message)
    endfunction

    call vmock#verify_with_event(event)
  endfunction

  function! t._assert_verify_is_fail(expected)
    let event = {'_test': self, '_expected': a:expected}

    function! event.on_success()
      call self._test.assert.fail('Expected failed but success')
    endfunction

    function! event.on_failure(message)
      call self._test.assert.equals(self._expected, a:message)
    endfunction

    call vmock#verify_with_event(event)
  endfunction

  return t
endfunction
"}}}
let s:t = s:make_test('UAT - with - none') "{{{

function! s:t.none_equal_any()
  call vmock#mock('g:vmock_test_func_variable_args')
  call g:vmock_test_func_variable_args(10, 'hoge', [1], {'a':1})
  call self._assert_verify_is_success()
endfunction
"}}}
let s:t = s:make_test('UAT - with - any') "{{{

function! s:t.success()
  call vmock#mock('g:vmock_test_func_variable_args').with(vmock#any())
  call g:vmock_test_func_variable_args([1])
  call self._assert_verify_is_success()
endfunction
"}}}
let s:t = s:make_test('UAT - with - type') "{{{

function! s:t.success()
  call vmock#mock('g:vmock_test_func_two_args').with(vmock#type(1), vmock#type({}))
  call g:vmock_test_func_two_args(10, {'a':1})
  call self._assert_verify_is_success()
endfunction

function! s:t.fail_first_arg()
  call vmock#mock('g:vmock_test_func_two_args').with(vmock#type(1), vmock#type({}))
  call g:vmock_test_func_two_args('hoge', {'a':1})
  call self._assert_verify_is_fail('The args[0] expected: type(0). but received: type("").')
endfunction

function! s:t.fail_second_arg()
  call vmock#mock('g:vmock_test_func_two_args').with(vmock#type(1), vmock#type({}))
  call g:vmock_test_func_two_args(0, [])
  call self._assert_verify_is_fail('The args[1] expected: type({}). but received: type([]).')
endfunction
"}}}
let s:t = s:make_test('UAT - with - not_type') "{{{

function! s:t.success()
  call vmock#mock('g:vmock_test_func_two_args').with(vmock#not_type(1), vmock#not_type({}))
  call g:vmock_test_func_two_args('aa', [1])
  call self._assert_verify_is_success()
endfunction

function! s:t.fail_first_arg()
  call vmock#mock('g:vmock_test_func_two_args').with(vmock#not_type(1), vmock#not_type({}))
  call g:vmock_test_func_two_args(10, [1])
  call self._assert_verify_is_fail('The args[0] expected: except type(0). but received: type(0).')
endfunction

function! s:t.fail_second_arg()
  call vmock#mock('g:vmock_test_func_two_args').with(vmock#not_type(1), vmock#not_type({}))
  call g:vmock_test_func_two_args('a', {'a': 1})
  call self._assert_verify_is_fail('The args[1] expected: except type({}). but received: type({}).')
endfunction
"}}}
let s:t = s:make_test('UAT - with - eq') "{{{

function! s:t.success()
  call vmock#mock('g:vmock_test_func_two_args').with(vmock#eq('hoge'), vmock#eq([1, 2]))
  call g:vmock_test_func_two_args('hoge', [1, 2])
  call self._assert_verify_is_success()
endfunction

function! s:t.fail()
  call vmock#mock('g:vmock_test_func_two_args').with(vmock#eq('hoge'), vmock#eq([1, 2]))
  call g:vmock_test_func_two_args('Hoge', [1, 2])
  call self._assert_verify_is_fail("The args[0] expected: 'hoge'. but received: 'Hoge'.")
endfunction
"}}}
let s:t = s:make_test('UAT - with - not_eq') "{{{

function! s:t.success()
  call vmock#mock('g:vmock_test_func_two_args').with(vmock#not_eq('hoge'), vmock#not_eq([1, 2]))
  call g:vmock_test_func_two_args('Hoge', [2, 1])
  call self._assert_verify_is_success()
endfunction

function! s:t.fail()
  call vmock#mock('g:vmock_test_func_two_args').with(vmock#not_eq('hoge'), vmock#not_eq([1, 2]))
  call g:vmock_test_func_two_args('hoge', [2, 1])
  call self._assert_verify_is_fail("The args[0] expected: not equal(==#) 'hoge'. but received: 'hoge'.")
endfunction
"}}}
let s:t = s:make_test('UAT - with - loose_eq') "{{{

function! s:t.success()
  call vmock#mock('g:vmock_test_func_one_args').with(vmock#loose_eq('hoge'))
  call g:vmock_test_func_one_args('hoge')
  call self._assert_verify_is_success()
endfunction

function! s:t.success_ignore_case()
  call vmock#mock('g:vmock_test_func_one_args').with(vmock#loose_eq('hoge'))
  call g:vmock_test_func_one_args('Hoge')
  call self._assert_verify_is_success()
endfunction

function! s:t.fail()
  call vmock#mock('g:vmock_test_func_one_args').with(vmock#loose_eq('hoge'))
  call g:vmock_test_func_one_args([1, 2])
  call self._assert_verify_is_fail("The args[0] expected: 'hoge'. but received: [1, 2].")
endfunction
"}}}
let s:t = s:make_test('UAT - with - loose_not_eq') "{{{

function! s:t.success()
  call vmock#mock('g:vmock_test_func_one_args').with(vmock#loose_not_eq('hoge'))
  call g:vmock_test_func_one_args('piyo')
  call self._assert_verify_is_success()
endfunction

function! s:t.fail()
  call vmock#mock('g:vmock_test_func_one_args').with(vmock#loose_not_eq('hoge'))
  call g:vmock_test_func_one_args('hoge')
  call self._assert_verify_is_fail("The args[0] expected: not equal(==) 'hoge'. but received: 'hoge'.")
endfunction
"}}}
let s:t = s:make_test('UAT - with - has') "{{{

function! s:t.success()
  call vmock#mock('g:vmock_test_func_one_args').with(vmock#has('bar'))
  call g:vmock_test_func_one_args(['foo', 'bar'])
  call self._assert_verify_is_success()
endfunction

function! s:t.fail()
  call vmock#mock('g:vmock_test_func_one_args').with(vmock#has('baz'))
  call g:vmock_test_func_one_args(['foo', 'bar'])
  call self._assert_verify_is_fail("The args[0] expected: has('baz'). but not found.")
endfunction
"}}}
let s:t = s:make_test('UAT - with - not_has') "{{{

function! s:t.success()
  call vmock#mock('g:vmock_test_func_one_args').with(vmock#not_has('baz'))
  call g:vmock_test_func_one_args(['foo', 'bar'])
  call self._assert_verify_is_success()
endfunction

function! s:t.fail()
  call vmock#mock('g:vmock_test_func_one_args').with(vmock#not_has('bar'))
  call g:vmock_test_func_one_args(['foo', 'bar'])
  call self._assert_verify_is_fail("The args[0] expected: has not('bar'). but found.")
endfunction
"}}}
let s:t = s:make_test('UAT - with - custom') "{{{

function! s:t.success()
  function! VMockCustomMatcher(arg)
    return len(a:arg) ==# 2
  endfunction

  call vmock#mock('g:vmock_test_func_one_args').with(vmock#custom('VMockCustomMatcher'))
  call g:vmock_test_func_one_args(['foo', 'bar'])
  call self._assert_verify_is_success()
endfunction

function! s:t.fail()
  function! VMockCustomMatcher(arg)
    return len(a:arg) ==# 2
  endfunction

  call vmock#mock('g:vmock_test_func_one_args').with(vmock#custom('VMockCustomMatcher'))
  call g:vmock_test_func_one_args(['foo'])
  call self._assert_verify_is_fail("Failed custom matcher. The args[0] match function: VMockCustomMatcher, args: ['foo']")
endfunction
"}}}
