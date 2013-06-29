let s:t = vimtest#new()

function! s:t.throw_exception()
  call self.assert.throw('VMock:Foo Message')
  call vmock#exception#throw('Foo Message')
endfunction
