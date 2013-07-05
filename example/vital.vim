" Product code {{{
let g:vmock_example_vital_prelude = vital#of('vital').import('Prelude')

function! VMockExampleVitalOSString()
  if g:vmock_example_vital_prelude.is_windows()
    return 'Hello Windows'
  elseif g:vmock_example_vital_prelude.is_mac()
    return 'Hello Mac'
  endif
  return 'Unknown OS'
endfunction
"}}}
" Test code {{{
function! s:assert(a, b)
  if string(a:a) ==# string(a:b)
    echo 'OK'
  else
    echo printf('NG => %s != %s', string(a:a), string(a:b))
  endif
endfunction

function! s:test_windows()
  try
    " TODO vmock#mockのFuncref対応待ち
    call vmock#mock(g:vmock_example_vital_prelude.is_windows).return(1).once()
    call s:assert(VMockExampleVitalOSString(), 'Hello Windows')
    call vmock#verify_print()
  finally
    call vmock#container#clear()
  endtry
endfunction
"}}}

call s:test_windows()
