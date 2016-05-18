scriptencoding utf-8
" AUTHOR: kanno <akapanna@gmail.com>
" License: This file is placed in the public domain.
let s:save_cpo = &cpo
set cpo&vim

" ---
" <funcname>の関数定義情報を取得します。
"
" @funcname 関数名
"
" Return
"   以下の内容を持つ辞書
"     funcname: 関数名
"    arg_names: 引数名の配列。引数なしならば空配列
"         body: 処理の定義文
" ---
function! vmock#function_define#get(funcname)
  let define_string = s:get_define_string(a:funcname)
  let define_lines = split(define_string, "\n")
  " 可読性/メンテ重視で項目ごとにパースする
  return {
        \ 'funcname': a:funcname,
        \ 'arg_names': s:get_arg_names(define_lines),
        \ 'body': s:get_body(define_lines)}
endfunction

" vmock#function_define#validate()で、autoload関数を読み込むために用いられる一時ファイル
let s:autoload_tmpfile = expand('<sfile>:p:h') . '/autoload_tmpfile.vim'

" ---
" <funcname>がモック作成可能かどうか検証します。
" 不正な文字列だった場合は例外が発生します。
"
" @funcname 関数名
"
" Return 例外が発生していなければ必ず1
" ---
function! vmock#function_define#validate(funcname)
  let success = 1
  " 存在している and ロード済みの関数
  if exists('*'.a:funcname)
    return success
  endif
  " 辞書関数
  if exists(a:funcname) && (type(a:funcname) ==# type('tr'))
    return success
  endif

  " autoload関数
  if stridx(a:funcname, '#') !=# -1
    try
      " function a#foo だとautoload関数はロードされるが
      " exe 'function a#foo' だとロードがされないので、
      " 仕方なくファイルに"function <funcname>"を書きだしてsourceしている
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

" ex)
"   処理本文には行番号が付くことに注意
"
"   function FooFunc(arg)
"1      return len(a:arg) ==# 2
"   endfunction
function! s:get_define_string(funcname)
  let out = ''
  redir => out
  " ソース上でレイアウトのため"\"による改行を行なっていても、この出力ではインライン展開される
  silent! exec 'function '.a:funcname
  redir END
  return out
endfunction

" ex)
"  'function FooFunc()'              -> []
"  'function FooFunc(first)'         -> ['first']
"  'function FooFunc(first, second)' -> ['first', 'second']
function! s:get_arg_names(define_lines)
  let args = matchstr(a:define_lines[0], 'function[^(]\+(\zs[^)]\+\ze)')
  return split(args, ', ')
endfunction

function! s:get_body(define_lines)
  if empty(a:define_lines)
    return ''
  endif
  " function行とendfunction行は除外
  let body_lines = a:define_lines[1:len(a:define_lines) - 2]
  " :function Foo で出力された際の行番号とインデント空白を削除
  " TODO \sで半角空白マッチしないのはなぜだ
  let chomp_indent_space = map(body_lines, 'substitute(v:val, "^[0-9]*[ ]*", "", "")')
  return join(chomp_indent_space, "\n")
endfunction

" ---
" <define>の情報を元に、対象の関数をモック用の処理で再定義します。
"
" @define 関数情報。vmock#function_define#get()の戻り値と同等
"
" Return なし
" ---
function! vmock#function_define#override_mock(define)
  let mock_body = vmock#function_define#make_mock_body(a:define)
  call vmock#function_define#override(a:define.funcname, a:define.arg_names, mock_body)
endfunction

" ---
" <funcname>を<arg_names>および<body>の内容で再定義します。
"
" @funcname 再定義対象の関数名
" @arg_names 再定義する際の引数名
" @body 再定義する際の処理本文
"
" Return なし
" ---
function! vmock#function_define#override(funcname, arg_names, body)
  if empty(a:funcname)
    throw vmock#exception#throw('Function name required')
  endif
  execute printf("function! %s(%s)\n%s\nendfunction", a:funcname, join(a:arg_names, ','), a:body)
endfunction

" ---
" <define>の情報を元に、モック用の処理本文を作成します。
"
" @define 関数情報。vmock#function_define#get()の戻り値と同等
"
" Return モック本文
" ---
function! vmock#function_define#make_mock_body(define)
  let called_statement = printf("call vmock#mock#called('%s', %s)",
        \ a:define.funcname, s:make_called_variable(a:define.arg_names))
  let return_statement = printf("return vmock#mock#return('%s')", a:define.funcname)
  return called_statement . "\n" . return_statement
endfunction

" ex)
"  []          -> []
"  ['...']     -> 'a:000'
"  ['a']       -> [a:a]
"  ['a', 'bb'] -> [a:a,a:bb]
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
