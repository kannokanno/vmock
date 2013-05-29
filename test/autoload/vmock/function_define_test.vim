let s:t = vimtest#new('#get')

function! s:t.teardown()
  delfunction g:vmock_global_func
endfunction

function! s:t.when_no_args()
  function! g:vmock_global_func()
    return 10
  endfunction
  let define = vmock#function_define#get('g:vmock_global_func')
  call self.assert.equals('g:vmock_global_func', define.funcname)
  call self.assert.equals([], define.arg_names)
  call self.assert.equals(join([
        \ '      return 10',
        \ ], "\n"), define.body)
endfunction

" TODO 本文の行数別
" TODO 引数あり
" TODO 可変長引数


let s:t = vimtest#new('#override')

function! s:get_define_string(funcname)
  let out = ''
  redir => out
  silent! exec 'function '.a:funcname
  redir END
  return out
endfunction

function! s:t.teardown()
  delfunction g:vmock_global_func
endfunction

function! s:t.when_no_args()
  function! g:vmock_global_func()
    return 10
  endfunction
  call vmock#function_define#override('g:vmock_global_func', [], 'return 100')
  let actual = s:get_define_string('g:vmock_global_func')
  call self.assert.equals(join([
        \ '',
        \ '   function g:vmock_global_func()',
        \ '1  return 100',
        \ '   endfunction',
        \ ], "\n"), actual)
endfunction

" TODO 本文の行数別
" TODO 引数あり
" TODO 可変長引数

let s:t = vimtest#new('#build_mock_body')

function! s:t.when_no_args()
  " TODO bodyじゃなくてreturn_valueだな
  let define = {
        \ 'funcname': 'g:vmock_test_func',
        \ }

  call self.assert.equals("return vmock#mock#return('g:vmock_test_func')",
        \ vmock#function_define#build_mock_body(define))
endfunction

" TODO 本文の行数別
" TODO 引数あり
" TODO 可変長引数

