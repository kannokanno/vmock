let s:t = vimtest#new('with.any()')

function! s:t.no_arg()
  let matcher = vmock#matcher#with#any()
  call self.assert.true(matcher.match())
endfunction

function! s:t.wtih_arg()
  let matcher = vmock#matcher#with#any()
  for arg in s:arg_data_provider()
    call self.assert.true(matcher.match(arg))
    unlet arg
  endfor
endfunction


let s:t = vimtest#new('with.eq()')

function! s:t.with_arg()
  for arg in s:arg_data_provider()
    let matcher = vmock#matcher#with#eq(arg)
    call self.assert.true(matcher.match(arg))
    call self.assert.false(matcher.match(-1))
    unlet arg
  endfor
endfunction

function! s:t.with_arg_ignorecase()
  let matcher = vmock#matcher#with#eq('Abc')
  call self.assert.true(matcher.match('Abc'))
  call self.assert.false(matcher.match('abc'))
endfunction


let s:t = vimtest#new('with.not_eq()')

function! s:t.with_arg()
  for arg in s:arg_data_provider()
    let matcher = vmock#matcher#with#not_eq(arg)
    call self.assert.false(matcher.match(arg))
    call self.assert.true(matcher.match(-1))
    unlet arg
  endfor
endfunction

function! s:t.with_arg_ignorecase()
  let matcher = vmock#matcher#with#not_eq('Abc')
  call self.assert.false(matcher.match('Abc'))
  call self.assert.true(matcher.match('abc'))
endfunction


let s:t = vimtest#new('with.loose_eq()')

function! s:t.with_arg()
  for arg in s:arg_data_provider()
    let matcher = vmock#matcher#with#loose_eq(arg)
    call self.assert.true(matcher.match(arg))
    call self.assert.false(matcher.match(-1))
    unlet arg
  endfor
endfunction

function! s:t.with_arg_ignorecase()
  let matcher = vmock#matcher#with#loose_eq('Abc')
  call self.assert.true(matcher.match('Abc'))
  call self.assert.true(matcher.match('abc'))
endfunction


let s:t = vimtest#new('with.loose_not_eq()')

function! s:t.with_arg()
  for arg in s:arg_data_provider()
    let matcher = vmock#matcher#with#loose_not_eq(arg)
    call self.assert.false(matcher.match(arg))
    call self.assert.true(matcher.match(-1))
    unlet arg
  endfor
endfunction

function! s:t.with_arg_ignorecase()
  let matcher = vmock#matcher#with#loose_not_eq('Abc')
  call self.assert.false(matcher.match('Abc'))
  call self.assert.false(matcher.match('abc'))
endfunction


function! s:arg_data_provider()
  return [0, 10, '', 'aaa', [], [1, 2, 3], {}, {'a': 1, 'b': 'BB'}]
endfunction
