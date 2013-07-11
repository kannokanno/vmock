" AUTHOR: kanno <akapanna@gmail.com>
" License: This file is placed in the public domain.
let s:save_cpo = &cpo
set cpo&vim

function! vmock#mock(func)
  try
    let funcname = s:convert_funcref_to_funcname(a:func)
    call vmock#function_define#validate(funcname)
  catch
    throw v:exception
  endtry

  let mock = vmock#mock#new()
  let expect = mock.func(funcname)
  call vmock#container#add_mock(funcname, mock)
  return expect
endfunction

" TODO function_defineに移動?
function! s:convert_funcref_to_funcname(func)
  if type(a:func) !=# type('tr')
    " funcrefはstring()にかけると function('tr') という文字列になる
    return substitute(string(a:func), "function('\\(.*\\)')", '\1', '')
  endif
  return a:func
endfunction

function! vmock#verify()
  let event = {}
  function! event.on_success()
    " nothing
  endfunction

  function! event.on_failure(message)
    call vmock#exception#throw(a:message)
  endfunction
  call vmock#verify_with_event(event)
endfunction

function! vmock#verify_with_event(event)
  let success = 1
  for mock in vmock#container#get_mocks()
    let result = mock.verify()
    if result.is_fail
      let success = 0
      call a:event.on_failure(result.message)
    endif
  endfor

  if success
    call a:event.on_success()
  endif
endfunction

" matcher shortcurt api's"{{{
function! vmock#any()
  return vmock#matcher#with#any()
endfunction

function! vmock#eq(expected)
  return vmock#matcher#with#eq(a:expected)
endfunction

function! vmock#not_eq(expected)
  return vmock#matcher#with#not_eq(a:expected)
endfunction

function! vmock#loose_not_eq(expected)
  return vmock#matcher#with#loose_not_eq(a:expected)
endfunction

function! vmock#loose_eq(expected)
  return vmock#matcher#with#loose_eq(a:expected)
endfunction

function! vmock#type(expected)
  return vmock#matcher#with#type(a:expected)
endfunction

function! vmock#not_type(expected)
  return vmock#matcher#with#not_type(a:expected)
endfunction

function! vmock#has(expected)
  return vmock#matcher#with#has(a:expected)
endfunction

function! vmock#not_has(expected)
  return vmock#matcher#with#not_has(a:expected)
endfunction

function! vmock#custom(expected)
  return vmock#matcher#with#custom(a:expected)
endfunction
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo
