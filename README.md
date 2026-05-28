# pem.vim

Vim filetype plugin for PEM-encoded files.

## Features

- Filetype detection for `*.pem`, `*.crt`, `*.cer`, `*.key`, and any file starting with `-----BEGIN`
- Syntax highlighting for PEM banners, types, and base64 data
- Decode PEM blocks with `<localleader>d`: runs the appropriate `openssl` command and displays the result in a scratch buffer with syntax highlighting
- Decode all PEM blocks in the file with `<localleader>D`: collects output from every block into a single scratch buffer

## Supported PEM types

| Type | Command |
|------|---------|
| `CERTIFICATE` | `openssl x509` |
| `CERTIFICATE REQUEST` / `NEW CERTIFICATE REQUEST` | `openssl req` |
| `RSA/DSA/EC PRIVATE KEY` | `openssl rsa/dsa/ec` |
| `PRIVATE KEY` / `ENCRYPTED PRIVATE KEY` | `openssl pkey` |
| `PUBLIC KEY` / `RSA PUBLIC KEY` | `openssl pkey/rsa -pubin` |
| `X509 CRL` | `openssl crl` |
| `PKCS7` | `openssl pkcs7` |

## Requirements

- `openssl` in `$PATH`
