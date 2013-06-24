function! g:make_test()
  let t = vimtest#new('UAT - define pattern - g:dict.func')

  let t._no_args_func_name = 'g:vmock_test_dict.no_args'
  let t._one_args_func_name = 'g:vmock_test_dict.one_args'
  let t._two_args_func_name = 'g:vmock_test_dict.two_args'
  let t._variable_args_func_name = 'g:vmock_test_dict.variable_args'

  let t._no_body_func_name = 'g:vmock_test_dict.no_body'
  let t._one_line_body_func_name = 'g:vmock_test_dict.one_line_body'
  let t._multi_line_body_func_name = 'g:vmock_test_dict.multi_line_body'

  let t._no_return_func_name = 'g:vmock_test_dict.no_return'
  let t._exists_return_func_name = 'g:vmock_test_dict.exists_return'

  function! t.setup()
    let g:vmock_test_dict = {}

    function! g:vmock_test_dict.no_args()
      return 'ORIGIN'
    endfunction
    function! g:vmock_test_dict.one_args(one)
      return 'ORIGIN'
    endfunction
    function! g:vmock_test_dict.two_args(one, two)
      return 'ORIGIN'
    endfunction
    function! g:vmock_test_dict.variable_args(...)
      return 'ORIGIN'
    endfunction

    function! g:vmock_test_dict.no_body()
    endfunction
    function! g:vmock_test_dict.one_line_body()
      return 100
    endfunction
    function! g:vmock_test_dict.multi_line_body()
      let a = 1
      let b = 2
      if a ==# b
        return 'hoge'
      endif
      return 'piyo'
    endfunction

    function! g:vmock_test_dict.no_return(arg)
      let a = 1
      let b = 2
      if a ==# b
        echo 'OK!'
      endif
    endfunction
    function! g:vmock_test_dict.exists_return(arg)
      let a = 1
      let b = 2
      if a ==# b
        return 'OK!'
      endif
      return 'NG'
    endfunction
  endfunction

  function! t.teardown()
    unlet g:vmock_test_dict
  endfunction

  return t
endfunction

" TODO 辞書関数はtest_statementsをそのまま使えないのでコピペ
"   理由1:callの引数には辞書関数名は使えず、辞書関数名の値をスクリプトローカル変数にするなどのハックが必要
"   理由2:上記1を対応しても、vmock#mock()がFuncrefを受け付けないので実行時エラーになる
"source <sfile>:p:h/test_statements.vim

let s:t = g:make_test()

" --args pattern "{{{
function! s:t.no_args()
  call vmock#mock(self._no_args_func_name).return('something')
  call self.assert.equals('something', g:vmock_test_dict.no_args())
endfunction

function! s:t.one_args()
  call vmock#mock(self._one_args_func_name).with(vmock#eq('foo')).return(100)
  call self.assert.equals(100, g:vmock_test_dict.one_args('foo'))
endfunction

function! s:t.two_args()
  call vmock#mock(self._two_args_func_name).with(vmock#loose_eq('foo'), vmock#type([])).return(200)
  call self.assert.equals(200, g:vmock_test_dict.two_args('Foo', [1]))
endfunction

function! s:t.variable_args()
  call vmock#mock(self._variable_args_func_name).with(vmock#loose_eq('foo'), vmock#any(), vmock#type(0.1)).return(300)
  call self.assert.equals(300, g:vmock_test_dict.variable_args('Foo', {}, 0.5))
endfunction
"}}}
" --body pattern "{{{
function! s:t.no_body()
  call vmock#mock(self._no_body_func_name).return('something')
  call self.assert.equals('something', g:vmock_test_dict.no_body())
endfunction

function! s:t.one_line_body()
  call vmock#mock(self._one_line_body_func_name).return([1])
  call self.assert.equals([1], g:vmock_test_dict.one_line_body())
endfunction

function! s:t.multi_line_body()
  call vmock#mock(self._multi_line_body_func_name).return({'aa': 10})
  call self.assert.equals({'aa': 10}, g:vmock_test_dict.multi_line_body())
endfunction
"}}}
" --return pattern "{{{
function! s:t.no_return()
  call vmock#mock(self._no_return_func_name).with(vmock#eq(10))
  call g:vmock_test_dict.no_return(10)
  call self.assert.success()
endfunction

function! s:t.exists_return()
  call vmock#mock(self._exists_return_func_name).with(vmock#eq(10))
  call g:vmock_test_dict.exists_return(10)
  call self.assert.success()
endfunction
"}}}
