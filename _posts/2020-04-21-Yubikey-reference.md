---
title:  "YubiKey 5 NFC - configuration reference"
date:   2020-04-21
categories: SECURITY
tags: yubico yubikey
---

## Reference list I used to play and configure YubiKey 5 NFC

* [https://www.yubico.com/works-with-yubikey/catalog/ubuntu/](https://www.yubico.com/works-with-yubikey/catalog/ubuntu/)
* [https://zeos.ca/post/2018/gpg-yubikey5/](https://zeos.ca/post/2018/gpg-yubikey5/)
* [https://ocramius.github.io/blog/yubikey-for-ssh-gpg-git-and-local-login/](https://ocramius.github.io/blog/yubikey-for-ssh-gpg-git-and-local-login/)
* [https://metebalci.com/blog/using-u2f-at-linux-login/](https://metebalci.com/blog/using-u2f-at-linux-login/)

`/etc/pam.d/common-auth`
```
    auth    required    pam_u2f.so authfile=/etc/Yubico/u2f_keys origin=pam://<HOSTNAME> appid=pam://<HOSTNAME> debug debug_file=/var/log/pam_u2f.log
```
where:
 * <HOSTNAME> is your hostname
 * debug entries only if you want to see log
