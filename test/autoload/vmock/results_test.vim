let s:t = vimtest#new('vmock#results#add and get()') "{{{

" すべてOKか
" 1つでも失敗したか
" 成功マッチ一覧
" 失敗マッチ一覧
" 期待する回数
" 実際の回数
function! s:t.success()
  let funcname = 'g:vmock_test_func'
  call self.assert.equals([], vmock#results#get_all(funcname))

  call vmock#results#add(funcname, s:result_stub(1))
  let actual = vmock#results#get_all(funcname)
  call self.assert.equals(1, len(actual))
  call self.assert.equals(1, actual[0].id)

  call vmock#results#add(funcname, s:result_stub(2))
  let actual = vmock#results#get_all(funcname)
  call self.assert.equals(2, len(actual))
  call self.assert.equals(1, actual[0].id)
  call self.assert.equals(2, actual[1].id)

  " 関数名ごとに保持されていることの確認
  let another_funcname = 'g:vmock_test_another_func'
  call vmock#results#add(another_funcname, s:result_stub(3))
  let actual = vmock#results#get_all(funcname)
  call self.assert.equals(2, len(actual))
  call self.assert.equals(1, actual[0].id)
  call self.assert.equals(2, actual[1].id)

  let actual = vmock#results#get_all(another_funcname)
  call self.assert.equals(1, len(actual))
  call self.assert.equals(3, actual[0].id)
endfunction
"}}}

function! s:result_stub(id)
  return {'id': a:id}
endfunction
