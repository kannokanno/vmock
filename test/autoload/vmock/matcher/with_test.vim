let s:suite = themis#suite('vmock#matcher#with')
let s:assert = themis#helper('assert')

function! s:suite.any_no_arg()
  let matcher = vmock#matcher#with#any()
  call s:assert.true(matcher.match())
endfunction

function! s:suite.any_wtih_arg()
  let matcher = vmock#matcher#with#any()
  for Arg in s:arg_data_provider()
    call s:assert.true(matcher.match(Arg))
    unlet Arg
  endfor
endfunction

function! s:suite.eq_match()
  for Arg in s:arg_data_provider()
    let matcher = vmock#matcher#with#eq(Arg)
    call s:assert.true(matcher.match(Arg))
    call s:assert.false(matcher.match(-1))
    unlet Arg
  endfor
endfunction

function! s:suite.eq_match_ignorecase()
  let matcher = vmock#matcher#with#eq('Abc')
  call s:assert.true(matcher.match('Abc'))
  call s:assert.false(matcher.match('abc'))
endfunction

function! s:suite.eq_fail_message()
  call s:assert.equals('The args[0] expected: 1. but received: 0.',
        \ vmock#matcher#with#eq(1).make_fail_message(0, 0))
  call s:assert.equals('The args[0] expected: [1]. but received: [2].',
        \ vmock#matcher#with#eq([1]).make_fail_message(0, [2]))
  call s:assert.equals("The args[0] expected: {'a': 1}. but received: [1, 2].",
        \ vmock#matcher#with#eq({'a': 1}).make_fail_message(0, [1, 2]))
  call s:assert.equals("The args[0] expected: function('tr'). but received: function('strlen').",
        \ vmock#matcher#with#eq(function('tr')).make_fail_message(0, function('strlen')))
  call s:assert.equals('The args[0] expected: 1.2. but received: 0.',
        \ vmock#matcher#with#eq(1.2).make_fail_message(0, 0))
endfunction

function! s:suite.not_eq_match()
  for Arg in s:arg_data_provider()
    let matcher = vmock#matcher#with#not_eq(Arg)
    call s:assert.false(matcher.match(Arg))
    call s:assert.true(matcher.match(-1))
    unlet Arg
  endfor
endfunction

function! s:suite.not_eq_match_ignorecase()
  let matcher = vmock#matcher#with#not_eq('Abc')
  call s:assert.false(matcher.match('Abc'))
  call s:assert.true(matcher.match('abc'))
endfunction

function! s:suite.not_eq_fail_message()
  call s:assert.equals('The args[0] expected: not equal(==#) 1. but received: 0.',
        \ vmock#matcher#with#not_eq(1).make_fail_message(0, 0))
  call s:assert.equals('The args[0] expected: not equal(==#) [1]. but received: [2].',
        \ vmock#matcher#with#not_eq([1]).make_fail_message(0, [2]))
  call s:assert.equals("The args[0] expected: not equal(==#) {'a': 1}. but received: [1, 2].",
        \ vmock#matcher#with#not_eq({'a': 1}).make_fail_message(0, [1, 2]))
  call s:assert.equals("The args[0] expected: not equal(==#) function('tr'). but received: function('strlen').",
        \ vmock#matcher#with#not_eq(function('tr')).make_fail_message(0, function('strlen')))
  call s:assert.equals('The args[0] expected: not equal(==#) 1.2. but received: 0.',
        \ vmock#matcher#with#not_eq(1.2).make_fail_message(0, 0))
endfunction

function! s:suite.loose_eq_match()
  for Arg in s:arg_data_provider()
    let matcher = vmock#matcher#with#loose_eq(Arg)
    call s:assert.true(matcher.match(Arg))
    call s:assert.false(matcher.match(-1))
    unlet Arg
  endfor
endfunction

function! s:suite.loose_eq_match_ignorecase()
  let matcher = vmock#matcher#with#loose_eq('Abc')
  call s:assert.true(matcher.match('Abc'))
  call s:assert.true(matcher.match('abc'))
endfunction

function! s:suite.loose_eq_fail_message()
  call s:assert.equals('The args[0] expected: 1. but received: 0.',
        \ vmock#matcher#with#loose_eq(1).make_fail_message(0, 0))
  call s:assert.equals('The args[0] expected: [1]. but received: [2].',
        \ vmock#matcher#with#loose_eq([1]).make_fail_message(0, [2]))
  call s:assert.equals("The args[0] expected: {'a': 1}. but received: [1, 2].",
        \ vmock#matcher#with#loose_eq({'a': 1}).make_fail_message(0, [1, 2]))
  call s:assert.equals("The args[0] expected: function('tr'). but received: function('strlen').",
        \ vmock#matcher#with#loose_eq(function('tr')).make_fail_message(0, function('strlen')))
  call s:assert.equals('The args[0] expected: 1.2. but received: 0.',
        \ vmock#matcher#with#loose_eq(1.2).make_fail_message(0, 0))
endfunction

function! s:suite.loose_not_eq_match()
  for Arg in s:arg_data_provider()
    let matcher = vmock#matcher#with#loose_not_eq(Arg)
    call s:assert.false(matcher.match(Arg))
    call s:assert.true(matcher.match(-1))
    unlet Arg
  endfor
endfunction

function! s:suite.loose_not_eq_match_ignorecase()
  let matcher = vmock#matcher#with#loose_not_eq('Abc')
  call s:assert.false(matcher.match('Abc'))
  call s:assert.false(matcher.match('abc'))
endfunction

function! s:suite.loose_not_eq_fail_message()
  call s:assert.equals('The args[0] expected: not equal(==) 1. but received: 0.',
        \ vmock#matcher#with#loose_not_eq(1).make_fail_message(0, 0))
  call s:assert.equals('The args[0] expected: not equal(==) [1]. but received: [2].',
        \ vmock#matcher#with#loose_not_eq([1]).make_fail_message(0, [2]))
  call s:assert.equals("The args[0] expected: not equal(==) {'a': 1}. but received: [1, 2].",
        \ vmock#matcher#with#loose_not_eq({'a': 1}).make_fail_message(0, [1, 2]))
  call s:assert.equals("The args[0] expected: not equal(==) function('tr'). but received: function('strlen').",
        \ vmock#matcher#with#loose_not_eq(function('tr')).make_fail_message(0, function('strlen')))
  call s:assert.equals('The args[0] expected: not equal(==) 1.2. but received: 0.',
        \ vmock#matcher#with#loose_not_eq(1.2).make_fail_message(0, 0))
endfunction

function! s:suite.type_match()
  call s:assert.true(vmock#matcher#with#type(1).match(0))
  call s:assert.true(vmock#matcher#with#type(1).match(100))
  call s:assert.true(vmock#matcher#with#type('').match(''))
  call s:assert.true(vmock#matcher#with#type('').match('hoge'))
  call s:assert.true(vmock#matcher#with#type([]).match([]))
  call s:assert.true(vmock#matcher#with#type([]).match([1, 2]))
  call s:assert.true(vmock#matcher#with#type({}).match({}))
  call s:assert.true(vmock#matcher#with#type({}).match({'a':1}))
  call s:assert.true(vmock#matcher#with#type(function('tr')).match(function('len')))
  call s:assert.true(vmock#matcher#with#type(function('tr')).match(function('vmock#mock')))
  call s:assert.true(vmock#matcher#with#type(0.0).match(0.0))
  call s:assert.true(vmock#matcher#with#type(0.0).match(2.1))

  call s:assert.false(vmock#matcher#with#type({}).match(10))
endfunction

function! s:suite.type_fail_message()
  let m = vmock#matcher#with#type(1)
  call s:assert.equals('The args[0] expected: type(0). but received: type("").', m.make_fail_message(0, ''))
  call s:assert.equals('The args[1] expected: type(0). but received: type([]).', m.make_fail_message(1, ['']))
  call s:assert.equals('The args[1] expected: type(0). but received: type({}).', m.make_fail_message(1, {'a': 1}))
  call s:assert.equals('The args[1] expected: type(0). but received: type(function("tr")).', m.make_fail_message(1, function('tr')))
  call s:assert.equals('The args[1] expected: type(0). but received: type(0.0).', m.make_fail_message(1, 1.2))
endfunction

function! s:suite.not_type_not_match()
  call s:assert.false(vmock#matcher#with#not_type(1).match(0))
  call s:assert.false(vmock#matcher#with#not_type(1).match(100))
  call s:assert.false(vmock#matcher#with#not_type('').match(''))
  call s:assert.false(vmock#matcher#with#not_type('').match('hoge'))
  call s:assert.false(vmock#matcher#with#not_type([]).match([]))
  call s:assert.false(vmock#matcher#with#not_type([]).match([1, 2]))
  call s:assert.false(vmock#matcher#with#not_type({}).match({}))
  call s:assert.false(vmock#matcher#with#not_type({}).match({'a':1}))
  call s:assert.false(vmock#matcher#with#not_type({}).match({'a':1}))
  call s:assert.false(vmock#matcher#with#not_type(function('tr')).match(function('len')))
  call s:assert.false(vmock#matcher#with#not_type(function('tr')).match(function('vmock#mock')))
  call s:assert.false(vmock#matcher#with#not_type(0.0).match(0.0))
  call s:assert.false(vmock#matcher#with#not_type(0.0).match(2.1))

  call s:assert.true(vmock#matcher#with#not_type({}).match(10))
endfunction

function! s:suite.not_type_fail_message()
  call s:assert.equals('The args[0] expected: except type(0). but received: type(0).',
        \ vmock#matcher#with#not_type(1).make_fail_message(0, 0))
  call s:assert.equals('The args[0] expected: except type([]). but received: type([]).',
        \ vmock#matcher#with#not_type([]).make_fail_message(0, []))
  call s:assert.equals('The args[0] expected: except type({}). but received: type({}).',
        \ vmock#matcher#with#not_type({}).make_fail_message(0, {}))
  call s:assert.equals('The args[0] expected: except type(function("tr")). but received: type(function("tr")).',
        \ vmock#matcher#with#not_type(function("tr")).make_fail_message(0, function("tr")))
  call s:assert.equals('The args[0] expected: except type(0.0). but received: type(0.0).',
        \ vmock#matcher#with#not_type(0.0).make_fail_message(0, 0.0))
endfunction

function! s:suite.has_match_invalid_type()
  let matcher = vmock#matcher#with#has('key')
  call s:assert.false(matcher.match(1))
  call s:assert.false(matcher.match('hoge'))
  call s:assert.false(matcher.match(function('tr')))
endfunction

function! s:suite.has_match_list()
  let matcher = vmock#matcher#with#has('key')
  call s:assert.false(matcher.match([]))
  call s:assert.false(matcher.match(['fake-key']))
  call s:assert.false(matcher.match(['Key']))
  call s:assert.true(matcher.match(['key']))
  call s:assert.true(matcher.match(['fake-key', 'key']))
endfunction

function! s:suite.has_match_dict()
  let matcher = vmock#matcher#with#has('key')
  call s:assert.false(matcher.match({}))
  call s:assert.false(matcher.match({'fake-key': 10}))
  call s:assert.false(matcher.match({'Key': 10}))
  call s:assert.true(matcher.match({'key': 10}))
  call s:assert.true(matcher.match({'fake-key': 10, 'key': 10}))
endfunction

function! s:suite.has_fail_message()
  call s:assert.equals('The args[0] expected: has(1). but not found.',
        \ vmock#matcher#with#has(1).make_fail_message(0, 0))
  call s:assert.equals('The args[0] expected: has([1]). but not found.',
        \ vmock#matcher#with#has([1]).make_fail_message(0, 0))
endfunction

function! s:suite.not_has_match_invalid_type()
  let matcher = vmock#matcher#with#not_has('key')
  call s:assert.false(matcher.match(1))
  call s:assert.false(matcher.match('hoge'))
  call s:assert.false(matcher.match(function('tr')))
endfunction

function! s:suite.not_has_match_list()
  let matcher = vmock#matcher#with#not_has('key')
  call s:assert.true(matcher.match([]))
  call s:assert.true(matcher.match(['fake-key']))
  call s:assert.true(matcher.match(['Key']))
  call s:assert.false(matcher.match(['key']))
  call s:assert.false(matcher.match(['fake-key', 'key']))
endfunction

function! s:suite.not_has_match_dict()
  let matcher = vmock#matcher#with#not_has('key')
  call s:assert.true(matcher.match({}))
  call s:assert.true(matcher.match({'fake-key': 10}))
  call s:assert.true(matcher.match({'Key': 10}))
  call s:assert.false(matcher.match({'key': 10}))
  call s:assert.false(matcher.match({'fake-key': 10, 'key': 10}))
endfunction

function! s:suite.not_has_fail_message()
  call s:assert.equals('The args[0] expected: has not(1). but found.',
        \ vmock#matcher#with#not_has(1).make_fail_message(0, 1))
  call s:assert.equals('The args[0] expected: has not([1]). but found.',
        \ vmock#matcher#with#not_has([1]).make_fail_message(0, 0))
endfunction

function! s:suite.custom_global_func()
  function! VMockWithTestCustomFunc(args)
    return index(a:args, 'xxx') !=# -1 && index(a:args, 'yyy') !=# -1
  endfunction
  let matcher = vmock#matcher#with#custom('VMockWithTestCustomFunc')
  call s:assert.false(matcher.match([]))
  call s:assert.false(matcher.match(['xxx']))
  call s:assert.false(matcher.match(['yyy']))
  call s:assert.true(matcher.match(['yyy', 'xxx']))

  delfunction VMockWithTestCustomFunc
endfunction

function! s:suite.custom_fail_message()
  let matcher = vmock#matcher#with#custom('VMockTestSomeFunc')
  call s:assert.equals('Failed custom matcher. The args[0] match function: VMockTestSomeFunc, args: [1, 2]',
        \ matcher.make_fail_message(0, [1, 2]))
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
