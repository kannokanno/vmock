" AUTHOR: kanno <akapanna@gmail.com>
" License: This file is placed in the public domain.
let s:save_cpo = &cpo
set cpo&vim

function! vmock#listener#vimtest#teardown()
  " TODO vimtest側の対応
  " vimtest側の仕様によって挙動は変わる
    " アサーションカウント
    " エラーなのかfalseなのか

  " モックの一覧を取得する
  " モック一覧を繰り返す
    " モックの検証結果を取得する
      " [検証結果]
        " メッセージ
        " ステータス(成功/失敗)
    " 失敗しているケースに絞り込む
    " 失敗しているケースのメッセージを取得
    " vimtestのfailメソッドをコールする(現在は1回呼んだ時点で処理が中断する)


  "try
  "  for mock in vmock#container#get_mocks()
  "    call mock.verify()
  "  endfor
  "finally
  "  call vmock#container#clear()
  "endtry
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

