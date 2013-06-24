" AUTHOR: kanno <akapanna@gmail.com>
" License: This file is placed in the public domain.
let s:save_cpo = &cpo
set cpo&vim

function! vmock#expect#new(funcname)
  let expect = {
        \ '__return_value': 0,
        \ '__matcher': vmock#matcher#with_group#empty_instance(),
        \ '__counter': vmock#matcher#count#any(),
        \ }

  function! expect.return(value)
    let self.__return_value = a:value
    return self
  endfunction

  function! expect.with(...)
    if a:0 ==# 0
      call vmock#exception#throw('Required args')
    endif
    let self.__matcher = vmock#matcher#with_group#make_instance(a:000)
    return self
  endfunction

  function! expect.once()
    return self.__set_counter(vmock#matcher#count#once())
  endfunction

  function! expect.times(count)
    return self.__set_counter(vmock#matcher#count#times(a:count))
  endfunction

  function! expect.at_least(count)
    return self.__set_counter(vmock#matcher#count#at_least(a:count))
  endfunction

  function! expect.at_most(count)
    return self.__set_counter(vmock#matcher#count#at_most(a:count))
  endfunction

  function! expect.any()
    return self.__set_counter(vmock#matcher#count#any())
  endfunction

  function! expect.never()
    return self.__set_counter(vmock#matcher#count#never())
  endfunction

  " TODO test
  function! expect.verify()
    let result = {'is_fail': 0}

    if !self.get_counter().validate()
      let result.is_fail = 1
      return result
    endif

    if !self.get_matcher().validate()
      let result.is_fail = 1
      return result
    endif
    return result
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

  function! expect.__set_counter(counter)
    let self.__counter = a:counter
    return self
  endfunction

  return expect
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

