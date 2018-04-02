# HmCrypto

[![CircleCI](https://circleci.com/gh/heathmont/hm-crypto.svg?style=shield&circle-token=c1b594b3ee6dadc82c44d0c0e6d68db18230e324)](https://circleci.com/gh/heathmont/hm-crypto)

Elixir library for signing and validating requests

## Installation

```elixir
def deps do
  [
    {:hm_crypto, git: "git@github.com:heathmont/hm-crypto.git"}
  ]
end
```

## Usage

Availiable digest types (see rsa_digest_type() in [docs](http://erlang.org/doc/man/public_key.html)) are :md5, :ripemd160, :sha, :sha224, :sha256, :sha384, :sha512. `HmCrypto.sign!` returns base64 string. `HmCrypto.valid?` returns false if signature is not base64 string.
