---
title:  "Xdebug config"
date:   2020-12-11
categories: DEV
tags: php
---


export XDEBUG_CONFIG=""


```
zend_extension=xdebug.so

xdebug.cli_color=1
xdebug.coverage_enable=On
xdebug.mode=develop,debug,coverage
xdebug.log=/tmp/xdebug.log
xdebug.log_level=10
xdebug.client_port=9003
xdebug.remote_enable=on
xdebug.default_enable=on
xdebug.remote_autostart=off
xdebug.remote_port=9000
xdebug.remote_host=localhost
xdebug.profiler_enable_trigger=1
xdebug.profiler_output_name=xdebug-profile-cachegrind.out-%H-%R
xdebug.var_display_max_children = 128
xdebug.var_display_max_data = 512
xdebug.var_display_max_depth = 3
xdebug.remote_enable = 1
xdebug.idekey = PHPSTORM
xdebug.show_error_trace = 1
xdebug.file_link_format = phpstorm://open?%f:%l
```

