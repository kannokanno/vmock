let s:t = vimtest#new()

function! s:t.new()
  let expect = vmock#expect#new('g:hoge').return(20)
  "call self.assert.equals("Expectation", expect.__name)
endfunction

