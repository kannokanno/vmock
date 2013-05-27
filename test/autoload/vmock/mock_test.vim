let s:t = vimtest#new()

function! s:t.new()
  let expect = vmock#expect#new('g:hoge')
  "call self.assert.equals("Expectation", expect.__name)
endfunction
