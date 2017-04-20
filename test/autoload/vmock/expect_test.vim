let s:suite = themis#suite('vmock#expect')
let s:assert = themis#helper('assert')

" return()で設定した値を取り出せる
function! s:suite.setting_return_value()
  for v in [20, 'hoge', [1, 2]]
    let expect = vmock#expect#new('VMockHoge').return(v)
    call s:assert.equals(v, expect.get_return_value())
    unlet v
  endfor
endfunction

" mockの回数指定のデフォルトはany
function! s:suite.counter_default_is_any()
  let expect = vmock#expect#new('VMockHoge')
  call s:assert.equals(expect.get_counter().__name, 'any')
endfunction

function! s:suite.counter_once()
  let expect = vmock#expect#new('VMockHoge').once()
  call s:assert.equals(expect.get_counter().__name, 'once')
endfunction

function! s:suite.counter_times()
  let expect = vmock#expect#new('VMockHoge').times(1)
  call s:assert.equals(expect.get_counter().__name, 'times')
endfunction

function! s:suite.counter_at_least()
  let expect = vmock#expect#new('VMockHoge').at_least(1)
  call s:assert.equals(expect.get_counter().__name, 'at_least')
endfunction

function! s:suite.counter_at_most()
  let expect = vmock#expect#new('VMockHoge').at_most(1)
  call s:assert.equals(expect.get_counter().__name, 'at_most')
endfunction

function! s:suite.any()
  let expect = vmock#expect#new('VMockHoge').any()
  call s:assert.equals(expect.get_counter().__name, 'any')
endfunction

function! s:suite.never()
  let expect = vmock#expect#new('VMockHoge').never()
  call s:assert.equals(expect.get_counter().__name, 'never')
endfunction

function! s:suite.with_default_is_empty_matcher()
  let expect = vmock#expect#new('VMockHoge')
  call s:assert.equals(expect.get_matcher().__matchers_len, 0)
endfunction

" with定義をする時は引数が必須
function! s:suite.exception_when_empty_args()
  try
    call vmock#expect#new('VMockHoge').with()

    " ここに到達したら失敗の証
    call s:assert.true(0)
  catch
    call s:assert.equals(v:exception, 'VMock:Required args')
  endtry
endfunction

" 期待する引数の数のテスト
function! s:suite.setting_matchers()
  let expect = vmock#expect#new('VMockHoge').with(1)
  call s:assert.equals(1, expect.get_matcher().__matchers_len)
  let expect = vmock#expect#new('VMockHoge').with(1, 'a')
  call s:assert.equals(2, expect.get_matcher().__matchers_len)
  let expect = vmock#expect#new('VMockHoge').with(1, 'a', {'key': 'val'})
  call s:assert.equals(3, expect.get_matcher().__matchers_len)
endfunction

" 続けて呼ぶとエラー
function! s:suite.exception_on_multiple_caled()
  try
    call vmock#expect#new('VMockHoge').with(1).with(2)

    " ここに到達したら失敗の証
    call s:assert.true(0)
  catch
    call s:assert.equals(v:exception, 'VMock:with is already set up.')
  endtry
endfunction
