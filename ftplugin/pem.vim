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

function! s:DecodePemBlock() abort
  let l:save   = getcurpos()

  let l:begin_lnum = search('^-----BEGIN .\{-}-----$', 'bcW')
  if l:begin_lnum == 0
    echohl WarningMsg | echom 'pem: no PEM block at cursor' | echohl None
    return
  endif

  let l:pem_type = matchstr(getline(l:begin_lnum), '^-----BEGIN \zs.\{-}\ze-----$')

  let l:end_lnum = search('^-----END ' . l:pem_type . '-----$', 'W')
  call setpos('.', l:save)

  if l:end_lnum == 0
    echohl WarningMsg | echom 'pem: no matching END for: ' . l:pem_type | echohl None
    return
  endif

  if !has_key(s:cmd_for_type, l:pem_type)
    echohl WarningMsg | echom 'pem: no openssl command for type: ' . l:pem_type | echohl None
    return
  endif

  let l:pem_data = join(getline(l:begin_lnum, l:end_lnum), "\n")
  let l:result   = systemlist(s:cmd_for_type[l:pem_type], l:pem_data)

  if v:shell_error != 0
    echohl ErrorMsg | echom 'pem: openssl error: ' . join(l:result, ' ') | echohl None
    return
  endif

  new
  call setline(1, l:result)
  setlocal buftype=nofile bufhidden=wipe noswapfile nomodifiable readonly nobuflisted filetype=opensslout
  execute 'file ' . fnameescape('PEM: ' . l:pem_type)
  nnoremap <buffer> q :bwipeout<CR>
endfunction

command! -buffer PemDecode call <SID>DecodePemBlock()

nnoremap <buffer> <Plug>PemDecode :call <SID>DecodePemBlock()<CR>
if !hasmapto('<Plug>PemDecode', 'n')
  nmap <buffer> <localleader>d <Plug>PemDecode
endif
