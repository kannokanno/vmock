" AUTHOR: kanno <akapanna@gmail.com>
" License: This file is placed in the public domain.
let s:save_cpo = &cpo
set cpo&vim

function! vmock#matcher#composite_with#empty_instance()
  if !exists('g:vmock_composite_with_empty_obj')
    let g:vmock_composite_with_empty_obj = s:prototype([])
    function! g:vmock_composite_with_empty_obj.match(...)
      return 1 ==# 1
    endfunction
  endif
  return g:vmock_composite_with_empty_obj
endfunction

function! vmock#matcher#composite_with#make_instance(matchers)
  if type(a:matchers) !=# type([])
    call vmock#exception#throw('arg type must be List')
  endif

  let obj = s:prototype(map(deepcopy(a:matchers), 's:convert_matcher(v:val)'))
  function! obj.match(...)
    if a:0 !=# self.__matchers_len
      let msg = printf('expected %d args, but %d args were passed.', self.__matchers_len, a:0)
      call vmock#exception#throw(msg)
    endif

    " TODO match結果の状態をどう持つか(true/falseなのか詳細かメッセージか)
    for i in range(self.__matchers_len)
      call self.__matchers[i].match(a:000[i])
    endfor
    return 1
  endfunction
  return obj
endfunction

function! s:convert_matcher(src)
  if type(a:src) ==# type({})
        \ && has_key(a:src, 'match')
        \ && (type(a:src.match) ==# type(function('tr')))
    return a:src
  endif
  return vmock#matcher#with#eq(a:src)
endfunction

function! s:prototype(matchers)
  let obj = {'__matchers': a:matchers, '__matchers_len': len(a:matchers)}
  function! obj.get_matchers()
    return self.__matchers
  endfunction
  return obj
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
