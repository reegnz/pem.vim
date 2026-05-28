command! -buffer PemDecode call pem#DecodePemBlock()

nnoremap <buffer> <Plug>PemDecode <Cmd>call pem#DecodePemBlock()<CR>
if !hasmapto('<Plug>PemDecode', 'n')
  nmap <buffer> <localleader>d <Plug>PemDecode
endif
