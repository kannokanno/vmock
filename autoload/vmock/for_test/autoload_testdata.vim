scriptencoding utf-8
" AUTHOR: kanno <akapanna@gmail.com>
" License: This file is placed in the public domain.

""" autoload事前読み込みテスト用

" for function_define_test.vim "{{{
function! vmock#for_test#autoload_testdata#func()
  return 10
endfunction

function! vmock#for_test#autoload_testdata#func_with_arg(a, b)
  return 20
endfunction
"}}}
