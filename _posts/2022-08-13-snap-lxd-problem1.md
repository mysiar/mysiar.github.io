---
title:  "snap LXD problem - container doesn't start"
date:   2022-08-13
categories: DEVOPS
tags: ubuntu lxd
---

* container doesn't start
  
  ```bash
  $ lxc start postgres-test
  Error: Failed to run: /snap/lxd/current/bin/lxd forkstart postgres-test /var/snap/lxd/common/lxd/containers /var/snap/lxd/common/lxd/logs/postgres-test/lxc.conf: 
  Try `lxc info --show-log postgres-test` for more info
  ```

  ```bash
  $ lxc info --show-log postgres-test
  Name: postgres-test
  Status: STOPPED
  Type: container
  Architecture: x86_64
  Created: 2022/08/13 11:56 CEST
  Last Used: 2022/08/13 11:57 CEST
  
  Log:
  
  lxc postgres-test 20220813095759.893 WARN     conf - ../src/src/lxc/conf.c:lxc_map_ids:3592 - newuidmap binary is missing
  lxc postgres-test 20220813095759.893 WARN     conf - ../src/src/lxc/conf.c:lxc_map_ids:3598 - newgidmap binary is missing
  lxc postgres-test 20220813095759.894 WARN     conf - ../src/src/lxc/conf.c:lxc_map_ids:3592 - newuidmap binary is missing
  lxc postgres-test 20220813095759.894 WARN     conf - ../src/src/lxc/conf.c:lxc_map_ids:3598 - newgidmap binary is missing
  lxc postgres-test 20220813095759.974 ERROR    cgfsng - ../src/src/lxc/cgroups/cgfsng.c:cgfsng_mount:2131 - No such file or directory - Failed to create cgroup at_mnt 23()
  lxc postgres-test 20220813095759.974 ERROR    conf - ../src/src/lxc/conf.c:lxc_mount_auto_mounts:851 - No such file or directory - Failed to mount "/sys/fs/cgroup"
  lxc postgres-test 20220813095759.974 ERROR    conf - ../src/src/lxc/conf.c:lxc_setup:4396 - Failed to setup remaining automatic mounts
  lxc postgres-test 20220813095759.974 ERROR    start - ../src/src/lxc/start.c:do_start:1272 - Failed to setup container "postgres-test"
  lxc postgres-test 20220813095759.974 ERROR    sync - ../src/src/lxc/sync.c:sync_wait:34 - An error occurred in another process (expected sequence number 4)
  lxc postgres-test 20220813095759.979 WARN     network - ../src/src/lxc/network.c:lxc_delete_network_priv:3631 - Failed to rename interface with index 0 from "eth0" to its initial name "vethd67375f8"
  lxc postgres-test 20220813095759.979 ERROR    start - ../src/src/lxc/start.c:__lxc_start:2107 - Failed to spawn container "postgres-test"
  lxc postgres-test 20220813095759.979 ERROR    lxccontainer - ../src/src/lxc/lxccontainer.c:wait_on_daemonized_start:877 - Received container state "ABORTING" instead of "RUNNING"
  lxc postgres-test 20220813095759.979 WARN     start - ../src/src/lxc/start.c:lxc_abort:1036 - No such process - Failed to send SIGKILL via pidfd 19 for process 36878
  lxc postgres-test 20220813095805.788 WARN     conf - ../src/src/lxc/conf.c:lxc_map_ids:3592 - newuidmap binary is missing
  lxc postgres-test 20220813095805.789 WARN     conf - ../src/src/lxc/conf.c:lxc_map_ids:3598 - newgidmap binary is missing
  lxc 20220813095805.113 ERROR    af_unix - ../src/src/lxc/af_unix.c:lxc_abstract_unix_recv_fds_iov:218 - Connection reset by peer - Failed to receive response
  lxc 20220813095805.113 ERROR    commands - ../src/src/lxc/commands.c:lxc_cmd_rsp_recv_fds:128 - Failed to receive file descriptors for command "get_state"
  ```
  
* solution that fixed that problem
  ```bash
  $ sudo umount /sys/fs/cgroup/net_cls
  $ lxc start postgres-test
  $ lxc ls
  +---------------+---------+---------------------+-----------------------------------------------+-----------+-----------+
  |     NAME      |  STATE  |        IPV4         |                     IPV6                      |   TYPE    | SNAPSHOTS |
  +---------------+---------+---------------------+-----------------------------------------------+-----------+-----------+
  | postgres-test | RUNNING | 10.11.56.165 (eth0) | fd42:b332:99c3:3d84:216:3eff:fe3a:73fe (eth0) | CONTAINER | 0         |
  +---------------+---------+---------------------+-----------------------------------------------+-----------+-----------+  
  ```

## Resources
* [https://discuss.linuxcontainers.org/t/help-help-help-cgroup2-related-issue-on-ubuntu-jammy/14705](https://discuss.linuxcontainers.org/t/help-help-help-cgroup2-related-issue-on-ubuntu-jammy/14705)
