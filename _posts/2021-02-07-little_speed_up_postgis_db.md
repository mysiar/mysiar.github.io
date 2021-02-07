---
title:  "PostgreSQL + PostGIS little speed up for QGIS"
date:   2021-02-07
categories: DEVOPS
tags: db postgresql
---



Quick optimization using [PGTune](https://pgtune.leopard.in.ua) allowed me to speed up of displaying 137 milions of geometry points with color attributes based on one field value 7% faster than original Ubuntu server PostgreSQL config.

Software versions:
* lxc container with Ubuntu server: **18.04.03**
* PostgreSQL: **11.5**
* PostGIS: **2.5**

```
# DB Version: 11
# OS Type: linux
# DB Type: mixed
# Total Memory (RAM): 32 GB
# CPUs num: 16
# Connections num: 50
# Data Storage: ssd

max_connections = 50
shared_buffers = 8GB
effective_cache_size = 24GB
maintenance_work_mem = 2GB
checkpoint_completion_target = 0.9
wal_buffers = 16MB
default_statistics_target = 100
random_page_cost = 1.1
effective_io_concurrency = 200
work_mem = 20971kB
min_wal_size = 1GB
max_wal_size = 4GB
max_worker_processes = 16
max_parallel_workers_per_gather = 4
max_parallel_workers = 16
max_parallel_maintenance_workers = 4
```


