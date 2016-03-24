scriptencoding utf-8
" AUTHOR: kanno <akapanna@gmail.com>
" License: This file is placed in the public domain.

""" テスト用autoload関数

" for this file loading "{{{
function! vmock#for_test#testdata#load()
  " do nothing
endfunction
"}}}
" for function_define_test.vim "{{{
function! vmock#for_test#testdata#func()
  return 10
endfunction
function! vmock#for_test#testdata#for_validate()
  return 20
endfunction
"}}}
" for autoload_func_test.vim "{{{
function! vmock#for_test#testdata#func_no_args()
  return 'ORIGIN'
endfunction
function! vmock#for_test#testdata#func_one_args(one)
  return 'ORIGIN'
endfunction
function! vmock#for_test#testdata#func_two_args(one, two)
  return 'ORIGIN'
endfunction
function! vmock#for_test#testdata#func_variable_args(...)
  return 'ORIGIN'
endfunction

function! vmock#for_test#testdata#func_no_body()
endfunction
function! vmock#for_test#testdata#func_one_line_body()
  return 100
endfunction
function! vmock#for_test#testdata#func_multi_line_body()
  let a = 1
  let b = 2
  if a ==# b
    return 'hoge'
  endif
  return 'piyo'
endfunction

function! vmock#for_test#testdata#func_no_return(arg)
  let a = 1
  let b = 2
  if a ==# b
    echo 'OK!'
  endif
endfunction
function! vmock#for_test#testdata#func_exists_return(arg)
  let a = 1
  let b = 2
  if a ==# b
    return 'OK!'
  endif
  return 'NG'
endfunction
"}}}
" for autoload_dict_test.vim "{{{
function! vmock#for_test#testdata#dict_init()
  let g:vmock#for_test#testdata#dict = {}

  function! g:vmock#for_test#testdata#dict.no_args()
    return 'ORIGIN'
  endfunction
  function! g:vmock#for_test#testdata#dict.one_args(one)
    return 'ORIGIN'
  endfunction
  function! g:vmock#for_test#testdata#dict.two_args(one, two)
    return 'ORIGIN'
  endfunction
  function! g:vmock#for_test#testdata#dict.variable_args(...)
    return 'ORIGIN'
  endfunction

  function! g:vmock#for_test#testdata#dict.no_body()
  endfunction
  function! g:vmock#for_test#testdata#dict.one_line_body()
    return 100
  endfunction
  function! g:vmock#for_test#testdata#dict.multi_line_body()
    let a = 1
    let b = 2
    if a ==# b
      return 'hoge'
    endif
    return 'piyo'
  endfunction

  function! g:vmock#for_test#testdata#dict.no_return(arg)
    let a = 1
    let b = 2
    if a ==# b
      echo 'OK!'
    endif
  endfunction
  function! g:vmock#for_test#testdata#dict.exists_return(arg)
    let a = 1
    let b = 2
    if a ==# b
      return 'OK!'
    endif
    return 'NG'
  endfunction
endfunction
"}}}
