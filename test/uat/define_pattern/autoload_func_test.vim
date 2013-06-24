let s:source_path = expand('<sfile>:p:h') . '/../../../autoload/vmock/for_test/testdata.vim'
function! g:make_test()
  let t = vimtest#new('UAT - define pattern - autoload#func')

  let t._no_args_func_name = 'vmock#for_test#testdata#func_no_args'
  let t._one_args_func_name = 'vmock#for_test#testdata#func_one_args'
  let t._two_args_func_name = 'vmock#for_test#testdata#func_two_args'
  let t._variable_args_func_name = 'vmock#for_test#testdata#func_variable_args'

  let t._no_body_func_name = 'vmock#for_test#testdata#func_no_body'
  let t._one_line_body_func_name = 'vmock#for_test#testdata#func_one_line_body'
  let t._multi_line_body_func_name = 'vmock#for_test#testdata#func_multi_line_body'

  let t._no_return_func_name = 'vmock#for_test#testdata#func_no_return'
  let t._exists_return_func_name = 'vmock#for_test#testdata#func_exists_return'

  function! t.startup()
    call vmock#for_test#testdata#load()
  endfunction

  function! t.setup()
    exe 'source ' . s:source_path
  endfunction

  function! t.teardown()
    delfunction vmock#for_test#testdata#func_no_args
    delfunction vmock#for_test#testdata#func_one_args
    delfunction vmock#for_test#testdata#func_two_args
    delfunction vmock#for_test#testdata#func_variable_args

    delfunction vmock#for_test#testdata#func_no_body
    delfunction vmock#for_test#testdata#func_one_line_body
    delfunction vmock#for_test#testdata#func_multi_line_body

    delfunction vmock#for_test#testdata#func_no_return
    delfunction vmock#for_test#testdata#func_exists_return
  endfunction

  return t
endfunction

source <sfile>:p:h/test_statements.vim
