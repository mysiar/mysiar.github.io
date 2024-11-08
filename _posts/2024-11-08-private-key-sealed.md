---
title: "Sealing keys in bitnami-labs/sealed-secrets"
date: 2024-11-08
categories: DEVOPS
tags: kubernetes secret 
---

* key example `key.txt`
    ```
    -----BEGIN PRIVATE KEY-----
    ... key content
    -----END PRIVATE KEY-----
    ```
* encode key
    ```bash
    base64 -w 0 key.txt > encoded.key.txt
    ``` 
* copy content of `encoded.key.txt` to you yaml open secret file variable ie. `PRIVATE_KEY`
* seal it
* deploy
* in Python to get exact the same string with key use
    ```python
    import base64
    import os
    
    key = base64.b64decode(os.getenv("PRIVATE_KEY")).decode("utf-8)
    ```
