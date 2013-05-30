source %:p:h/test_helper.vim
let s:provider = g:vmock_data_provider()

let s:t = g:vmock_test_new('mock of global function(g:)')

" returnで返す値を指定
function! s:t.no_args_and_return_mock_num()
  let g:vmock_testdata = s:provider.g_colon_no_args()
  call self.assert.equals(g:vmock_testdata.original_result, g:vmock_testdata.funccall())
  call vmock#mock().function(g:vmock_testdata.funcname).return(100)
  call self.assert.equals(100, g:vmock_testdata.funccall())
endfunction

" return文がなければ結果は0になる
function! s:t.no_args_and_no_return()
  let g:vmock_testdata = s:provider.g_colon_no_args_no_return()
  call self.assert.equals(g:vmock_testdata.original_result, g:vmock_testdata.funccall())
  call vmock#mock().function(g:vmock_testdata.funcname)
  " 変更されていないことの確認
  call self.assert.equals(g:vmock_testdata.original_result, g:vmock_testdata.funccall())
endfunction

" 元の定義にはreturnがなくてもreturn()でセットするとその通りに動く
function! s:t.no_args_and_no_return()
  let g:vmock_testdata = s:provider.g_colon_no_args_no_return()
  call self.assert.equals(g:vmock_testdata.original_result, g:vmock_testdata.funccall())
  call vmock#mock().function(g:vmock_testdata.funcname).return(200)
  call self.assert.equals(200, g:vmock_testdata.funccall())
endfunction
