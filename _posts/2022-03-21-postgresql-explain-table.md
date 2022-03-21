---
title:  "PostgreSQL - check table definition"
date:   2022-03-21
categories: DEV
tags: postgresql
---

How to check table definition in PostgreSQL DB

```postgresql
SELECT *
FROM information_schema.columns
WHERE table_schema = 'YOUR_SCHEMA' AND table_name = 'YOUR_TABLE'
ORDER BY ordinal_position;
```

where:
 * **YOUR_SCHEMA** represents schema where table is defined
 * **YOUR_TABLE** represents table name

