" 細かいパターンはUAT側でカバーしている
let s:suite = themis#suite('vmock#function_define - global function')
let s:assert = themis#helper('assert')

function! s:suite.after_each()
  if exists('VMockGlobalFunc')
    delfunction VMockGlobalFunc
  endif
endfunction

function! s:suite.get_no_args()
  function! VMockGlobalFunc()
  endfunction
  let define = vmock#function_define#get('VMockGlobalFunc')
  call s:assert.equals('VMockGlobalFunc', define.funcname)
  call s:assert.equals([], define.arg_names)
endfunction

function! s:suite.get_one_arg()
  function! VMockGlobalFunc(name)
  endfunction
  let define = vmock#function_define#get('VMockGlobalFunc')
  call s:assert.equals('VMockGlobalFunc', define.funcname)
  call s:assert.equals(['name'], define.arg_names)
endfunction

function! s:suite.get_two_arg()
  function! VMockGlobalFunc(name, value)
  endfunction
  let define = vmock#function_define#get('VMockGlobalFunc')
  call s:assert.equals('VMockGlobalFunc', define.funcname)
  call s:assert.equals(['name', 'value'], define.arg_names)
endfunction

function! s:suite.get_variable_length_arg()
  function! VMockGlobalFunc(...)
  endfunction
  let define = vmock#function_define#get('VMockGlobalFunc')
  call s:assert.equals('VMockGlobalFunc', define.funcname)
  call s:assert.equals(['...'], define.arg_names)
endfunction

function! s:suite.get_no_body()
  function! VMockGlobalFunc(arg)
  endfunction
  let define = vmock#function_define#get('VMockGlobalFunc')
  call s:assert.equals('VMockGlobalFunc', define.funcname)
  call s:assert.equals('', define.body)
endfunction

function! s:suite.get_one_line_body()
  function! VMockGlobalFunc(arg)
    return s:hogehoge()
  endfunction
  let define = vmock#function_define#get('VMockGlobalFunc')
  call s:assert.equals('VMockGlobalFunc', define.funcname)
  call s:assert.equals(join([
        \ 'return s:hogehoge()',
        \ ], "\n"), define.body)
endfunction

function! s:suite.get_multi_line_body()
  function! VMockGlobalFunc(arg)
    let a = 1
    let b = 2
    if a ==# b
      return 'hoge'
    endif
    return 'piyo'
  endfunction
  let define = vmock#function_define#get('VMockGlobalFunc')
  call s:assert.equals('VMockGlobalFunc', define.funcname)
  call s:assert.equals(join([
        \ "let a = 1",
        \ "let b = 2",
        \ "if a ==# b",
        \ "return 'hoge'",
        \ "endif",
        \ "return 'piyo'"
        \ ], "\n"), define.body)
endfunction

function! s:suite.get_multi_line_and_no_return_body()
  function! VMockGlobalFunc(arg)
    let a = 1
    let b = 2
    let b = 2
    let b = 2
    let b = 2
    let b = 2
    let b = 2
    let b = 2
    let b = 2
    let b = 2
    let b = 2
    let b = 2
    if a ==# b
      echo 'OK!'
    endif
  endfunction
  let define = vmock#function_define#get('VMockGlobalFunc')
  call s:assert.equals('VMockGlobalFunc', define.funcname)
  " 行番号の桁数によってインデントがずれてしまう
  call s:assert.equals(join([
        \ "let a = 1",
        \ "let b = 2",
        \ "let b = 2",
        \ "let b = 2",
        \ "let b = 2",
        \ "let b = 2",
        \ "let b = 2",
        \ "let b = 2",
        \ "let b = 2",
        \ "let b = 2",
        \ "let b = 2",
        \ "let b = 2",
        \ "if a ==# b",
        \ "echo 'OK!'",
        \ "endif",
        \ ], "\n"), define.body)
endfunction

function! s:suite.override_no_args()
  function! VMockGlobalFunc()
    return 10
  endfunction
  call s:assert.equals(10, VMockGlobalFunc())
  call vmock#function_define#override('VMockGlobalFunc', [], 'return 100')

  call s:assert.equals(100, VMockGlobalFunc())
  call s:assert.equals(join([
        \ '',
        \ '   function VMockGlobalFunc()',
        \ '1  return 100',
        \ '   endfunction',
        \ ], "\n"), s:get_define_string('VMockGlobalFunc'))
endfunction

function! s:suite.override_one_args()
  function! VMockGlobalFunc(first)
    return a:first * 10
  endfunction
  call s:assert.equals(100, VMockGlobalFunc(10))
  call vmock#function_define#override('VMockGlobalFunc', ['first'], 'return a:first + 10')

  call s:assert.equals(20, VMockGlobalFunc(10))
  call s:assert.equals(join([
        \ '',
        \ '   function VMockGlobalFunc(first)',
        \ '1  return a:first + 10',
        \ '   endfunction',
        \ ], "\n"), s:get_define_string('VMockGlobalFunc'))
endfunction

function! s:suite.override_two_args()
  function! VMockGlobalFunc(first, second)
    return a:first * a:second
  endfunction
  call s:assert.equals(100, VMockGlobalFunc(10, 10))
  call vmock#function_define#override('VMockGlobalFunc', ['first', 'second'], 'return a:first + a:second')

  call s:assert.equals(20, VMockGlobalFunc(10, 10))
  call s:assert.equals(join([
        \ '',
        \ '   function VMockGlobalFunc(first, second)',
        \ '1  return a:first + a:second',
        \ '   endfunction',
        \ ], "\n"), s:get_define_string('VMockGlobalFunc'))
