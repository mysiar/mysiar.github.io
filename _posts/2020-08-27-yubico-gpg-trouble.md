---
title:  "Yubico key gpg trouble"
date:   2020-08-27
categories: DEVOPS
tags: encryption yubico security
--------------------------------

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
pcsc-driver /snap/yubioath-desktop/current/usr/lib/libpcsclite.so
card-timeout 5
disable-ccid
```

```
sudo systemctl restart pcscd
```

