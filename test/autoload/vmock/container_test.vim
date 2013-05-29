let s:t = vimtest#new()

function! s:t.test()
  call self.assert.equals([], vmock#container#get_mocks())

  call vmock#container#add_mock({'a': 1})
  call self.assert.equals([{'a': 1}], vmock#container#get_mocks())

  call vmock#container#add_mock({'b': 2})
  call self.assert.equals([{'a': 1}, {'b': 2}], vmock#container#get_mocks())
endfunction

