let s:suite = themis#suite('vmock#matcher#with_group')
let s:assert = themis#helper('assert')

function! s:suite.no_matchers()
  let matcher = vmock#matcher#with_group#empty_instance()
  call s:assert.equals(0, len(matcher.get_matchers()))
endfunction

function! s:suite.arg_must_be_list()
  try
    let group = vmock#matcher#with_group#make_instance({})

    " ここに到達したら失敗の証
    call s:assert.true(0)
  catch
    call s:assert.equals(v:exception, 'VMock:arg type must be List')
  endtry
endfunction

" match関数が定義されていればそのまま保持する
function! s:suite.when_arg_is_match_obj()
  let matcher_stub = {'name': 'stub'}
  function! matcher_stub.match(args)
  endfunction

  let group = vmock#matcher#with_group#make_instance([matcher_stub])
  let matchers = group.get_matchers()
  call s:assert.equals(1, len(matchers))
  call s:assert.equals('stub', matchers[0].name)
endfunction

" match関数が定義されていなければeq_matcherにラップして保持する
function! s:suite.when_arg_is_not_match_obj()
  for arg in [1, 'aa', [1, 2, 'b'], {'a': 1}]
    let group = vmock#matcher#with_group#make_instance([arg])
    let matchers = group.get_matchers()
    call s:assert.equals(1, len(matchers))
    " TODO 厳密にeq_matcherかどうかはテストできていない
    call s:assert.equals(arg, matchers[0].__expected)
    unlet arg
  endfor
endfunction

function! s:suite.multiple_args()
  let matcher_stub = {'name': 'stub'}
  function! matcher_stub.match(args)
  endfunction

  let group = vmock#matcher#with_group#make_instance([1, matcher_stub, ['b']])
  let matchers = group.get_matchers()
  call s:assert.equals(3, len(matchers))
  call s:assert.equals(1, matchers[0].__expected)
  call s:assert.equals('stub', matchers[1].name)
  call s:assert.equals(['b'], matchers[2].__expected)
endfunction

function! s:suite.empty_obj_match_is_always_success()
  let group = vmock#matcher#with_group#empty_instance()
  call s:assert.true(group.match([1]))
  call s:assert.true(group.match([1, 2]))
  call s:assert.equals('', group.__fail_message)
endfunction

function! s:suite.mismatch_arg_nums_when_too_many()
  let group = vmock#matcher#with_group#make_instance([1, 'AA'])
  call s:assert.false(group.match([1, 2, 3]))
  call s:assert.equals('expected 2 args, but 3 args were passed.', group.__fail_message)
endfunction

function! s:suite.mismatch_arg_nums_when_not_enough()
  let group = vmock#matcher#with_group#make_instance([1, 'AA'])
  call s:assert.false(group.match([1]))
  call s:assert.equals('expected 2 args, but 1 args were passed.', group.__fail_message)
endfunction

function! s:suite.called_each_obj_match()
  let group = vmock#matcher#with_group#make_instance([
        \ s:make_stub(10),
        \ s:make_stub(20),
        \ s:make_stub(30)])
  call group.match([10, 20, 30])

  " matchに成功したのでカウントアップされていることを確認する
  let matchers = group.get_matchers()
  call s:assert.equals(11, matchers[0].num)
  call s:assert.equals(21, matchers[1].num)
  call s:assert.equals(31, matchers[2].num)
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
