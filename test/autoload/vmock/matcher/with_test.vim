let s:t = vimtest#new('vmock#with#any()')

function! s:t.no_arg()
  let matcher = vmock#matcher#with#any()
  call self.assert.true(matcher.match())
endfunction

function! s:t.wtih_arg()
  let matcher = vmock#matcher#with#any()
  for Arg in s:arg_data_provider()
    call self.assert.true(matcher.match(Arg))
    unlet Arg
  endfor
endfunction


let s:t = vimtest#new('vmock#with#eq()')

function! s:t.match()
  for Arg in s:arg_data_provider()
    let matcher = vmock#matcher#with#eq(Arg)
    call self.assert.true(matcher.match(Arg))
    call self.assert.false(matcher.match(-1))
    unlet Arg
  endfor
endfunction

function! s:t.match_ignorecase()
  let matcher = vmock#matcher#with#eq('Abc')
  call self.assert.true(matcher.match('Abc'))
  call self.assert.false(matcher.match('abc'))
endfunction


let s:t = vimtest#new('vmock#with#not_eq()')

function! s:t.match()
  for Arg in s:arg_data_provider()
    let matcher = vmock#matcher#with#not_eq(Arg)
    call self.assert.false(matcher.match(Arg))
    call self.assert.true(matcher.match(-1))
    unlet Arg
  endfor
endfunction

function! s:t.match_ignorecase()
  let matcher = vmock#matcher#with#not_eq('Abc')
  call self.assert.false(matcher.match('Abc'))
  call self.assert.true(matcher.match('abc'))
endfunction


let s:t = vimtest#new('vmock#with#loose_eq()')

function! s:t.match()
  for Arg in s:arg_data_provider()
    let matcher = vmock#matcher#with#loose_eq(Arg)
    call self.assert.true(matcher.match(Arg))
    call self.assert.false(matcher.match(-1))
    unlet Arg
  endfor
endfunction

function! s:t.match_ignorecase()
  let matcher = vmock#matcher#with#loose_eq('Abc')
  call self.assert.true(matcher.match('Abc'))
  call self.assert.true(matcher.match('abc'))
endfunction


let s:t = vimtest#new('vmock#with#loose_not_eq()')

function! s:t.match()
  for Arg in s:arg_data_provider()
    let matcher = vmock#matcher#with#loose_not_eq(Arg)
    call self.assert.false(matcher.match(Arg))
    call self.assert.true(matcher.match(-1))
    unlet Arg
  endfor
endfunction

function! s:t.match_ignorecase()
  let matcher = vmock#matcher#with#loose_not_eq('Abc')
  call self.assert.false(matcher.match('Abc'))
  call self.assert.false(matcher.match('abc'))
endfunction


let s:t = vimtest#new('vmock#with#type()')

