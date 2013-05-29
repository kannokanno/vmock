source %:p:h/test_helper.vim
let s:provider = g:vmock_data_provider()

let s:t = g:vmock_test_new('mock of global function(g:)')

function! s:t.no_args_and_return_mock()
  let g:vmock_testdata = s:provider.g_colon_no_args()
  call self.assert.equals(g:vmock_testdata.original_result, g:vmock_testdata.funccall())
  call vmock#mock().function(g:vmock_testdata.funcname).return(g:vmock_testdata.mock_result)
  call self.assert.equals(g:vmock_testdata.mock_result, g:vmock_testdata.funccall())
endfunction
