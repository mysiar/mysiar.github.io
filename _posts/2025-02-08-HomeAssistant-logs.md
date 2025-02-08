---
title: "Home Assistant logs in OpenObserve - part 1"
date: 2025-02-08
categories: HomeAssistant
tags: logs 
---

## Requirements
* instance of HomeAssistant obviously ;)
* instance of OpenObserve, I have mine in Proxmox container. 
* install Fluent Bit HA addon [https://github.com/ablyler/ha-addon-fluent-bit](https://github.com/ablyler/ha-addon-fluent-bit)

## Configuration
* I created a `parsers.conf` file to have option to add custom parsers. FIle is basically a copy from fluent-bit github repository. File location `/addon_configs/144431fc_fluent_bit/parsers.conf`, Link to the file in Resources 
* If you do not need custom parsers and `parser.conf` file, skip file creation and remove `Parsers_File` line from `SERVICE` definition
* Create `/addon_configs/144431fc_fluent_bit/fluent_bit.conf`

fluent_bit.conf
```
[SERVICE]
    Flush           1
    Log_Level       info
    Parsers_File    /config/parsers.conf


[INPUT]
    Name systemd
    Path /var/log/journal
    DB /data/fluent-bit.db

[FILTER]
    name   grep
    match  *

    exclude SYSLOG_IDENTIFIER addon_144431fc_fluent_bit
    exclude SYSLOG_IDENTIFIER addon_45df7312_zigbee2mqtt
    exclude SYSLOG_IDENTIFIER kernel
    exclude SYSLOG_IDENTIFIER audit
    exclude SYSLOG_IDENTIFIER NetworkManager
    exclude SYSLOG_IDENTIFIER systemd
    exclude SYSLOG_IDENTIFIER containerd
    exclude SYSLOG_IDENTIFIER qemu-ga
    exclude SYSLOG_IDENTIFIER dockerd
    exclude SYSLOG_IDENTIFIER addon_core_mosquitto


[OUTPUT]
    Name            http
    Match           *
    URI             /api/default/default/_json
    Host            <your OpenObserve host or IP address>
    Port            5080
    tls             Off
    Format          json
    Json_date_key   _timestamp
    Json_date_format iso8601
    HTTP_User       <your OpenObserve user>
    HTTP_Passwd     <your OpenObserve user password>
    compress        gzip
```
Filter exclude statements are to skip some logs.

This can be configured as required

## Resources
* OpenObserve install script [https://community-scripts.github.io/ProxmoxVE/scripts?id=openobserve](https://community-scripts.github.io/ProxmoxVE/scripts?id=openobserve) 
* Fluent Bit `parser.conf`  [https://github.com/fluent/fluent-bit/blob/master/conf/parsers.conf](https://github.com/fluent/fluent-bit/blob/master/conf/parsers.conf)
* [OpenObserve documentation](https://openobserve.ai/docs/)
* [Fluent Bit documentation](https://docs.fluentbit.io/manual)
