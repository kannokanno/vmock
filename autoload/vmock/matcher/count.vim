" AUTHOR: kanno <akapanna@gmail.com>
" License: This file is placed in the public domain.
let s:save_cpo = &cpo
set cpo&vim

" TODO make_fail_message test -> UAT書いているからいらないか...?

function! vmock#matcher#count#once()
  let m = s:prototype('once')
  let m.__expected_count = 1
  function! m.validate()
    return self.__called_count ==# self.__expected_count
  endfunction

  function! m.make_fail_message()
    return printf('expected: only once. but received: %d times.', self.__called_count)
  endfunction
  return m
endfunction

function! vmock#matcher#count#times(expected)
  let m = s:prototype('times')
  let m.__expected_count = a:expected
  function! m.validate()
    return self.__called_count ==# self.__expected_count
  endfunction

  function! m.make_fail_message()
    return printf('expected: exactly %d times. but received: %d times.', self.__expected_count, self.__called_count)
  endfunction
  return m
endfunction

function! vmock#matcher#count#any()
  let m = s:prototype('any')
  function! m.validate()
    return 1 == 1
  endfunction
  return m
endfunction

function! vmock#matcher#count#never()
  let m = s:prototype('never')
  function! m.validate()
    return self.__called_count < 1
  endfunction

  function! m.make_fail_message()
    return printf('expected: never call. but received: %d times.', self.__called_count)
  endfunction
  return m
endfunction

function! vmock#matcher#count#at_least(expected)
  let m = s:prototype('at_least')
  let m.__expected_count = a:expected
  function! m.validate()
    return self.__expected_count <= self.__called_count
  endfunction

  function! m.make_fail_message()
    return printf('expected: at least %d times. but received: %d times.', self.__expected_count, self.__called_count)
  endfunction
  return m
endfunction

function! vmock#matcher#count#at_most(expected)
  let m = s:prototype('at_most')
  let m.__expected_count = a:expected
  function! m.validate()
    return self.__called_count <= self.__expected_count
  endfunction

  function! m.make_fail_message()
    return printf('expected: at most %d times. but received: %d times.', self.__expected_count, self.__called_count)
  endfunction
  return m
endfunction

let s:default_counter = {}
function! vmock#matcher#count#default()
  if empty(s:default_counter)
    let s:default_counter = vmock#matcher#count#any()
  endif
  return s:default_counter
endfunction

function! s:prototype(name)
  " NOTE:オブジェクトの識別子としてnameプロパティを持つがダサい
  let counter = {'__name': a:name, '__called_count': 0}

  function! counter.called()
    let self.__called_count += 1
  endfunction

  function! counter.validate()
    " this function must be override
    call vmock#exception#throw('must be override')
  endfunction

  function! counter.make_fail_message()
    " empty message
    return ''
  endfunction
  return counter
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