endfunction

function! s:suite.override_variable_args()
  function! VMockGlobalFunc(...)
    return map(copy(a:000), 'v:val * 10')
  endfunction
  call s:assert.equals([100, 200, 300], VMockGlobalFunc(10, 20, 30))
  call vmock#function_define#override('VMockGlobalFunc', ['...'], 'return map(copy(a:000), "v:val + 1")')

  call s:assert.equals([11, 21, 31], VMockGlobalFunc(10, 20, 30))
  call s:assert.equals(join([
        \ '',
        \ '   function VMockGlobalFunc(...)',
        \ '1  return map(copy(a:000), "v:val + 1")',
        \ '   endfunction',
        \ ], "\n"), s:get_define_string('VMockGlobalFunc'))
endfunction

function! s:suite.override_no_return()
  function! VMockGlobalFunc()
    throw 'unexpected called'
  endfunction
  call vmock#function_define#override('VMockGlobalFunc', [], '')
  call VMockGlobalFunc()
  call s:assert.equals(join([
        \ '',
        \ '   function VMockGlobalFunc()',
        \ '1   ',
        \ '   endfunction',
        \ ], "\n"), s:get_define_string('VMockGlobalFunc'))
endfunction

function! s:suite.override_exception_when_funcname_is_empty()
  try
    call vmock#function_define#override('', [], '')

    " ここに到達したら失敗の証
    call s:assert.true(0)
  catch
    call s:assert.equals(v:exception, 'VMock:Function name required')
  endtry
endfunction


let s:suite = themis#suite('vmock#function_define - autoload')
let s:assert = themis#helper('assert')

function! s:suite.after_each()
  " TODO 元コードの再定義をベタ書きしてしまっている
  function! vmock#for_test#testdata#func()
    return 10
  endfunction
endfunction

function! s:suite.override()
  call s:assert.equals(10, vmock#for_test#testdata#func())
  call vmock#function_define#override('vmock#for_test#testdata#func', [], 'return 100')
  call s:assert.equals(100, vmock#for_test#testdata#func())
  call s:assert.equals(join([
        \ '',
        \ '   function vmock#for_test#testdata#func()',
        \ '1  return 100',
        \ '   endfunction',
        \ ], "\n"), s:get_define_string('vmock#for_test#testdata#func'))
endfunction


let s:suite = themis#suite('vmock#function_define#override_mock')
let s:assert = themis#helper('assert')

function! s:suite.call_test()
  function! VMockGlobalFunc()
    return 10
  endfunction
  " エラーなく処理が終了することだけ確認
  call vmock#function_define#override_mock({'funcname': 'VMockGlobalFunc', 'arg_names': ['first']})
endfunction


let s:suite = themis#suite('vmock#function_define#make_mock_body()')
let s:assert = themis#helper('assert')

function! s:suite.make_mock_body()
  let patterns = [
        \ ['g:vmock_test_func', [], '[]'],
        \ ['hoge#hoge', ['a', 'bb'], "[a:a,a:bb]"],
        \ ['Global', ['...'], 'a:000'],
        \ ['Global', ['a', '...'], "[a:a,a:000]"],
        \ ['g:dict.hoge', ['one'], "[a:one]"],
        \]
  for pat in patterns
    let actual = vmock#function_define#make_mock_body(s:stub_define(pat[0], pat[1]))
    let expected = s:expected_statement(pat[0], pat[2])
    call s:assert.equals(expected, actual)
  endfor
endfunction


let s:suite = themis#suite('vmock#function_define#validate()')
let s:assert = themis#helper('assert')

function! s:suite.success_when_exists_func()
  call s:assert.true(vmock#function_define#validate('tr'))
endfunction

function! s:suite.success_when_autoload()
  call s:assert.true(vmock#function_define#validate('vmock#for_test#testdata#for_validate'))
endfunction

function! s:suite.exception_when_not_func()
  try
    call vmock#function_define#validate('$VIM')

    " ここに到達したら失敗の証
    call s:assert.true(0)
  catch
    call s:assert.equals(v:exception, 'Vim(if):E129: Function name required')
  endtry
endfunction

function! s:suite.exception_when_undefined_func()
  try
    call vmock#function_define#validate('VMockUndeinfedFunc')

    " ここに到達したら失敗の証
    call s:assert.true(0)
  catch
    call s:assert.equals(v:exception, 'VMock:E123: Undefined function: VMockUndeinfedFunc')
  endtry
endfunction


" テスト用ヘルパー
function! s:get_define_string(funcname)
  let out = ''
  redir => out
  silent! exec 'function '.a:funcname
  redir END
  return out
endfunction

" テスト用ヘルパー
function! s:stub_define(funcname, arg_names)
  return {'funcname': a:funcname, 'arg_names': a:arg_names}
endfunction

" テスト用ヘルパー
function! s:expected_statement(funcname, arg_variable)
  let s = printf("call vmock#mock#called('%s', %s)", a:funcname, a:arg_variable)
  let s .= "\n"
  let s .= printf("return vmock#mock#return('%s')", a:funcname)
  return s
endfunction
