" AUTHOR: kanno <akapanna@gmail.com>
" License: This file is placed in the public domain.
let s:save_cpo = &cpo
set cpo&vim

let s:results_each_func = {}

function! vmock#results#add(funcname, result)
  if !has_key(s:results_each_func, a:funcname)
    let s:results_each_func[a:funcname] = []
  endif
  let current = s:results_each_func[a:funcname]
  call add(current, a:result)
endfunction

function! vmock#results#get_all(funcname)
  if !has_key(s:results_each_func, a:funcname)
    return []
  endif
  return s:results_each_func[a:funcname]
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
