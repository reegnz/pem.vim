autocmd BufNewFile,BufRead *.pem,*.crt,*.cer,*.key set filetype=pem
autocmd BufNewFile,BufRead,StdinReadPost * if getline(1) =~# '^-----BEGIN ' | setfiletype pem | endif
