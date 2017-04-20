" TODO 今のところ疎通テストのみ

let s:suite = themis#suite('vmock')
let s:assert = themis#helper('assert')

function! s:suite.any()
  call s:assert.false(empty(vmock#any()))
endfunction

function! s:suite.eq()
  let expected = 11
  call s:assert.equals(vmock#eq(expected).__expected, expected)
endfunction

function! s:suite.not_eq()
  let expected = 11
  call s:assert.equals(vmock#not_eq(expected).__expected, expected)
endfunction

function! s:suite.loose_eq()
  let expected = 11
  call s:assert.equals(vmock#loose_eq(expected).__expected, expected)
endfunction

function! s:suite.loose_not_eq()
  let expected = 11
  call s:assert.equals(vmock#loose_not_eq(expected).__expected, expected)
endfunction

function! s:suite.type()
  let expected = 11
  call s:assert.equals(vmock#type(expected).__expected, expected)
endfunction

function! s:suite.not_type()
  let expected = 11
  call s:assert.equals(vmock#not_type(expected).__expected, expected)
endfunction

function! s:suite.not_type()
  let expected = 11
  call s:assert.equals(vmock#not_type(expected).__expected, expected)
endfunction

function! s:suite.has()
  let expected = 11
  call s:assert.equals(vmock#has(expected).__expected, expected)
endfunction

function! s:suite.custom()
  let expected = 'hoge_op'
  call s:assert.equals(vmock#custom(expected).__eq_op_name, expected)
endfunction
