if !has('patch-8.2.1978') && !has('nvim-0.4')
  finish
endif

if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

let b:undo_ftplugin = 'delcommand PemDecode | nunmap <buffer> <Plug>PemDecode'

command! -buffer PemDecode call pem#DecodePemBlock()

nnoremap <buffer> <Plug>PemDecode <Cmd>call pem#DecodePemBlock()<CR>
if !hasmapto('<Plug>PemDecode', 'n')
  nmap <buffer> <localleader>d <Plug>PemDecode
  let b:undo_ftplugin .= ' | nunmap <buffer> <localleader>d'
endif
