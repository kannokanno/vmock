let s:t = vimtest#new()

function! s:t.throw_exception()
  call self.assert.throw('VMockException:Foo Message')
  call vmock#exception#throw('Foo Message')
endfunction
