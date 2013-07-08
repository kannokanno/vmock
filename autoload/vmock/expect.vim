" AUTHOR: kanno <akapanna@gmail.com>
" License: This file is placed in the public domain.
let s:save_cpo = &cpo
set cpo&vim

function! vmock#expect#new(funcname)
  " Vim script はreturnがない関数だと0を返すので、モックの初期return値も0にしておく
  let expect = {
        \ '__return_value': 0,
        \ '__matcher': vmock#matcher#with_group#empty_instance(),
        \ '__counter': vmock#matcher#count#default(),
        \ }

  function! expect.return(value)
    let self.__return_value = a:value
    return self
  endfunction

  function! expect.with(...)
    if self.__matcher !=# vmock#matcher#with_group#empty_instance()
      call vmock#exception#throw('with is already set up.')
    endif

    if a:0 ==# 0
      call vmock#exception#throw('Required args')
    endif
    let self.__matcher = vmock#matcher#with_group#make_instance(a:000)
    return self
  endfunction

  function! expect.once()
    return self.__update_counter(vmock#matcher#count#once())
  endfunction

  function! expect.times(count)
    return self.__update_counter(vmock#matcher#count#times(a:count))
  endfunction

  function! expect.at_least(count)
    return self.__update_counter(vmock#matcher#count#at_least(a:count))
  endfunction

  function! expect.at_most(count)
    return self.__update_counter(vmock#matcher#count#at_most(a:count))
  endfunction

  function! expect.any()
    return self.__update_counter(vmock#matcher#count#any())
  endfunction

  function! expect.never()
    return self.__update_counter(vmock#matcher#count#never())
  endfunction

  function! expect.verify()
    let counter = self.get_counter()
    if !counter.validate()
      return s:make_verify_fail_result(counter)
    endif

    let matcher = self.get_matcher()
    if !matcher.validate()
      return s:make_verify_fail_result(matcher)
    endif
    return s:make_verify_result(1, 'Success')
  endfunction

  function! expect.get_return_value()
    return self.__return_value
  endfunction

  function! expect.get_matcher()
    return self.__matcher
  endfunction

  function! expect.get_counter()
    return self.__counter
  endfunction

  function! expect.__update_counter(counter)
    if self.__counter !=# vmock#matcher#count#default()
      call vmock#exception#throw('count is already set up.')
    endif
    let self.__counter = a:counter
    return self
  endfunction

  return expect
endfunction

function! s:make_verify_result(is_success, message)
  let result = {'is_fail': a:is_success !=# 1, 'message': a:message}
  return result
endfunction

function! s:make_verify_fail_result(matcher)
  return s:make_verify_result(0, a:matcher.make_fail_message())
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

