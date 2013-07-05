function! g:make_test()
  let t = vimtest#new('UAT - define pattern - Funcref')

  function! t.setup()
    function! VMockTestFuncrefNoArgs()
      return 'ORIGIN'
    endfunction
    function! VMockTestFuncrefOneArgs(one)
      return 'ORIGIN'
    endfunction
    function! VMockTestFuncrefTwoArgs(one, two)
      return 'ORIGIN'
    endfunction
    function! VMockTestFuncrefVariableArgs(...)
      return 'ORIGIN'
    endfunction

    function! VMockTestFuncrefNoBody()
    endfunction
    function! VMockTestFuncrefOneLineBody()
      return 100
    endfunction
    function! VMockTestFuncrefMultiLineBody()
      let a = 1
      let b = 2
      if a ==# b
        return 'hoge'
      endif
      return 'piyo'
    endfunction

    function! VMockTestFuncrefNoReturn(arg)
      let a = 1
      let b = 2
      if a ==# b
        echo 'OK!'
      endif
    endfunction
    function! VMockTestFuncrefExistsReturn(arg)
      let a = 1
      let b = 2
      if a ==# b
        return 'OK!'
      endif
      return 'NG'
    endfunction


    " function実行時には定義されている必要があるのでここで

    let self._no_args_func_name = function('VMockTestFuncrefNoArgs')
    let self._one_args_func_name = function('VMockTestFuncrefOneArgs')
    let self._two_args_func_name = function('VMockTestFuncrefTwoArgs')
    let self._variable_args_func_name = function('VMockTestFuncrefVariableArgs')

    let self._no_body_func_name = function('VMockTestFuncrefNoBody')
    let self._one_line_body_func_name = function('VMockTestFuncrefOneLineBody')
    let self._multi_line_body_func_name = function('VMockTestFuncrefMultiLineBody')

    let self._no_return_func_name = function('VMockTestFuncrefNoReturn')
    let self._exists_return_func_name = function('VMockTestFuncrefExistsReturn')

  endfunction

  function! t.teardown()
    delfunction VMockTestFuncrefNoArgs
    delfunction VMockTestFuncrefOneArgs
    delfunction VMockTestFuncrefTwoArgs
    delfunction VMockTestFuncrefVariableArgs

    delfunction VMockTestFuncrefNoBody
    delfunction VMockTestFuncrefOneLineBody
    delfunction VMockTestFuncrefMultiLineBody

    delfunction VMockTestFuncrefNoReturn
    delfunction VMockTestFuncrefExistsReturn
  endfunction

  return t
endfunction

source <sfile>:p:h/test_statements.vim
