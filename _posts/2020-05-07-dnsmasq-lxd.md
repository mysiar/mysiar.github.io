---
title:  "LXD dnsmasq as the whole resolver"
date:   2020-04-23
categories: DEVOPS
tags: lxd dns
---

## Intro

No need systemd resolver, no need extra dnsmasq service, as long you running LXD and LXD uses dnsmasq

## My host environment

* my host LXD bridge is **lxdbr0** with IP address **10.56.207.1**
* systemd-resolv service is disabled and masked
* not have extra dnsmasq service running at all
* the only dnsmasq running on the system is the one LXD created
* `/etc/resolv.conf`

    ```
          nameserver 10.56.207.1
    ```

* now config of LXD network for **lxdbr0** bridge

    ```
    config:
      ipv4.address: 10.56.207.1/24
      ipv4.nat: "true"
      ipv6.address: fd42:2455:a79e:124b::1/64
      ipv6.nat: "true"
      raw.dnsmasq: |
        server=192.168.1.197
        server=1.1.1.1
        server=8.8.8.8
        domain-needed
        bogus-priv
        no-hosts
        no-negcache
        no-poll
        server=/.xx/10.101.211.1
        server=/.xx/10.101.212.1
        server=/.xx/10.101.213.1
        server=/.lxd3/10.101.222.1
    description: ""
    name: lxdbr0
    type: bridge
    ```
    the whole "magic" is done after the `raw.dnsmasq: |`

  * `server=<IP>` are just name servers for so called Internet access
  * `server=server=/.xx/10.101.211.1` - this resolves all hosts in domain .xx
  * `server=/.lxd3/10.101.222.1` - - this resolves all hosts in domain .lxd3
  * and etc, you are free to do anything

I strugled long time and finally I got it done today with my mate **Filip**, which is the whole architect behind it.
