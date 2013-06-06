" AUTHOR: kanno <akapanna@gmail.com>
" License: This file is placed in the public domain.
let s:save_cpo = &cpo
set cpo&vim

" NOTE: global
let s:expects = {}

function! vmock#function_define#get(funcname)
  let define_string = s:get_define_string(a:funcname)
  " NOTE: 可読性/メンテ重視で項目ごとにパースする
  let define_lines = split(define_string, "\n")
  let define = {
        \ 'funcname': a:funcname,
        \ 'arg_names': s:get_arg_names(define_lines),
        \ 'identify': '',
        \ 'body': s:get_body(define_lines)}
  return define
endfunction

function! s:get_define_string(funcname)
  let out = ''
  redir => out
  silent! exec 'function '.a:funcname
  redir END
  return out
endfunction

function! s:get_arg_names(define_lines)
  let args = substitute(a:define_lines[0], ".*function.*(\\(.*\\))", '\1', '')
  return split(args, ', ')
endfunction

function! s:get_identify(define_string)
  return ''
endfunction

function! s:get_body(define_lines)
  if empty(a:define_lines)
    return ''
  endif
  " function!行とendfunction行は除外
  " :function Foo で出力された際の行番号を削除
  " NOTE: 半角空白インデントが2つくらい余計につく
  return join(map(a:define_lines[1:len(a:define_lines) - 2], 'substitute(v:val, "^[0-9]*", "", "")'), "\n")
endfunction

function! vmock#function_define#override_mock(define)
  let mock_body = vmock#function_define#build_mock_body(a:define)
  call vmock#function_define#override(a:define.funcname, a:define.arg_names, mock_body)
endfunction
function
function! vmock#function_define#override(funcname, arg_names, body)
  execute printf("function! %s(%s)\n%s\nendfunction", a:funcname, join(a:arg_names, ','), a:body)
endfunction

function! vmock#function_define#build_mock_body(define)
  return printf("return vmock#mock#return('%s')", a:define.funcname)
endfunction

function! s:override_mock_define(define)
  let body = printf("call vmock#mock#called('%s', [%s])\n%s", a:define.funcname, join(a:define.args, ','), a:define.body)
  execute printf("function! %s(%s)\n%s\nendfunction", a:define.funcname, a:define.args, body)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

