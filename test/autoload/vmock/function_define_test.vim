" TODO 細かいパターンは受け入れに回すということをここにも明記しておくか
let s:t = vimtest#new('vmock#function_define#get() - g:func') "{{{

function! s:t.teardown()
  delfunction g:vmock_global_func
endfunction

function! s:t.no_args()
  function! g:vmock_global_func()
  endfunction
  let define = vmock#function_define#get('g:vmock_global_func')
  call self.assert.equals('g:vmock_global_func', define.funcname)
  call self.assert.equals([], define.arg_names)
endfunction

function! s:t.one_arg()
  function! g:vmock_global_func(name)
  endfunction
  let define = vmock#function_define#get('g:vmock_global_func')
  call self.assert.equals('g:vmock_global_func', define.funcname)
  call self.assert.equals(['name'], define.arg_names)
endfunction

function! s:t.two_arg()
  function! g:vmock_global_func(name, value)
  endfunction
  let define = vmock#function_define#get('g:vmock_global_func')
  call self.assert.equals('g:vmock_global_func', define.funcname)
  call self.assert.equals(['name', 'value'], define.arg_names)
endfunction

function! s:t.variable_length_arg()
  function! g:vmock_global_func(...)
  endfunction
  let define = vmock#function_define#get('g:vmock_global_func')
  call self.assert.equals('g:vmock_global_func', define.funcname)
  call self.assert.equals(['...'], define.arg_names)
endfunction

function! s:t.no_body()
  function! g:vmock_global_func(arg)
  endfunction
  let define = vmock#function_define#get('g:vmock_global_func')
  call self.assert.equals('g:vmock_global_func', define.funcname)
  call self.assert.equals('', define.body)
endfunction

function! s:t.one_line_body()
  function! g:vmock_global_func(arg)
    return s:hogehoge()
  endfunction
  let define = vmock#function_define#get('g:vmock_global_func')
  call self.assert.equals('g:vmock_global_func', define.funcname)
  call self.assert.equals(join([
        \ '    return s:hogehoge()',
        \ ], "\n"), define.body)
endfunction

function! s:t.multi_line_body()
  function! g:vmock_global_func(arg)
    let a = 1
    let b = 2
    if a ==# b
      return 'hoge'
    endif
    return 'piyo'
  endfunction
  let define = vmock#function_define#get('g:vmock_global_func')
  call self.assert.equals('g:vmock_global_func', define.funcname)
  call self.assert.equals(join([
        \ "    let a = 1",
        \ "    let b = 2",
        \ "    if a ==# b",
        \ "      return 'hoge'",
        \ "    endif",
        \ "    return 'piyo'"
        \ ], "\n"), define.body)
endfunction

function! s:t.multi_line_and_no_return_body()
  function! g:vmock_global_func(arg)
    let a = 1
    let b = 2
    if a ==# b
      echo 'OK!'
    endif
  endfunction
  let define = vmock#function_define#get('g:vmock_global_func')
  call self.assert.equals('g:vmock_global_func', define.funcname)
  call self.assert.equals(join([
        \ "    let a = 1",
        \ "    let b = 2",
        \ "    if a ==# b",
        \ "      echo 'OK!'",
        \ "    endif",
        \ ], "\n"), define.body)
endfunction
"}}}
let s:t = vimtest#new('vmock#function_define#override() - g:func') "{{{

function! s:t.teardown()
  if exists('g:vmock_global_func')
    delfunction g:vmock_global_func
  endif
endfunction

function! s:t.no_args()
  function! g:vmock_global_func()
    return 10
  endfunction
  call self.assert.equals(10, g:vmock_global_func())
  call vmock#function_define#override('g:vmock_global_func', [], 'return 100')

  call self.assert.equals(100, g:vmock_global_func())
  call self.assert.equals(join([
        \ '',
        \ '   function g:vmock_global_func()',
        \ '1  return 100',
        \ '   endfunction',
        \ ], "\n"), s:get_define_string('g:vmock_global_func'))
endfunction

function! s:t.one_args()
  function! g:vmock_global_func(first)
    return a:first * 10
  endfunction
  call self.assert.equals(100, g:vmock_global_func(10))
  call vmock#function_define#override('g:vmock_global_func', ['first'], 'return a:first + 10')

  call self.assert.equals(20, g:vmock_global_func(10))
  call self.assert.equals(join([
        \ '',
        \ '   function g:vmock_global_func(first)',
        \ '1  return a:first + 10',
        \ '   endfunction',
        \ ], "\n"), s:get_define_string('g:vmock_global_func'))
endfunction

function! s:t.two_args()
  function! g:vmock_global_func(first, second)
    return a:first * a:second
  endfunction
  call self.assert.equals(100, g:vmock_global_func(10, 10))
  call vmock#function_define#override('g:vmock_global_func', ['first', 'second'], 'return a:first + a:second')

  call self.assert.equals(20, g:vmock_global_func(10, 10))
  call self.assert.equals(join([
        \ '',
        \ '   function g:vmock_global_func(first, second)',
        \ '1  return a:first + a:second',
        \ '   endfunction',
        \ ], "\n"), s:get_define_string('g:vmock_global_func'))
