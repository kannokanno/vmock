scriptencoding utf-8
" AUTHOR: kanno <akapanna@gmail.com>
" License: This file is placed in the public domain.
let s:save_cpo = &cpo
set cpo&vim

function! vmock#exception#throw(message)
  throw 'VMock:' . a:message
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
