let s:t = vimtest#new('#function')

function! s:t.setup()
  function! g:vmock_global_func()
    return 10
  endfunction
endfunction

function! s:t.teardown()
  delfunction g:vmock_global_func
endfunction

function! s:t.test()
  let mock = vmock#mock#new().function('g:vmock_global_func')
  "call self.assert.equals("Expectation", expect.__name)
endfunction
