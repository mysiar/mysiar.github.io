---
title:  "Latest CURL from source"
date:   2020-04-23
categories: DEVOPS
tags: src ubuntu
---

Tested on Ubuntu **18.04** with [curl-7.69.1](https://github.com/curl/curl/releases/tag/curl-7_69_1)

* get latest src release from [https://github.com/curl/curl](https://github.com/curl/curl)
* `sudo apt -y install libtool make`
* `./buildconf`
* configure
    ```
          ./configure --disable-libcurl-option \
            --with-ssl \
            --disable-static \
            --enable-threaded-resolver \
            --with-ca-path=/etc/ssl/certs            
    ```
* `make`
* and when you are ready
    * `sudo apt -y purge curl`
    * `sudo make install`
* check if it works `curl -V`
* in case error  
  `curl: symbol lookup error: curl: undefined symbol: curl_url_cleanup`  
  run `sudo ldconfig`
* and try again `curl -V`, result should be:

    ```
    curl 7.69.1 (x86_64-pc-linux-gnu) libcurl/7.69.1 OpenSSL/1.1.1d zlib/1.2.11 nghttp2/1.30.0
    Release-Date: 2020-03-11
    Protocols: dict file ftp ftps gopher http https imap imaps pop3 pop3s rtsp smb smbs smtp smtps telnet tftp 
    Features: AsynchDNS HTTP2 HTTPS-proxy IPv6 Largefile libz NTLM NTLM_WB SSL TLS-SRP UnixSockets
    ```

