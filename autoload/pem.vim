let s:all_cmd_for_type = {
  \ 'CERTIFICATE': 'openssl crl2pkcs7 -nocrl -certfile /dev/stdin | openssl pkcs7 -noout -text -print_certs',
  \ }

let s:cmd_for_type = {
  \ 'CERTIFICATE':             'openssl x509 -text -noout',
  \ 'CERTIFICATE REQUEST':     'openssl req -text -noout',
  \ 'NEW CERTIFICATE REQUEST': 'openssl req -text -noout',
  \ 'RSA PRIVATE KEY':         'openssl rsa -text -noout',
  \ 'DSA PRIVATE KEY':         'openssl dsa -text -noout',
  \ 'EC PRIVATE KEY':          'openssl ec -text -noout',
  \ 'PRIVATE KEY':             'openssl pkey -text -noout',
  \ 'ENCRYPTED PRIVATE KEY':   'openssl pkey -text -noout -passin pass:',
  \ 'PUBLIC KEY':              'openssl pkey -pubin -text -noout',
  \ 'RSA PUBLIC KEY':          'openssl rsa -pubin -text -noout',
  \ 'X509 CRL':                'openssl crl -text -noout',
  \ 'PKCS7':                   'openssl pkcs7 -print_certs -text -noout',
  \ }

function! s:run(cmd, input) abort
  let l:lines = systemlist(a:cmd, a:input)
  if v:shell_error != 0
    echohl ErrorMsg | echom 'pem: openssl error: ' . join(l:lines, ' ') | echohl None
    return []
  endif
  return l:lines
endfunction

function! s:decode_block_at_cursor() abort
  let l:begin_lnum = search('^-----BEGIN .\{-}-----$', 'bcW')
  if l:begin_lnum == 0
    echohl WarningMsg | echom 'pem: no PEM block at cursor' | echohl None
    return {}
  endif

  let l:pem_type = matchstr(getline(l:begin_lnum), '^-----BEGIN \zs.\{-}\ze-----$')
  let l:end_lnum = search('^-----END ' . l:pem_type . '-----$', 'W')

  if l:end_lnum == 0
    echohl WarningMsg | echom 'pem: no matching END for: ' . l:pem_type | echohl None
    return {}
  endif

  if !has_key(s:cmd_for_type, l:pem_type)
    echohl WarningMsg | echom 'pem: no openssl command for type: ' . l:pem_type | echohl None
    return {}
  endif

  let l:pem_data = join(getline(l:begin_lnum, l:end_lnum), "\n")
  let l:lines    = s:run(s:cmd_for_type[l:pem_type], l:pem_data)
  if empty(l:lines)
    return {}
  endif

  return {'type': l:pem_type, 'lines': l:lines}
endfunction

function! s:open_output_buf(lines, name) abort
  new
  call setline(1, a:lines)
  setlocal buftype=nofile bufhidden=wipe noswapfile nomodifiable readonly nobuflisted filetype=opensslout
  execute 'file ' . fnameescape(a:name)
  nnoremap <buffer> q <Cmd>bwipeout<CR>
endfunction

function! pem#DecodePemBlock() abort
  let l:save = getcurpos()
  try
    let l:block = s:decode_block_at_cursor()
    if empty(l:block)
      return
    endif
  finally
    call setpos('.', l:save)
  endtry

  call s:open_output_buf(l:block.lines, 'PEM: ' . l:block.type)
endfunction

function! pem#DecodeAllPemBlocks() abort
  let l:first_lnum = search('^-----BEGIN .\{-}-----$', 'nw')
  if l:first_lnum == 0
    echohl WarningMsg | echom 'pem: no PEM blocks found' | echohl None
    return
  endif

  let l:pem_type = matchstr(getline(l:first_lnum), '^-----BEGIN \zs.\{-}\ze-----$')

  if has_key(s:all_cmd_for_type, l:pem_type)
    let l:lines = s:run(s:all_cmd_for_type[l:pem_type], getline(1, '$'))
    if empty(l:lines)
      return
    endif
    call s:open_output_buf(l:lines, 'PEM: all')
    return
  endif

  let l:save   = getcurpos()
  let l:output = []
  try
    call cursor(1, 1)
    while search('^-----BEGIN .\{-}-----$', 'W') > 0
      let l:block = s:decode_block_at_cursor()
      if !empty(l:block)
        if !empty(l:output)
          call add(l:output, '')
        endif
        call extend(l:output, l:block.lines)
      endif
    endwhile
  finally
    call setpos('.', l:save)
  endtry

  if empty(l:output)
    echohl WarningMsg | echom 'pem: no PEM blocks found' | echohl None
    return
  endif

  call s:open_output_buf(l:output, 'PEM: all')
endfunction
