let s:t = vimtest#new()

function! s:t.once()
  let counter = vmock#matcher#count#once()
  call self.assert.false(counter.match())
  call counter.called()
  call self.assert.true(counter.match())
endfunction

function! s:t.times()
  let counter = vmock#matcher#count#times(3)
  call self.assert.false(counter.match())
  call counter.called()
  call self.assert.false(counter.match())
  call counter.called()
  call self.assert.false(counter.match())
  call counter.called()
  call self.assert.true(counter.match())
endfunction

function! s:t.at_least()
  let counter = vmock#matcher#count#at_least(2)
  call self.assert.false(counter.match())
  call counter.called()
  call self.assert.false(counter.match())
  call counter.called()
  call self.assert.true(counter.match())
  call counter.called()
  call self.assert.true(counter.match())
endfunction

function! s:t.at_most()
  let counter = vmock#matcher#count#at_most(2)
  call self.assert.true(counter.match())
  call counter.called()
  call self.assert.true(counter.match())
  call counter.called()
  call self.assert.true(counter.match())
  call counter.called()
  call self.assert.false(counter.match())
  call counter.called()
  call self.assert.false(counter.match())
  call counter.called()
endfunction

function! s:t.any()
  let counter = vmock#matcher#count#any()
  call self.assert.true(counter.match())
  call counter.called()
  call self.assert.true(counter.match())
  call counter.called()
  call self.assert.true(counter.match())
  call counter.called()
  call self.assert.true(counter.match())
  call counter.called()
endfunction

function! s:t.never()
  let counter = vmock#matcher#count#never()
  call self.assert.true(counter.match())
  call counter.called()
  call self.assert.false(counter.match())
  call counter.called()
  call self.assert.false(counter.match())
  call counter.called()
  call self.assert.false(counter.match())
  call counter.called()
endfunction

