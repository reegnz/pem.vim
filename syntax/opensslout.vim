if exists("b:current_syntax")
  finish
endif

" Section headers: lines ending with a colon (no value), or bare capitalized labels (e.g. "Validity")
syntax match opensslSection /^\s*\S[^:]*:\s*$/
syntax match opensslSection /^\s*[A-Z][A-Za-z0-9 ]*$/

" Field labels: the key in "key: value" or "key:value" lines (must start with a letter to avoid hex)
syntax match opensslLabel /^\s*\zs[A-Za-z][^:]*\ze:/

" Colon-separated hex (serial numbers, signatures, pubkeys)
syntax match opensslHex /\<[0-9a-fA-F]\{2\}\(:[0-9a-fA-F]\{2\}\)\+\>/

" OIDs
syntax match opensslOid /\<\d\+\(\.\d\+\)\{3,\}\>/

" Dates
syntax match opensslDate /\w\{3\}\s\+\d\+\s\+\d\d:\d\d:\d\d \d\{4\} GMT/

highlight default link opensslSection  Identifier
highlight default link opensslLabel    Identifier
highlight default link opensslHex      Number
highlight default link opensslOid      Special
highlight default link opensslDate     String

let b:current_syntax = "opensslout"
