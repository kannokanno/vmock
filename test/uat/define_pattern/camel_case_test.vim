function! VMockMakeUATSuite()
  let t = themis#suite('UAT - define pattern - FooFunc')

  let t._no_args_func_name = 'VMockTestFuncNoArgs'
  let t._one_args_func_name = 'VMockTestFuncOneArgs'
  let t._two_args_func_name = 'VMockTestFuncTwoArgs'
  let t._variable_args_func_name = 'VMockTestFuncVariableArgs'

  let t._no_body_func_name = 'VMockTestFuncNoBody'
  let t._one_line_body_func_name = 'VMockTestFuncOneLineBody'
  let t._multi_line_body_func_name = 'VMockTestFuncMultiLineBody'

  let t._no_return_func_name = 'VMockTestFuncNoReturn'
  let t._exists_return_func_name = 'VMockTestFuncExistsReturn'

  function! t.before_each()
    function! VMockTestFuncNoArgs()
      return 'ORIGIN'
    endfunction
    function! VMockTestFuncOneArgs(one)
      return 'ORIGIN'
    endfunction
    function! VMockTestFuncTwoArgs(one, two)
      return 'ORIGIN'
    endfunction
    function! VMockTestFuncVariableArgs(...)
      return 'ORIGIN'
    endfunction

    function! VMockTestFuncNoBody()
    endfunction
    function! VMockTestFuncOneLineBody()
      return 100
    endfunction
    function! VMockTestFuncMultiLineBody()
      let a = 1
      let b = 2
      if a ==# b
        return 'hoge'
      endif
      return 'piyo'
    endfunction

    function! VMockTestFuncNoReturn(arg)
      let a = 1
      let b = 2
      if a ==# b
        echo 'OK!'
      endif
    endfunction
    function! VMockTestFuncExistsReturn(arg)
      let a = 1
      let b = 2
      if a ==# b
        return 'OK!'
      endif
      return 'NG'
    endfunction
  endfunction

  function! t.after_each()
    delfunction VMockTestFuncNoArgs
    delfunction VMockTestFuncOneArgs
    delfunction VMockTestFuncTwoArgs
    delfunction VMockTestFuncVariableArgs

    delfunction VMockTestFuncNoBody
    delfunction VMockTestFuncOneLineBody
    delfunction VMockTestFuncMultiLineBody

    delfunction VMockTestFuncNoReturn
    delfunction VMockTestFuncExistsReturn
  endfunction

  return t
endfunction

source <sfile>:p:h/test_statements.vim
