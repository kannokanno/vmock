let s:t = vimtest#new()

function! s:t.setting_return_value()
  " 値の配列作って回せば済むな
  let expect = vmock#expect#new('g:hoge').return(20)
  call self.assert.equals(20, expect.get_return_value())

  let expect = vmock#expect#new('g:hoge').return('hoge')
  call self.assert.equals('hoge', vmock#expect#new('g:hoge').return('hoge').get_return_value())
endfunction

