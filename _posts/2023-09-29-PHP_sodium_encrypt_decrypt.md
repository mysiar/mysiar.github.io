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


    private function dencrypt(string $data, string $key): string
    {
        $decoded = base64_decode($data, true);
        $nonce = mb_substr($decoded, 0, SODIUM_CRYPTO_SECRETBOX_NONCEBYTES, '8bit');
        $ciphertext = mb_substr($decoded, SODIUM_CRYPTO_SECRETBOX_NONCEBYTES, null, '8bit');        
 
        $plain = sodium_crypto_secretbox_open($ciphertext, $nonce, $key);
        if (! is_string($plain)) {
            throw new \Exception('Invalid MAC');
        }
        sodium_memzero($ciphertext);
        sodium_memzero($key);
        return $plain;       
    }
```
