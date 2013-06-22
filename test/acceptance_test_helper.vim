function! g:vmock_test_new(name)
  let t = vimtest#new(a:name)
  function! t.teardown()
    call vmock#container#clear()

    " クリア後は定義が戻っていること
    let expected = g:vmock_testdata.original_result
    let actual = g:vmock_testdata.funccall()
    if expected ==# actual
      " NOTE: delfunction s:data.funcname とするとエラーになる
      execute 'delfunction ' . g:vmock_testdata.funcname
    else
      throw printf('failed rollback. expected:%s but actual:%s', expected, actual)
    endif
  endfunction

  return t
endfunction

function! g:vmock_data_provider()
  let provider = {}

  " 引数なし 戻り値あり
  function! provider.g_colon_no_args()
    function! g:vmock_g_colon_no_args()
      return 10
    endfunction
    return s:template('g:vmock_g_colon_no_args', [])
  endfunction

  " 引数なし 戻り値なし
  function! provider.g_colon_no_args_no_return()
    function! g:vmock_g_colon_no_args_no_return()
    endfunction
    return s:template('g:vmock_g_colon_no_args_no_return', [])
  endfunction

  return provider
endfunction

function! s:template(funcname, args_names)
  let template = {}
  let template.funcname = a:funcname
  let template.original_result = call(a:funcname, a:args_names)
  function! template.funccall()
    " TODO args
    return call(self.funcname, [])
  endfunction
  return template
endfunction

