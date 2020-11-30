---
title:  "Linux Encrypted drive - notes 1"
date:   2020-10-30
categories: DEVOPS
tags: linux security encryption
---

### Encrypting and creating volumes

#### Encrypting whole drive
```
    cryptsetup luksFormat --type luks2 /dev/sdb
```

#### Opening encrypted drive
```
    cryptsetup luksOpen /dev/sdb data
```

#### Volume management
```
    pvcreate /dev/mapper/data
    
    vgcreate vgdata /dev/mapper/data
    
    lvcreate -l 100%FREE -n data vgdata
```

#### Closing encrypted drive
```
    cryptsetup close data
    # if problemm occurs try below before closing 
    vgchange -a -n vgdata
```


### Resizing

#### Resizing file system
```
    resizefs /dev/vgdata/data 200G
```

#### Resizing logical volume
```
    lvresize -L 200G /dev/vgdata/data
```
