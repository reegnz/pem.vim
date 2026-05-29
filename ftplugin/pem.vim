if !has('patch-8.2.1978') && !has('nvim-0.4')
  finish
endif

if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

setlocal nomodifiable

let b:undo_ftplugin = 'setlocal modifiable | delcommand PemDecode | delcommand PemDecodeAll | nunmap <buffer> <Plug>(pem-decode) | nunmap <buffer> <Plug>(pem-decode-all) | unlet! b:did_ftplugin'

command! -buffer PemDecode    call pem#DecodePemBlock()
command! -buffer PemDecodeAll call pem#DecodeAllPemBlocks()

nnoremap <buffer> <Plug>(pem-decode)     <Cmd>call pem#DecodePemBlock()<CR>
nnoremap <buffer> <Plug>(pem-decode-all) <Cmd>call pem#DecodeAllPemBlocks()<CR>
if !hasmapto('<Plug>(pem-decode)', 'n')
  nmap <buffer> <localleader>d <Plug>(pem-decode)
  let b:undo_ftplugin .= ' | nunmap <buffer> <localleader>d'
endif
if !hasmapto('<Plug>(pem-decode-all)', 'n')
  nmap <buffer> <localleader>D <Plug>(pem-decode-all)
  let b:undo_ftplugin .= ' | nunmap <buffer> <localleader>D'
endif
