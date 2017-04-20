" このファイルは実際のテストファイルからsourceされる
" source元で定義したVMockMakeUATSuite()を呼び、戻り値のtest suiteに対して共通のテストを行う

let s:t = VMockMakeUATSuite()
let s:assert = themis#helper('assert')

" === 引数のケース ===
" 引数なし
function! s:t.no_args()
  call vmock#mock(self._no_args_func_name).return('something')
  call s:assert.equals('something', call(self._no_args_func_name, []))
endfunction

" 引数1つ
function! s:t.one_args()
  call vmock#mock(self._one_args_func_name).with(vmock#eq('foo')).return(100)
  call s:assert.equals(100, call(self._one_args_func_name, ['foo']))
endfunction

" 引数2つ
function! s:t.two_args()
  call vmock#mock(self._two_args_func_name).with(vmock#loose_eq('foo'), vmock#type([])).return(200)
  call s:assert.equals(200, call(self._two_args_func_name, ['Foo', [1]]))
endfunction

" 可変長引数
function! s:t.variable_args()
  call vmock#mock(self._variable_args_func_name).with(vmock#loose_eq('foo'), vmock#any(), vmock#type(0.1)).return(300)
  call s:assert.equals(300, call(self._variable_args_func_name, ['Foo', {}, 0.5]))
endfunction

" === 元定義の関数の内容によるケース ===
" 関数の中身なし
function! s:t.no_body()
  call vmock#mock(self._no_body_func_name).return('something')
  call s:assert.equals('something', call(self._no_body_func_name, []))
endfunction

" 関数の中身が1行
function! s:t.one_line_body()
  call vmock#mock(self._one_line_body_func_name).return([1])
  call s:assert.equals([1], call(self._one_line_body_func_name, []))
endfunction

" 関数の中身が複数行
function! s:t.multi_line_body()
  call vmock#mock(self._multi_line_body_func_name).return({'aa': 10})
  call s:assert.equals({'aa': 10}, call(self._multi_line_body_func_name, []))
endfunction

" 関数の中身が戻り値なし
function! s:t.no_return()
  call vmock#mock(self._no_return_func_name).with(vmock#eq(10))
  call call(self._no_return_func_name, [10])

  " ここに到達すればOK
  call s:assert.true(1)
endfunction

" 関数の中身が戻り値あり
function! s:t.exists_return()
  call vmock#mock(self._exists_return_func_name).with(vmock#eq(10))
  call call(self._exists_return_func_name, [10])

  " ここに到達すればOK
  call s:assert.true(1)
endfunction


" === サンプルのフロー ===
function! s:t.call_by_variable()
  let mock = vmock#mock(self._one_args_func_name)
  call mock.with(vmock#eq('foo'))
  call mock.return(100)
  call s:assert.equals(100, call(self._one_args_func_name, ['foo']))

  " ここに到達すればOK
  call s:assert.true(1)
endfunction
function! s:t.multiple_mock()
  call vmock#mock(self._one_args_func_name).with(vmock#eq('foo')).return(100)
  call vmock#mock(self._multi_line_body_func_name).return({'aa': 10})

  call s:assert.equals(100, call(self._one_args_func_name, ['foo']))
  call s:assert.equals({'aa': 10}, call(self._multi_line_body_func_name, []))
endfunction
