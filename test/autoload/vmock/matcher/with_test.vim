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

function! s:t.wtih_args()
  let matcher = vmock#matcher#with#any()
  for args in s:two_arg_data_provider()
    call self.assert.true(matcher.match(args[0], args[1]))
    unlet args
  endfor
endfunction


let s:t = vimtest#new('with.loose_eq()')

function! s:t.with_arg()
  for arg in s:arg_data_provider()
    let matcher = vmock#matcher#with#loose_eq(arg)
    call self.assert.true(matcher.match(arg))
    call self.assert.false(matcher.match(-1))
    call self.assert.false(matcher.match())
    unlet arg
  endfor
endfunction

function! s:t.with_two_args()
  for args in s:two_arg_data_provider()
    let matcher = vmock#matcher#with#loose_eq(args[0], args[1])
    call self.assert.true(matcher.match(args[0], args[1]))
    call self.assert.false(matcher.match(args[0], -1))
    call self.assert.false(matcher.match(-1, args[1]))
    call self.assert.false(matcher.match(args[1], args[0]))
    call self.assert.false(matcher.match(args[0]))
    unlet args
  endfor
endfunction

function! s:t.with_many_args()
  for args in s:many_arg_data_provider()
    let matcher = vmock#matcher#with#loose_eq(args[0], args[1], args[2])
    call self.assert.true(matcher.match(args[0], args[1], args[2]))
    call self.assert.false(matcher.match(args[0], -1, -1))
    call self.assert.false(matcher.match(-1, args[1], -1))
    call self.assert.false(matcher.match(-1, args[1], args[2]))
    call self.assert.false(matcher.match(args[1], args[0], args[2]))
    call self.assert.false(matcher.match(args[0]))
    unlet args
  endfor
endfunction

function! s:t.with_arg_ignorecase()
  let matcher = vmock#matcher#with#loose_eq('Abc')
  call self.assert.true(matcher.match('Abc'))
  call self.assert.true(matcher.match('abc'))
endfunction

function! s:t.with_args_ignorecase()
  let matcher = vmock#matcher#with#loose_eq('Abc', 'ZZZ')
  call self.assert.true(matcher.match('Abc', 'ZZZ'))
  call self.assert.true(matcher.match('abc', 'ZZZ'))
  call self.assert.true(matcher.match('abc', 'zzz'))
endfunction

function! s:arg_data_provider()
  return [0, 10, '', 'aaa', [], [1, 2, 3], {}, {'a': 1, 'b': 'BB'}]
endfunction

function! s:two_arg_data_provider()
  return [[10, 20], ['AAA', 'BCD'], [10, 'AAA']]
endfunction

function! s:many_arg_data_provider()
  return [[10, 20, 30], ['AAA', 'BCD', 'ZZZ'], [10, 'AAA', [1, 2]]]
endfunction

