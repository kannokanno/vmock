let s:t = g:make_test()

" --args pattern "{{{
function! s:t.no_args()
  call vmock#mock(self._no_args_func_name).return('something')
  call self.assert.equals('something', call(self._no_args_func_name, []))
endfunction

function! s:t.one_args()
  call vmock#mock(self._one_args_func_name).with(vmock#eq('foo')).return(100)
  call self.assert.equals(100, call(self._one_args_func_name, ['foo']))
endfunction

function! s:t.two_args()
  call vmock#mock(self._two_args_func_name).with(vmock#loose_eq('foo'), vmock#type([])).return(200)
  call self.assert.equals(200, call(self._two_args_func_name, ['Foo', [1]]))
endfunction

function! s:t.variable_args()
  call vmock#mock(self._variable_args_func_name).with(vmock#loose_eq('foo'), vmock#any(), vmock#type(0.1)).return(300)
  call self.assert.equals(300, call(self._variable_args_func_name, ['Foo', {}, 0.5]))
endfunction
"}}}
" --body pattern "{{{
function! s:t.no_body()
  call vmock#mock(self._no_body_func_name).return('something')
  call self.assert.equals('something', call(self._no_body_func_name, []))
endfunction

function! s:t.one_line_body()
  call vmock#mock(self._one_line_body_func_name).return([1])
  call self.assert.equals([1], call(self._one_line_body_func_name, []))
endfunction

function! s:t.multi_line_body()
  call vmock#mock(self._multi_line_body_func_name).return({'aa': 10})
  call self.assert.equals({'aa': 10}, call(self._multi_line_body_func_name, []))
endfunction
"}}}
" --return pattern "{{{
function! s:t.no_return()
  call vmock#mock(self._no_return_func_name).with(vmock#eq(10))
  call call(self._no_return_func_name, [10])
  call self.assert.success()
endfunction

function! s:t.exists_return()
  call vmock#mock(self._exists_return_func_name).with(vmock#eq(10))
  call call(self._exists_return_func_name, [10])
  call self.assert.success()
endfunction
"}}}
