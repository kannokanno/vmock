function! s:make_test(name)
  let t = vimtest#new(a:name)

  function! t.setup()
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
  return t
endfunction

" TODO failケース

let s:t = s:make_test('UAT - with - none') "{{{

function! s:t.none_equal_any()
  call vmock#mock('g:vmock_test_func_variable_args')
  call g:vmock_test_func_variable_args(10, 'hoge', [1], {'a':1})
  call self.assert.success()
endfunction
"}}}
let s:t = s:make_test('UAT - with - any') "{{{

function! s:t.success_case()
  call vmock#mock('g:vmock_test_func_variable_args').with(vmock#any())
  call g:vmock_test_func_variable_args(10, 'hoge', [1], {'a':1})
  call self.assert.success()
endfunction
"}}}
let s:t = s:make_test('UAT - with - type') "{{{

function! s:t.success_case()
  call vmock#mock('g:vmock_test_func_two_args').with(vmock#type(1), vmock#type({}))
  call g:vmock_test_func_two_args(10, {'a':1})
  call self.assert.success()
endfunction
"}}}
let s:t = s:make_test('UAT - with - eq') "{{{

function! s:t.success_case()
  call vmock#mock('g:vmock_test_func_two_args').with(vmock#eq('hoge'), vmock#eq([1, 2]))
  call g:vmock_test_func_two_args('hoge', [1, 2])
  call self.assert.success()
endfunction
"}}}
let s:t = s:make_test('UAT - with - not_eq') "{{{

function! s:t.success_case()
  call vmock#mock('g:vmock_test_func_two_args').with(vmock#not_eq('hoge'), vmock#not_eq([1, 2]))
  call g:vmock_test_func_two_args('Hoge', [2, 1])
  call self.assert.success()
endfunction
"}}}
let s:t = s:make_test('UAT - with - loose_eq') "{{{

function! s:t.success_case()
  call vmock#mock('g:vmock_test_func_one_args').with(vmock#loose_eq('hoge'))
  call g:vmock_test_func_one_args('Hoge')
  call self.assert.success()
endfunction
"}}}
let s:t = s:make_test('UAT - with - loose_not_eq') "{{{

function! s:t.success_case()
  call vmock#mock('g:vmock_test_func_one_args').with(vmock#loose_not_eq('hoge'))
  call g:vmock_test_func_one_args('piyo')
  call self.assert.success()
endfunction
"}}}
