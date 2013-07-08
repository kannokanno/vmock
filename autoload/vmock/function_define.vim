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

let s:autoload_tmpfile = expand('<sfile>:p:h') . '/autoload_tmpfile.vim'
function! vmock#function_define#validate(funcname)
  let success = 1
  if exists('*'.a:funcname)
    return success
  endif
  " 辞書関数
  if exists(a:funcname) && (type(a:funcname) ==# type('tr'))
    return success
  endif

  if stridx(a:funcname, '#') !=# -1
    try
      " function a#foo だとautoload関数はロードされるが
      " exe 'function a#foo' だとロードがされないので、
      " 仕方なくファイルに"function funcname"を書きだしてsourceしている
      call writefile(['silent! function ' . a:funcname], s:autoload_tmpfile)
      execute 'silent source ' . s:autoload_tmpfile
    catch /.*/
      " 存在しないautoload関数だった場合など
      call vmock#exception#throw(v:exception)
    endtry
    " 再チャレンジ。初回でautoloadが未ロードだった場合のみ成功する
    if exists('*'.a:funcname)
      return success
    endif
  endif

  call vmock#exception#throw(printf('E123: Undefined function: %s', a:funcname))
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
  let body_lines = a:define_lines[1:len(a:define_lines) - 2]
  " :function Foo で出力された際の行番号とインデント空白を削除
  " TODO \sで半角空白マッチしないのはなぜだ
  let chomp_indent_space = map(body_lines, 'substitute(v:val, "^[0-9]*[ ]*", "", "")')
  return join(chomp_indent_space, "\n")
endfunction

function! vmock#function_define#override_mock(define)
  let mock_body = vmock#function_define#make_mock_body(a:define)
  call vmock#function_define#override(a:define.funcname, a:define.arg_names, mock_body)
endfunction

function! vmock#function_define#override(funcname, arg_names, body)
  if empty(a:funcname)
    throw vmock#exception#throw('Function name required')
  endif
  execute printf("function! %s(%s)\n%s\nendfunction", a:funcname, join(a:arg_names, ','), a:body)
endfunction

function! vmock#function_define#make_mock_body(define)
  let called_statement = printf("call vmock#mock#called('%s', %s)",
        \ a:define.funcname, s:make_called_variable(a:define.arg_names))
  let return_statement = printf("return vmock#mock#return('%s')", a:define.funcname)
  return called_statement . "\n" . return_statement
endfunction

function! s:make_called_variable(arg_names)
  if len(a:arg_names) < 1
    return '[]'
  endif
  if a:arg_names[0] ==# '...'
    return 'a:000'
  endif
  return '[' . join(map(deepcopy(a:arg_names), "\"a:\" . v:val"), ',') . ']'
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

