let s:t = vimtest#new('vmock#container#add_mock and get_mocks')

function! s:t.setup()
  call vmock#container#clear()
endfunction

function! s:t.teardown()
  call vmock#container#clear()
endfunction

function! s:t.must_be_implement_verify()
  call self.assert.throw('VMock:mock obj must be implement verify()')
  call vmock#container#add_mock('VmockTestFunc', {'a': 1})
endfunction

function! s:t.must_be_verify_is_func()
  call self.assert.throw('VMock:verfiy must be function')
  call vmock#container#add_mock('VmockTestFunc', {'verify': 1})
endfunction

function! s:t.success()
  call self.assert.equals([], vmock#container#get_mocks())

  call vmock#container#add_mock('VmockTestFunc', s:new_mock({'a': 1}))
  let actual = vmock#container#get_mocks()
  call self.assert.equals(1, len(actual))
  call self.assert.equals(1, actual[0].a)

  call vmock#container#add_mock('VmockTestFunc2', s:new_mock({'b': 2}))
  let actual = vmock#container#get_mocks()
  call self.assert.equals(2, len(vmock#container#get_mocks()))
  call self.assert.equals(1, actual[0].a)
  call self.assert.equals(2, actual[1].b)
endfunction

let s:t = vimtest#new('vmock#container#clear')

function! s:t.setup()
  call vmock#container#clear()
endfunction

function! s:t.teardown()
  call vmock#container#clear()
endfunction

function! s:t.container_reset()
  call self.assert.equals([], vmock#container#get_mocks())

  call vmock#container#add_mock('VmockTestFunc', s:new_mock({'a': 1}))
  call self.assert.equals(1, len(vmock#container#get_mocks()))

  call vmock#container#clear()
  call self.assert.equals([], vmock#container#get_mocks())
endfunction

function! s:t.call_mock_teardown()
  let mock = s:new_mock({'state': 1})
  function! mock.teardown()
    let self.state = 2
  endfunction
  call vmock#container#add_mock('VmockTestFunc', mock)
  call vmock#container#clear()
  call self.assert.equals(2, mock.state)
endfunction

function! s:t.not_call_mock_teardown_when_not_implemented()
  let mock = s:new_mock({'state': 1})
  call vmock#container#add_mock('VmockTestFunc', mock)
  call vmock#container#clear()
  call self.assert.equals(1, mock.state)
endfunction

function! s:t.not_call_mock_teardown_when_not_function()
  call vmock#container#add_mock('VmockTestFunc', s:new_mock({'teardown': 1}))
  call vmock#container#clear()
endfunction


function! s:new_mock(ext)
  let obj = {}
  function! obj.verify()
    return 1
  endfunction
  call extend(obj, a:ext)
  return obj
endfunction
