if !has('patch-8.2.1978') && !has('nvim-0.4')
  finish
endif

command! -buffer PemDecode call pem#DecodePemBlock()

nnoremap <buffer> <Plug>PemDecode <Cmd>call pem#DecodePemBlock()<CR>
if !hasmapto('<Plug>PemDecode', 'n')
  nmap <buffer> <localleader>d <Plug>PemDecode
endif
