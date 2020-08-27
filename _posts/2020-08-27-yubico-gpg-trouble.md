---
title:  "Yubico key gpg trouble"
date:   2020-08-27
categories: DEVOPS
tags: encryption yubico
---

## Issue
```
gpg --card-status
gpg: selecting card failed: Broken pipe
gpg: OpenPGP card not available: Broken pipe
```

## Solution

.gnupg/scdaemon.conf

```
reader-port Yubico Yubi
pcsc-driver /snap/yubioath-desktop/7/usr/lib/libpcsclite.so
card-timeout 5
disable-ccid
```

