let s:suite = themis#suite('vmock#exception')
let s:assert = themis#helper('assert')

" 引数に渡した内容の例外を発生させる
function! s:suite.throw_exception()
  try
    call vmock#exception#throw('Foo Message')

    " ここに到達したら失敗
    call s:assert.true(0)
  catch
    call s:assert.equals(v:exception, 'VMock:Foo Message')
  endtry
endfunction
