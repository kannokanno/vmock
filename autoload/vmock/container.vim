" AUTHOR: kanno <akapanna@gmail.com>
" License: This file is placed in the public domain.
let s:save_cpo = &cpo
set cpo&vim

function! vmock#container#add_mock(mock)
  " s:mock_container.add(mock)
endfunction

function! vmock#container#get_mocks()
  " return deepcopy(s:mock_contaier)
endfunction

function! vmock#container#clear()
  " for mock in s:mock_container
  "   call mock.teardown()
  " endfor
  " s:mock_contaier = []
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

