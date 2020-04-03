---
title:  "LXD - problem to delete container"
date:   2019-12-22
categories: DEVOPS
tags: lxd
---

I run today into problem of deleting a LXD container

run
```
lxc delete rough-container
```

result
```
Error: Failed to destroy ZFS dataset: Failed to run: zfs destroy -r lxd/containers/rough-container: cannot destroy 'lxd/containers/rough-container': dataset is busy
```

run
```
grep lxd/containers/rough-container /proc/*/mounts
```

result
```
/proc/2063416/mounts:lxd/containers/rough-container /var/snap/lxd/common/lxd/storage-pools/local/containers/rough-container zfs rw,relatime,xattr,posixacl 0 0
/proc/3522797/mounts:lxd/containers/rough-container /var/snap/lxd/common/lxd/storage-pools/local/containers/rough-container zfs rw,relatime,xattr,posixacl 0 0
/proc/3544936/mounts:lxd/containers/rough-container /var/snap/lxd/common/lxd/storage-pools/local/containers/rough-container zfs rw,relatime,xattr,posixacl 0 0
/proc/3545160/mounts:lxd/containers/rough-container /var/snap/lxd/common/lxd/storage-pools/local/containers/rough-container zfs rw,relatime,xattr,posixacl 0 0
```

solution
```
nsenter -t 2063416 -m -- umount /var/snap/lxd/common/lxd/storage-pools/local/containers/rough-container
```

check - this should not return anything
```
grep lxd/containers/rough-container /proc/*/mounts
```

and try again to delete this rough-container
