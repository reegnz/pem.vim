if !has('patch-8.2.1978') && !has('nvim-0.4')
  finish
endif

if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

setlocal nomodifiable

let b:undo_ftplugin = 'setlocal modifiable | delcommand PemDecode | delcommand PemDecodeAll | nunmap <buffer> <Plug>PemDecode | nunmap <buffer> <Plug>PemDecodeAll | unlet! b:did_ftplugin'

command! -buffer PemDecode    call pem#DecodePemBlock()
command! -buffer PemDecodeAll call pem#DecodeAllPemBlocks()

nnoremap <buffer> <nowait> <Plug>PemDecode    <Cmd>call pem#DecodePemBlock()<CR>
nnoremap <buffer> <Plug>PemDecodeAll <Cmd>call pem#DecodeAllPemBlocks()<CR>
if !hasmapto('<Plug>PemDecode', 'n')
  nmap <buffer> <localleader>d <Plug>PemDecode
  let b:undo_ftplugin .= ' | nunmap <buffer> <localleader>d'
endif
if !hasmapto('<Plug>PemDecodeAll', 'n')
  nmap <buffer> <localleader>D <Plug>PemDecodeAll
  let b:undo_ftplugin .= ' | nunmap <buffer> <localleader>D'
endif
