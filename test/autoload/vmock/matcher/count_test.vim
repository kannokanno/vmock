let s:t = vimtest#new()

function! s:t.once()
  let counter = vmock#matcher#count#once()
  call self.assert.false(counter.match())
  call counter.called()
  call self.assert.true(counter.match())
endfunction

