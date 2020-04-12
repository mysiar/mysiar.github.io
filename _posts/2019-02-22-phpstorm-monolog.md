---
title:  "PhpStorm - monolog in colours"
date:   2019-02-22
categories: DEV
tags: php phpstorm
---


PhpStorm [Ideolog](https://plugins.jetbrains.com/plugin/9746-ideolog){:target="_blank"} extension configuration for monolog

```
Message pattern: `^\[(.*)\] (.+?)\.([A-Z]+): (.*)`
Message start pattern: `^\[`
Time format: `yyyy-MM-dd HH:mm:ss`
Time capture group: `1`
Severity capture group: `3`
Category capture group: `2`
```

