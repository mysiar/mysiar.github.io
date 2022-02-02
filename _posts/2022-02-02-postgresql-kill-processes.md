---
title:  "PostgreSQL - kill all processes except my own connection"
date:   2022-02-02
categories: DEV
tags: postgresql
---

How to kill all processes except my own connection to specific DB

```postgresql
SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE pid <> pg_backend_pid()
AND datname = 'database_name';
```

where 'database_name' is your DB that you are working on.
