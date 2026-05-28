augroup pem_ftdetect
  autocmd!
  autocmd BufNewFile,BufRead *.pem,*.crt,*.cer,*.key setfiletype pem
  autocmd BufNewFile,BufRead,StdinReadPost * if getline(1) =~# '^-----BEGIN ' | setfiletype pem | endif
augroup END
