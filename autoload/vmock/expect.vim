" AUTHOR: kanno <akapanna@gmail.com>
" License: This file is placed in the public domain.
let s:save_cpo = &cpo
set cpo&vim

function! vmock#expect#new(funcname)
  " globalコンテキストへのひもづけはfuncname
  " return_statement
  "   リライトする際のreturn文。デフォルトは空文字
  " return()
  "   リライトする際のreturn文を指定
  " with()
  "   関数の引数を検証する値を指定
  "   引数からMatcherを作成する
  "   globalコンテキストにひもづけを行い記録する
  " times() (once/naver/any)
  "   期待する関数の呼び出し回数を指定
  "   引数からMatcherを作成する
  "   globalコンテキストにひもづけを行い記録する
  " verfiy()
  "   args_matcherとcount_matcherを取り出す
  "   args_matcher.is_ok() && count_matcher.match()
  "       args_matchはここで実行じゃないので、「結果どうだったか」を見るぐらい？
  " teardown()
  "   関数定義を元に戻す。外から呼ばれるかな

  " 作成時に関数定義を更新
  "   関数名をプロパティに保存
  "   オリジナルの定義(処理、引数)をプロパティに保存
  "     NOTE: 存在しない関数名の場合を検討(そのままモック化できた方が便利な気もする)
  "   calledとargsのmatchを仕込み、戻り値を改ざんした定義で更新する
  "     NOTE: autoload関数経由なら、スクリプトローカルでもいけるんじゃね？
  "     vmock#global#counter(funcname).called()
  "     vmock#global#matcher(funcname).match(args)

  " TODO 初期はオリジナル定義。のtest
  let expect = {
        \ '__return_value': 0,
        \ }

  function! expect.return(value)
    let self.__return_value = a:value
    return self
  endfunction

  function! expect.with(...)
    let self.__matcher = vmock#matcher#with#new(a:args)
    return self
  endfunction

  function! expect.once()
    let self.__matcher = vmock#matcher#counter#new()
    return self
  endfunction

  function! expect.verify()
    " TODO 結果の扱い
    " call s:args_matcher.result()
    " call s:count_validater.validate()
  endfunction

  function! expect.get_return_value()
    return self.__return_value
  endfunction

  function! expect.get_matcher()
    return self.__matcher
  endfunction

  function! expect.get_counter()
    return self.__counter
  endfunction

  return expect
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

