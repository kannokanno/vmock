" Product code {{{
let g:vmock_example_vital_prelude = vital#of('vital').import('Prelude')

function! s:get_hello_string()
  if g:vmock_example_vital_prelude.is_windows()
    return 'Hello Windows'
  elseif g:vmock_example_vital_prelude.is_cygwin()
    return 'Hello Cygwin'
  elseif g:vmock_example_vital_prelude.is_mac()
    return 'Hello Mac'
  elseif g:vmock_example_vital_prelude.is_unix()
    return 'Hello Unix'
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

function! s:setup_mock(win, cygwin, mac, unix)
  call vmock#mock(g:vmock_example_vital_prelude.is_windows).return(a:win).any()
  call vmock#mock(g:vmock_example_vital_prelude.is_cygwin).return(a:cygwin).any()
  call vmock#mock(g:vmock_example_vital_prelude.is_mac).return(a:mac).any()
  call vmock#mock(g:vmock_example_vital_prelude.is_unix).return(a:unix).any()
endfunction

function! s:test(win, cygwin, mac, unix, expected)
  try
    call s:setup_mock(a:win, a:cygwin, a:mac, a:unix)
    call s:assert(s:get_hello_string(), a:expected)
    call vmock#verify()
  catch
    echoerr v:exception
  finally
    call vmock#container#clear()
  endtry
endfunction

call s:test(1, 0, 0, 0, 'Hello Windows')
call s:test(0, 1, 0, 0, 'Hello Cygwin')
call s:test(0, 0, 1, 0, 'Hello Mac')
call s:test(0, 0, 0, 1, 'Hello Unix')
call s:test(0, 0, 0, 0, 'Unknown OS')
