" AUTHOR: kanno <akapanna@gmail.com>
" License: This file is placed in the public domain.
let s:save_cpo = &cpo
set cpo&vim

function! vmock#listener#vimtest#teardown()
  " TODO vimtest側の対応
  " vimtest側の仕様によって挙動は変わる
    " アサーションカウント
    " エラーなのかfalseなのか
  "try
  "  for mock in vmock#container#get_mocks()
  "    call mock.verify()
  "  endfor
  "finally
  "  call vmock#container#clear()
  "endtry
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

