---
title:  "PostgreSQL - check current DB operations"
date:   2022-02-02
categories: DEV
tags: postgresql
---

How to check current DB operations

```postgresql
SELECT pid, age(clock_timestamp(), query_start), usename, query 
FROM pg_stat_activity 
WHERE query != '<IDLE>' AND query NOT ILIKE '%pg_stat_activity%' 
ORDER BY query_start desc;
```


