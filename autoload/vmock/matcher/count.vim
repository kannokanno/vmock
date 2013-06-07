" AUTHOR: kanno <akapanna@gmail.com>
" License: This file is placed in the public domain.
let s:save_cpo = &cpo
set cpo&vim

function! vmock#matcher#count#once()
  let m = s:prototype('once')
  function! m.match()
    return self.__called_count ==# 1
  endfunction
  return m
endfunction

function! vmock#matcher#count#times(expected)
  let m = s:prototype('times')
  let m.__expected_count = a:expected
  function! m.match()
    return self.__called_count ==# self.__expected_count
  endfunction
  return m
endfunction

function! vmock#matcher#count#at_least(expected)
  let m = s:prototype('at_least')
  let m.__expected_count = a:expected
  function! m.match()
    return self.__expected_count <= self.__called_count
  endfunction
  return m
endfunction

function! vmock#matcher#count#at_most(expected)
  let m = s:prototype('at_most')
  let m.__expected_count = a:expected
  function! m.match()
    return self.__called_count <= self.__expected_count
  endfunction
  return m
endfunction

function! vmock#matcher#count#any()
  let m = s:prototype('any')
  function! m.match()
    return 1 == 1
  endfunction
  return m
endfunction

function! vmock#matcher#count#never()
  let m = s:prototype('never')
  function! m.match()
    return self.__called_count < 1
  endfunction
  return m
endfunction

function! s:prototype(name)
  " NOTE:オブジェクトの識別子としてnameプロパティを持つがダサい
  let counter = {'__name': a:name, '__called_count': 0}

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
