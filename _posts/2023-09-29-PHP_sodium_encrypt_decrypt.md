---
title:  "PHP - sodium encrypt & decrypt"
date:   2023-09-29
categories: DEV
tags: php 
---


Simple encrypt and decrypt using libsodium,  
key length has to equal to SODIUM_CRYPTO_SECRETBOX_KEYBYTES

```php
    private function encrypt(string $data, string $key): string
    {
        $nonce = random_bytes(SODIUM_CRYPTO_SECRETBOX_NONCEBYTES);

        $cipher = base64_encode(
            $nonce.
            sodium_crypto_secretbox(
                $data,
                $nonce,
                $key
            )
        );
        sodium_memzero($data);
        sodium_memzero($key);
        return $cipher;
    }


    private function encrypt(string $data, string $key): string
    {
        $nonce = random_bytes(SODIUM_CRYPTO_SECRETBOX_NONCEBYTES);

        $cipher = base64_encode(
            $nonce.
            sodium_crypto_secretbox(
                $data,
                $nonce,
                $key
            )
        );
        sodium_memzero($data);
        sodium_memzero($key);
        return $cipher;
    }
```
