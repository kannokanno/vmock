" AUTHOR: kanno <akapanna@gmail.com>
" License: This file is placed in the public domain.
let s:save_cpo = &cpo
set cpo&vim

let s:mock_container = []

" TODO test

function! vmock#container#add_mock(mock)
  " TODO 型チェック
  call add(s:mock_container, a:mock)
endfunction

function! vmock#container#get_mocks()
  return deepcopy(s:mock_container)
endfunction

function! vmock#container#clear()
  for mock in s:mock_container
    call mock.teardown()
  endfor
  let s:mock_contaier = []
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
