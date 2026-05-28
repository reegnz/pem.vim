if exists("b:current_syntax")
  finish
endif

syntax match pemBanner /^-----\%(BEGIN\|END\) [A-Z ]\+-----$/ contains=pemType
syntax match pemType /\%(BEGIN\|END\) \zs[A-Z ]\+\ze-----/ contained
syntax match pemBase64 /^[A-Za-z0-9+/=]\+$/

highlight default link pemBanner Delimiter
highlight default link pemType Type
highlight default link pemBase64 Comment

let b:current_syntax = "pem"
