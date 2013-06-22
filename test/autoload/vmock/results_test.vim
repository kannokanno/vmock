let s:t = vimtest#new('vmock#results#add and get()') "{{{

function! s:t.success()
  let funcname = 'g:vmock_test_func'
  call self.assert.equals([], vmock#results#get_all(funcname))

  call vmock#results#add(funcname, s:result_success_stub(1))
  let actual = vmock#results#get_all(funcname)
  call self.assert.equals(1, len(actual))
  call self.assert.equals(1, actual[0].id)

  call vmock#results#add(funcname, s:result_success_stub(2))
  let actual = vmock#results#get_all(funcname)
  call self.assert.equals(2, len(actual))
  call self.assert.equals(1, actual[0].id)
  call self.assert.equals(2, actual[1].id)

  " 関数名ごとに保持されていることの確認
  let another_funcname = 'g:vmock_test_another_func'
  call vmock#results#add(another_funcname, s:result_success_stub(3))
  let actual = vmock#results#get_all(funcname)
  call self.assert.equals(2, len(actual))
  call self.assert.equals(1, actual[0].id)
  call self.assert.equals(2, actual[1].id)

  let actual = vmock#results#get_all(another_funcname)
  call self.assert.equals(1, len(actual))
  call self.assert.equals(3, actual[0].id)
endfunction
"}}}
let s:t = vimtest#new('vmock#results#is_success()') "{{{

function! s:t.return_true_when_all_success()
  let funcname = 'g:vmock_test_func'

  call vmock#results#add(funcname, s:result_success_stub(1))
  call vmock#results#add(funcname, s:result_success_stub(2))
  call vmock#results#add(funcname, s:result_success_stub(3))

  call self.assert.true(vmock#results#is_success(funcname))
endfunction

function! s:t.return_false_when_failed_at_least_once()
  let funcname = 'g:vmock_test_func'

  call vmock#results#add(funcname, s:result_success_stub(1))
  call vmock#results#add(funcname, s:result_fail_stub(2))
  call vmock#results#add(funcname, s:result_success_stub(3))

  call self.assert.false(vmock#results#is_success(funcname))
endfunction

function! s:t.return_true_when_empty()
  let funcname = 'g:vmock_test_func'
  call self.assert.true(vmock#results#is_success(funcname))
endfunction

function! s:t.exception_when_not_exists_func()
  let funcname = 'g:vmock_not_exists_func'
  call self.assert.throw('VMockException:It is a function not existing. [g:vmock_not_exists_func]')
  call vmock#results#is_success(funcname)
endfunction
"}}}


" おそらくメッセージ形成などで必要になる
" TODO 成功マッチ一覧
" TODO 失敗マッチ一覧
" TODO 期待する回数
" TODO 実際の回数


function! s:result_success_stub(id)
  return s:result_stub(a:id, 1)
endfunction

function! s:result_fail_stub(id)
  return s:result_stub(a:id, 0)
endfunction

function! s:result_stub(id, is_success)
  return {'id': a:id, 'is_success': a:is_success}
endfunction
