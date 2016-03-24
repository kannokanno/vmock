scriptencoding utf-8
" AUTHOR: kanno <akapanna@gmail.com>
" License: This file is placed in the public domain.
let s:save_cpo = &cpo
set cpo&vim

" モックのフックや元関数の復元などで参照するために
" スクリプトローカルスコープに保存する必要がある
let s:mock_container = {}

" ---
" <funcname>に対応する<mock>を追加します。
"
" @funcname 関数名
" @funcname モックオブジェクト
"
" Return なし
" ---
function! vmock#container#add_mock(funcname, mock)
  if !has_key(a:mock, 'verify')
    call vmock#exception#throw('mock obj must be implement verify()')
  elseif s:not_function(a:mock.verify)
    call vmock#exception#throw('verfiy must be function')
  endif
  let s:mock_container[a:funcname] = a:mock
endfunction

function! vmock#container#get_mocks()
  return deepcopy(values(s:mock_container))
endfunction

function! vmock#container#clear()
  for mock in values(s:mock_container)
    if has_key(mock, 'teardown') && s:is_function(mock.teardown)
      call mock.teardown()
    endif
  endfor
  let s:mock_container = {}
endfunction

function! s:is_function(obj)
  return type(a:obj) ==# type(function('tr'))
endfunction

function! s:not_function(obj)
  return !s:is_function(a:obj)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
