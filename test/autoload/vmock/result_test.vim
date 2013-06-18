let s:t = vimtest#new('vmock#result#make_success()') "{{{

function! s:t.make_success()
  let result = vmock#result#make_success('e-value', 'a-value')
  call self.assert.equals('e-value', result.expected)
  call self.assert.equals('a-value', result.actual)
  call self.assert.true(result.is_success)
  call self.assert.false(result.is_fail)
  call self.assert.equals('', result.message)
endfunction
"}}}
let s:t = vimtest#new('vmock#result#make_fail()') "{{{

function! s:t.make_fail()
  let result = vmock#result#make_fail('e-value', 'a-value', 'test failed')
  call self.assert.equals('e-value', result.expected)
  call self.assert.equals('a-value', result.actual)
  call self.assert.false(result.is_success)
  call self.assert.true(result.is_fail)
  call self.assert.equals('test failed', result.message)
endfunction
"}}}
