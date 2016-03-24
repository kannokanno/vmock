scriptencoding utf-8
" AUTHOR: kanno <akapanna@gmail.com>
" License: This file is placed in the public domain.
let s:save_cpo = &cpo
set cpo&vim

" ---
" with_groupとはmatcher/withの集合を表す
" withは引数一つ一つに対応し、with_groupは引数すべてに対応する
" ---

" nullオブジェクト的な位置づけ
" singleton
function! vmock#matcher#with_group#empty_instance()
  if !exists('g:vmock_with_group_empty_obj')
    let g:vmock_with_group_empty_obj = s:make_prototype([])
    function! g:vmock_with_group_empty_obj.match(...)
      return 1 ==# 1
    endfunction
  endif
  return g:vmock_with_group_empty_obj
endfunction

" ---
" <matchers>からwith_groupオブジェクトを生成します。
" <matchers>に基本値(文字列や数値など)が含まれていた場合、
" その値はvmock#matcher#with#eqでラップされます。
"
" @matchers matcher/withか、基本値の配列
"
" Return
"   with_groupオブジェクト
" ---
function! vmock#matcher#with_group#make_instance(matchers)
  if type(a:matchers) !=# type([])
    call vmock#exception#throw('arg type must be List')
  endif

  let obj = s:make_prototype(map(deepcopy(a:matchers), 's:convert_matcher(v:val)'))

  " 必ず各引数を配列にした形で受け取る
  " ex)
  "   引数なし -> []
  "   引数あり -> [arg1, arg2, ...]
  function! obj.match(args)
    if len(a:args) !=# self.__matchers_len
      let self.__fail_message = printf('expected %d args, but %d args were passed.', self.__matchers_len, len(a:args))
      return 0
    endif

    for i in range(self.__matchers_len)
      if !self.__matchers[i].match(a:args[i])
        let self.__fail_message = self.__matchers[i].make_fail_message(i, a:args[i])
        return 0
      endif
    endfor
    return 1
  endfunction

  return obj
endfunction

function! s:convert_matcher(src)
  " match関数を持つ辞書ならば何もしない
  if type(a:src) ==# type({})
        \ && has_key(a:src, 'match')
        \ && (type(a:src.match) ==# type(function('tr')))
    return a:src
  endif
  return vmock#matcher#with#eq(a:src)
endfunction

function! s:make_prototype(matchers)
  let obj = {'__matchers': a:matchers, '__matchers_len': len(a:matchers), '__fail_message': ''}

  function! obj.get_matchers()
    return self.__matchers
  endfunction

  function! obj.recording(args)
    let self.__actual_args = a:args
  endfunction

  function! obj.validate()
    return self.match(self.__actual_args)
  endfunction

  " matcher/withと透過的に扱えるように同名メソッドにしている
  function! obj.make_fail_message()
    return self.__fail_message
  endfunction

  return obj
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
