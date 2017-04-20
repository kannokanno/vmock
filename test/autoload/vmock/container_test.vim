let s:suite = themis#suite('vmock#container')
let s:assert = themis#helper('assert')

function! s:suite.before_each()
  call vmock#container#clear()
endfunction

function! s:suite.after_each()
  call vmock#container#clear()
endfunction

" verifyメソッドが定義されていること
function! s:suite.must_be_implement_verify()
  try
    call vmock#container#add_mock('VmockTestFunc', {'a': 1})

    " ここに到達したら失敗の証
    call s:assert.true(0)
  catch
    call s:assert.equals(v:exception, 'VMock:mock obj must be implement verify()')
  endtry
endfunction

" verifyは関数であること
function! s:suite.must_be_verify_is_func()
  try
    call vmock#container#add_mock('VmockTestFunc', {'verify': 1})

    " ここに到達したら失敗の証
    call s:assert.true(0)
  catch
    call s:assert.equals(v:exception, 'VMock:verfiy must be function')
  endtry
endfunction

" containerに追加成功
function! s:suite.add_container_success()
  call s:assert.equals([], vmock#container#get_mocks())

  call vmock#container#add_mock('VmockTestFunc', s:new_mock({'a': 1}))
  let actual = vmock#container#get_mocks()
  call s:assert.equals(1, len(actual))
  call s:assert.equals(1, actual[0].a)

  call vmock#container#add_mock('VmockTestFunc2', s:new_mock({'b': 2}))
  let actual = vmock#container#get_mocks()
  call s:assert.equals(2, len(vmock#container#get_mocks()))
  call s:assert.equals(1, actual[0].a)
  call s:assert.equals(2, actual[1].b)
endfunction

function! s:suite.setup()
  call vmock#container#clear()
endfunction

function! s:suite.container_reset()
  call s:assert.equals([], vmock#container#get_mocks())

  call vmock#container#add_mock('VmockTestFunc', s:new_mock({'a': 1}))
  call s:assert.equals(1, len(vmock#container#get_mocks()))

  call vmock#container#clear()
  call s:assert.equals([], vmock#container#get_mocks())
endfunction

function! s:suite.call_mock_teardown()
  let mock = s:new_mock({'state': 1})
  function! mock.teardown()
    let self.state = 2
  endfunction
  call vmock#container#add_mock('VmockTestFunc', mock)
  call vmock#container#clear()
  call s:assert.equals(2, mock.state)
endfunction

function! s:suite.not_call_mock_teardown_when_not_implemented()
  let mock = s:new_mock({'state': 1})
  call vmock#container#add_mock('VmockTestFunc', mock)
  call vmock#container#clear()
  call s:assert.equals(1, mock.state)
endfunction

function! s:suite.not_call_mock_teardown_when_not_function()
  call vmock#container#add_mock('VmockTestFunc', s:new_mock({'teardown': 1}))
  call vmock#container#clear()
endfunction


" テスト用ヘルパー関数
function! s:new_mock(ext)
  let obj = {}
  function! obj.verify()
    return 1
  endfunction
  call extend(obj, a:ext)
  return obj
endfunction
