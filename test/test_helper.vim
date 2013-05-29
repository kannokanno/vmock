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

  function! provider.g_colon_no_args()
    let data = s:template()
    let data.funcname = 'g:vmock_g_colon_no_args'
    let data.original_result = 10
    let data.mock_result = 100
    function! g:vmock_g_colon_no_args()
      return 10
    endfunction
    return data
  endfunction

  return provider
endfunction

function! s:template()
  let template = {}
  function! template.funccall()
    " TODO args
    return call(self.funcname, [])
  endfunction
  return template
endfunction

