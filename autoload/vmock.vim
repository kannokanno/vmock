" AUTHOR: kanno <akapanna@gmail.com>
" License: This file is placed in the public domain.
let s:save_cpo = &cpo
set cpo&vim

function! vmock#mock()
  let mock = vmock#mock#new()
  call vmock#container#add_mock(mock)
  return mock
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
