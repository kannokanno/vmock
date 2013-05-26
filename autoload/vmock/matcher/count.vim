" AUTHOR: kanno <akapanna@gmail.com>
" License: This file is placed in the public domain.
let s:save_cpo = &cpo
set cpo&vim

function! vmock#matcher#count#once()
  let m = s:prototype()
  function! m.match()
    return self.__called_count ==# 1
  endfunction
  return m
endfunction

" TODO 他のカウントも

function! s:prototype()
  let counter = {'__called_count': 0}

  function! counter.called()
    let self.__called_count += 1
  endfunction

  function! counter.match()
    " this function must be override
    call vmock#exception#throw('must be override')
  endfunction

  return counter
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
