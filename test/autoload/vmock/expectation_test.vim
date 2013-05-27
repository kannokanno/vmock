let s:t = vimtest#new()

function! s:t.new()
  let expectation = vmock#expectation#new('g:hoge').return(20)
  "call self.assert.equals("Expectation", expectation.__name)
endfunction