function! s:t.match()
  call self.assert.true(vmock#matcher#with#type(1).match(0))
  call self.assert.true(vmock#matcher#with#type(1).match(100))
  call self.assert.true(vmock#matcher#with#type('').match(''))
  call self.assert.true(vmock#matcher#with#type('').match('hoge'))
  call self.assert.true(vmock#matcher#with#type([]).match([]))
  call self.assert.true(vmock#matcher#with#type([]).match([1, 2]))
  call self.assert.true(vmock#matcher#with#type({}).match({}))
  call self.assert.true(vmock#matcher#with#type({}).match({'a':1}))
  call self.assert.true(vmock#matcher#with#type(function('tr')).match(function('len')))
  call self.assert.true(vmock#matcher#with#type(function('tr')).match(function('vmock#mock')))
  call self.assert.true(vmock#matcher#with#type(0.0).match(0.0))
  call self.assert.true(vmock#matcher#with#type(0.0).match(2.1))

  call self.assert.false(vmock#matcher#with#type({}).match(10))
endfunction

function! s:t.not_match()
  call self.assert.false(vmock#matcher#with#not_type(1).match(0))
  call self.assert.false(vmock#matcher#with#not_type(1).match(100))
  call self.assert.false(vmock#matcher#with#not_type('').match(''))
  call self.assert.false(vmock#matcher#with#not_type('').match('hoge'))
  call self.assert.false(vmock#matcher#with#not_type([]).match([]))
  call self.assert.false(vmock#matcher#with#not_type([]).match([1, 2]))
  call self.assert.false(vmock#matcher#with#not_type({}).match({}))
  call self.assert.false(vmock#matcher#with#not_type({}).match({'a':1}))
  call self.assert.false(vmock#matcher#with#not_type({}).match({'a':1}))
  call self.assert.false(vmock#matcher#with#not_type(function('tr')).match(function('len')))
  call self.assert.false(vmock#matcher#with#not_type(function('tr')).match(function('vmock#mock')))
  call self.assert.false(vmock#matcher#with#not_type(0.0).match(0.0))
  call self.assert.false(vmock#matcher#with#not_type(0.0).match(2.1))

  call self.assert.true(vmock#matcher#with#not_type({}).match(10))
endfunction


let s:t = vimtest#new('vmock#with#has()')

function! s:t.match_invalid_type()
  let matcher = vmock#matcher#with#has('key')
  call self.assert.false(matcher.match(1))
  call self.assert.false(matcher.match('hoge'))
  call self.assert.false(matcher.match(function('tr')))
endfunction

function! s:t.match_list()
  let matcher = vmock#matcher#with#has('key')
  call self.assert.false(matcher.match([]))
  call self.assert.false(matcher.match(['fake-key']))
  call self.assert.false(matcher.match(['Key']))
  call self.assert.true(matcher.match(['key']))
  call self.assert.true(matcher.match(['fake-key', 'key']))
endfunction

function! s:t.match_dict()
  let matcher = vmock#matcher#with#has('key')
  call self.assert.false(matcher.match({}))
  call self.assert.false(matcher.match({'fake-key': 10}))
  call self.assert.false(matcher.match({'Key': 10}))
  call self.assert.true(matcher.match({'key': 10}))
  call self.assert.true(matcher.match({'fake-key': 10, 'key': 10}))
endfunction


let s:t = vimtest#new('vmock#with#custom()')

function! s:t.global_func()
  function! g:vmock_with_test_custom_func(args)
    return index(a:args, 'xxx') !=# -1 && index(a:args, 'yyy') !=# -1
  endfunction
  let matcher = vmock#matcher#with#custom('g:vmock_with_test_custom_func')
  call self.assert.false(matcher.match([]))
  call self.assert.false(matcher.match(['xxx']))
  call self.assert.false(matcher.match(['yyy']))
  call self.assert.true(matcher.match(['yyy', 'xxx']))

  delfunction g:vmock_with_test_custom_func
endfunction


let s:t = vimtest#new('with.result()')

function! s:t.any_is_always_success()
  let matcher = vmock#matcher#with#any()
  call self.assert.true(matcher.result())
  call matcher.match()
  call self.assert.true(matcher.result())
endfunction

function! s:t.excpet_any_matcher()
  let matcher = vmock#matcher#with#eq(1)
  call self.assert.false(matcher.result())
  call matcher.match(1)
  call self.assert.true(matcher.result())

  " 全ての呼び出しの中で1回でもマッチに失敗するとfail
  call matcher.match(0)
  call self.assert.false(matcher.result()) " falseになる
  call matcher.match(1)
  call self.assert.false(matcher.result()) " falseのまま
endfunction


function! s:arg_data_provider()
  return [
        \ 0, 10, -100,
        \ '', 'aaa',
        \ [], [1, 2, 3],
        \ {}, {'a': 1, 'b': 'BB'},
        \ 0.0, 3.4,
        \ function('tr'), function('vmock#mock')
        \]
endfunction
