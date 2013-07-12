" Product code {{{
function! s:read_feed(url)
  let feeds = []
  for item in webapi#feed#parseURL(a:url)

    " some processing...

    call add(feeds, item)
  endfor
  return feeds
endfunction
"}}}
" Test code {{{
function! s:make_item(title, link)
  return {'title': a:title, 'link': a:link}
endfunction

function! s:assert(a, b)
  if string(a:a) ==# string(a:b)
    echo 'OK'
  else
    echo printf('NG => %s != %s', string(a:a), string(a:b))
  endif
endfunction

function! s:test()
  " expected data
  let items = [s:make_item('Title-1', 'http://localhost/hoge'),
            \ s:make_item('Title-2', 'http://localhost/piyo'),
            \ s:make_item('Title-3', 'http://localhost/fuga')]
  let url = 'http://rss.slashdot.org/Slashdot/slashdot'

  try
    call vmock#mock('webapi#feed#parseURL').with(url).return(items).once()

    let feeds = s:read_feed(url)

    call s:assert(len(items), len(feeds))
    call s:assert(items[0], feeds[0])
    call s:assert(items[1], feeds[1])
    call s:assert(items[2], feeds[2])

    call vmock#verify()
  catch
    echoerr v:exception
  finally
    call vmock#clear()
  endtry
endfunction
"}}}

call s:test()