endfunction

function! s:t.variable_args()
  function! g:vmock_global_func(...)
    return map(copy(a:000), 'v:val * 10')
  endfunction
  call self.assert.equals([100, 200, 300], g:vmock_global_func(10, 20, 30))
  call vmock#function_define#override('g:vmock_global_func', ['...'], 'return map(copy(a:000), "v:val + 1")')

  call self.assert.equals([11, 21, 31], g:vmock_global_func(10, 20, 30))
  call self.assert.equals(join([
        \ '',
        \ '   function g:vmock_global_func(...)',
        \ '1  return map(copy(a:000), "v:val + 1")',
        \ '   endfunction',
        \ ], "\n"), s:get_define_string('g:vmock_global_func'))
endfunction

function! s:t.no_return()
  function! g:vmock_global_func()
    throw 'unexpected called'
  endfunction
  call vmock#function_define#override('g:vmock_global_func', [], '')
  call g:vmock_global_func()
  call self.assert.equals(join([
        \ '',
        \ '   function g:vmock_global_func()',
        \ '1   ',
        \ '   endfunction',
        \ ], "\n"), s:get_define_string('g:vmock_global_func'))
endfunction

function! s:t.exception_when_funcname_is_empty()
  call self.assert.throw('VMockException:Function name required')
  call vmock#function_define#override('', [], '')
endfunction
"}}}
let s:t = vimtest#new('vmock#function_define#override() - GlobalFunc') "{{{

function! s:t.teardown()
  delfunction Vmock_global_func
endfunction

function! s:t.override()
  function! Vmock_global_func()
    return 10
  endfunction
  call self.assert.equals(10, Vmock_global_func())
  call vmock#function_define#override('Vmock_global_func', [], 'return 100')

  call self.assert.equals(100, Vmock_global_func())
  call self.assert.equals(join([
        \ '',
        \ '   function Vmock_global_func()',
        \ '1  return 100',
        \ '   endfunction',
        \ ], "\n"), s:get_define_string('Vmock_global_func'))
endfunction
"}}}
let s:t = vimtest#new('vmock#function_define#override() - autoload#func') "{{{

function! s:t.teardown()
  " TODO 元コードの再定義をベタ書きしてしまっている
  function! vmock#for_test#testdata#func()
    return 10
  endfunction
endfunction

function! s:t.override()
  " vmock#for_test#testdata#funcに定義あり
  " NOTE:一度autoload関数を呼び出すか、対象ファイルをsourceしないと再定義できない
  "      source制御は別ファイルの処理で行うので、ここのテストでは明示的に呼び出している
  call self.assert.equals(10, vmock#for_test#testdata#func())
  call vmock#function_define#override('vmock#for_test#testdata#func', [], 'return 100')

  call self.assert.equals(100, vmock#for_test#testdata#func())
  call self.assert.equals(join([
        \ '',
        \ '   function vmock#for_test#testdata#func()',
        \ '1  return 100',
        \ '   endfunction',
        \ ], "\n"), s:get_define_string('vmock#for_test#testdata#func'))
endfunction
"}}}
let s:t = vimtest#new('vmock#function_define#override() - g:dict.func') "{{{

function! s:t.teardown()
  unlet! g:vmock_test_dict
endfunction

function! s:t.override()
  let g:vmock_test_dict = {}
  function! g:vmock_test_dict.func()
    return 10
  endfunction
  call self.assert.equals(10, g:vmock_test_dict.func())
  call vmock#function_define#override('g:vmock_test_dict.func', [], 'return 100')

  call self.assert.equals(100, g:vmock_test_dict.func())
  " TODO 関数名が番号(530とか)になっちゃうので定義一致のテストめんどい。
endfunction
"}}}
let s:t = vimtest#new('vmock#function_define#override_mock()') "{{{

function! s:t.call_test()
  function! g:vmock_global_func()
    return 10
  endfunction
  " エラーなく処理が終了することだけ確認
  call vmock#function_define#override_mock({'funcname': 'g:vmock_test_func', 'arg_names': ['first']})
endfunction
"}}}
let s:t = vimtest#new('vmock#function_define#build_mock_body()') "{{{

function! s:t.build_mock_body()
  call self.assert.equals("return vmock#mock#return('g:vmock_test_func')",
        \ vmock#function_define#build_mock_body({'funcname': 'g:vmock_test_func'}))
  call self.assert.equals("return vmock#mock#return('hoge#hoge')",
        \ vmock#function_define#build_mock_body({'funcname': 'hoge#hoge'}))
  call self.assert.equals("return vmock#mock#return('Global')",
        \ vmock#function_define#build_mock_body({'funcname': 'Global'}))
  call self.assert.equals("return vmock#mock#return('g:dict.hoge')",
        \ vmock#function_define#build_mock_body({'funcname': 'g:dict.hoge'}))
endfunction
"}}}

function! s:get_define_string(funcname)
  let out = ''
  redir => out
  silent! exec 'function '.a:funcname
  redir END
  return out
endfunction

