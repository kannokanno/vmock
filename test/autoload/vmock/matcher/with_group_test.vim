let s:t = vimtest#new('vmock#matcher#with_group#empty_instance()')

function! s:t.no_matchers()
  let matcher = vmock#matcher#with_group#empty_instance()
  call self.assert.equals(0, len(matcher.get_matchers()))
endfunction

let s:t = vimtest#new('vmock#matcher#with_group#make_instance()')

function! s:t.arg_must_be_list()
  call self.assert.throw('VMock:arg type must be List')
  let composite = vmock#matcher#with_group#make_instance({})
endfunction

" match関数が定義されていればそのまま保持する
function! s:t.when_arg_is_match_obj()
  let matcher_stub = {'name': 'stub'}
  function! matcher_stub.match(args)
  endfunction

  let composite = vmock#matcher#with_group#make_instance([matcher_stub])
  let matchers = composite.get_matchers()
  call self.assert.equals(1, len(matchers))
  call self.assert.equals('stub', matchers[0].name)
endfunction

" match関数が定義されていなければeq_matcherにラップして保持する
function! s:t.when_arg_is_not_match_obj()
  for arg in [1, 'aa', [1, 2, 'b'], {'a': 1}]
    let composite = vmock#matcher#with_group#make_instance([arg])
    let matchers = composite.get_matchers()
    call self.assert.equals(1, len(matchers))
    " TODO 厳密にeq_matcherかどうかはテストできていない
    call self.assert.equals(arg, matchers[0].__expected)
    unlet arg
  endfor
endfunction

function! s:t.multiple_args()
  let matcher_stub = {'name': 'stub'}
  function! matcher_stub.match(args)
  endfunction

  let composite = vmock#matcher#with_group#make_instance([1, matcher_stub, ['b']])
  let matchers = composite.get_matchers()
  call self.assert.equals(3, len(matchers))
  call self.assert.equals(1, matchers[0].__expected)
  call self.assert.equals('stub', matchers[1].name)
  call self.assert.equals(['b'], matchers[2].__expected)
endfunction

let s:t = vimtest#new('vmock#matcher#with_group#match()')

function! s:t.empty_obj_match_is_always_success()
  let matcher = vmock#matcher#with_group#empty_instance()
  call self.assert.true(matcher.match([1]))
  call self.assert.true(matcher.match([1, 2]))
endfunction

function! s:t.mismatch_arg_nums_when_too_many()
  let composite = vmock#matcher#with_group#make_instance([1, 'AA'])
  call self.assert.throw('VMock:expected 2 args, but 3 args were passed.')
  call self.assert.true(composite.match([1, 2, 3]))
endfunction

function! s:t.mismatch_arg_nums_when_not_enough()
  let composite = vmock#matcher#with_group#make_instance([1, 'AA'])
  call self.assert.throw('VMock:expected 2 args, but 1 args were passed.')
  call self.assert.true(composite.match([1]))
endfunction

function! s:t.called_each_obj_match()
  let composite = vmock#matcher#with_group#make_instance([
        \ s:make_stub(10),
        \ s:make_stub(20),
        \ s:make_stub(30)])
  call composite.match([10, 20, 30])

  " matchに成功したのでカウントアップされていることを確認する
  let matchers = composite.get_matchers()
  call self.assert.equals(11, matchers[0].num)
  call self.assert.equals(21, matchers[1].num)
  call self.assert.equals(31, matchers[2].num)
endfunction

function! s:make_stub(init_num)
  let stub = {'num': a:init_num}
  function! stub.match(arg)
    if a:arg ==# self.num
      let self.num += 1
    endif
    return 1
  endfunction
  return stub
endfunction

