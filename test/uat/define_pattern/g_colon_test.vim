function! g:make_test()
  let t = vimtest#new('UAT - define pattern - g:foo_func')

  let t._no_args_func_name = 'g:vmock_test_func_no_args'
  let t._one_args_func_name = 'g:vmock_test_func_one_args'
  let t._two_args_func_name = 'g:vmock_test_func_two_args'
  let t._variable_args_func_name = 'g:vmock_test_func_variable_args'

  let t._no_body_func_name = 'g:vmock_test_func_no_body'
  let t._one_line_body_func_name = 'g:vmock_test_func_one_line_body'
  let t._multi_line_body_func_name = 'g:vmock_test_func_multi_line_body'

  let t._no_return_func_name = 'g:vmock_test_func_no_return'
  let t._exists_return_func_name = 'g:vmock_test_func_exists_return'

  function! t.setup()
    function! g:vmock_test_func_no_args()
      return 'ORIGIN'
    endfunction
    function! g:vmock_test_func_one_args(one)
      return 'ORIGIN'
    endfunction
    function! g:vmock_test_func_two_args(one, two)
      return 'ORIGIN'
    endfunction
    function! g:vmock_test_func_variable_args(...)
      return 'ORIGIN'
    endfunction

    function! g:vmock_test_func_no_body()
    endfunction
    function! g:vmock_test_func_one_line_body()
      return 100
    endfunction
    function! g:vmock_test_func_multi_line_body()
      let a = 1
      let b = 2
      if a ==# b
        return 'hoge'
      endif
      return 'piyo'
    endfunction

    function! g:vmock_test_func_no_return(arg)
      let a = 1
      let b = 2
      if a ==# b
        echo 'OK!'
      endif
    endfunction
    function! g:vmock_test_func_exists_return(arg)
      let a = 1
      let b = 2
      if a ==# b
        return 'OK!'
      endif
      return 'NG'
    endfunction
  endfunction

  function! t.teardown()
    delfunction g:vmock_test_func_no_args
    delfunction g:vmock_test_func_one_args
    delfunction g:vmock_test_func_two_args
    delfunction g:vmock_test_func_variable_args

    delfunction g:vmock_test_func_no_body
    delfunction g:vmock_test_func_one_line_body
    delfunction g:vmock_test_func_multi_line_body

    delfunction g:vmock_test_func_no_return
    delfunction g:vmock_test_func_exists_return
  endfunction

  return t
endfunction

source <sfile>:p:h/test_statements.vim
