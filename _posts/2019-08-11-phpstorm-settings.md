---
layout: post
title:  "PhpStorm - settings: vmoptions"
date:   2019-08-11
categories: DEV
tags: php phpstorm
---

find [PHPStorm settings folder](https://intellij-support.jetbrains.com/hc/en-us/articles/206544519) and edit `.vmoptions`

```
-server
-Xms2048m
-Xmx4096m
-XX:MaxPermSize=350m
-XX:ReservedCodeCacheSize=256m
-XX:+UseConcMarkSweepGC
-XX:+UseParNewGC
-XX:SoftRefLRUPolicyMSPerMB=50
-XX:+CMSParallelRemarkEnabled
-XX:ConcGCThreads=4
-XX:+TieredCompilation
-XX:+UseCompressedOops
-XX:+HeapDumpOnOutOfMemoryError
-ea
-Dsun.io.useCanonCaches=false
-Djava.net.preferIPv4Stack=true
```

where:
* Xmx - max memory PHPStorm can use
